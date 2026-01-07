import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/domain/enums/auth_failure.dart';
import 'package:sleep_sync_app/features/auth/domain/repositories/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Stream<AppUser?> get onAuthStateChanged {
    return _auth.authStateChanges().switchMap((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      }

      return _db.collection('users').doc(firebaseUser.uid).snapshots().switchMap((userSnap) {
        final userData = userSnap.data();
        final partnerId = userData?['partnerId'] as String?;

        if (partnerId == null || partnerId.isEmpty) {
          return Stream.value(AppUser.fromMap(
            userData!, 
            firebaseUser.uid, 
            firebaseUser.email, 
            firebaseUser.emailVerified, 
            ''));
        }

        return Stream.fromFuture(_db.collection('users').doc(partnerId).get()).map((partnerSnap) {
          final partnerName = partnerSnap.data()?['name'] as String? ?? "";
          
          return AppUser.fromMap(
            userData!, 
            firebaseUser.uid, 
            firebaseUser.email ?? '', 
            firebaseUser.emailVerified,
            partnerName,
          );
        });
      });
    });
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e.code);
    } catch (e) {
      throw 'unknown-error';
    }
  }

  @override
  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      final uid = credential.user!.uid;
      await _db.collection('users').doc(uid).set({
        'email': email,
        'uid': uid,
        'name': name,
        'partnerId': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      await credential.user?.sendEmailVerification();

    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e.code);
    } catch (e) {
      throw 'unknown-error';
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth == null) return;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      final userDoc = await _db.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _db.collection('users').doc(user.uid).set({
          'email': user.email,
          'uid': user.uid,
          'partnerId': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e.code);
    } catch (e) {
      throw 'unknown-error';
    }
  }
  
  @override
  Future<void> sendPasswordResetEmail(String email) {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e.code);
    } catch (e) {
      throw 'unknown-error';
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e.code);
    } catch (e) {
      throw 'unknown-error';
    }
  }

  AuthFailure _handleAuthException(String code) {
    return switch (code) {
      'invalid-credential' => AuthFailure.invalidCredential,
      'invalid-email' => AuthFailure.invalidEmail,
      'user-not-found' => AuthFailure.userNotFound,
      'wrong-password' => AuthFailure.wrongPassword,
      'email-already-in-use' => AuthFailure.emailAlreadyInUse,
      'network-request-failed' => AuthFailure.networkError,
      'web-context-cancelled' || 'account-selection-required' => AuthFailure.cancelledByUser,
      _ => AuthFailure.unknown,
    };
  }
}