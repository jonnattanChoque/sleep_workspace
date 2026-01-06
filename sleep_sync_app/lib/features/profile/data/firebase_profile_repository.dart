import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sleep_sync_app/features/profile/domain/repositories/i_profile_repository.dart';

class FirebaseProfileRepository implements IProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseProfileRepository();

  @override
  Future<void> updateName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await user.updateDisplayName(newName);
    await _db.collection('users').doc(user.uid).update({
      'name': newName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  @override
  Future<void> updatePhoto(String url) {
    throw UnimplementedError();
  }
}