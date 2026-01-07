import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sleep_sync_app/features/profile/domain/enum/profile_failure.dart';
import 'package:sleep_sync_app/features/profile/domain/repositories/i_profile_repository.dart';

class FirebaseProfileRepository implements IProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseProfileRepository();

  @override
  Future<ProfileFailure> updateName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) ProfileFailure.noAuthenticatedUser;

    await user?.updateDisplayName(newName);
    await _db.collection('users').doc(user?.uid).update({
      'name': newName,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return ProfileFailure.none;
  }
  
  @override
  Future<void> updatePhoto(String url) {
    throw UnimplementedError();
  }

  @override
  Future<ProfileFailure> unlink() async {
    try {
      final myUid = _auth.currentUser?.uid;
      if (myUid == null) return ProfileFailure.noAuthenticatedUser;
      final myDoc = await _db.collection('users').doc(myUid).get();
      final String? partnerUid = myDoc.data()?['partnerId'];
      final String? myPairingCode = myDoc.data()?['pairingCode'];

      if (partnerUid == null || partnerUid.trim().isEmpty) {
        return ProfileFailure.notLinked;
      }
      
      final partnerDoc = await _db.collection('users').doc(partnerUid).get();
      final String? partnerPairingCode = partnerDoc.data()?['pairingCode'];

      final batch = _db.batch();

      batch.update(_db.collection('users').doc(myUid), {'partnerId': FieldValue.delete()});
      batch.update(_db.collection('users').doc(partnerUid), {'partnerId': FieldValue.delete()});

      if (myPairingCode != null && myPairingCode.isNotEmpty) {
        _addReleaseCodeToBatch(batch, myPairingCode);
      }

      if (partnerPairingCode != null && partnerPairingCode.isNotEmpty) {
        _addReleaseCodeToBatch(batch, partnerPairingCode);
      }

      await batch.commit();
      return ProfileFailure.none;
    } on FirebaseException catch (e) {
      return _handleFirebaseException(e.code);
    } catch (e) {
      return ProfileFailure.serverError;
    }
  }
  ProfileFailure _handleFirebaseException(String code) {
    return switch (code) {
      'permission-denied' => ProfileFailure.permissionDenied,
      'network-request-failed' => ProfileFailure.networkError,
      'unavailable' => ProfileFailure.serverError,
      _ => ProfileFailure.serverError,
    };
  }

  void _addReleaseCodeToBatch(WriteBatch batch, String code) {
    batch.update(_db.collection('link_codes').doc(code), {
      'isAvailable': true,
      'usedBy': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}