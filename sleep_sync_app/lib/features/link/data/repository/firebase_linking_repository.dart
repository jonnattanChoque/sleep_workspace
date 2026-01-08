import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_record_model.dart';
import 'package:sleep_sync_app/features/link/domain/repository/i_linking_repository.dart';

class FirebaseLinkingRepository implements IlinkingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentFirebaseUser => _auth.currentUser;

  @override
  Stream<List<SleepRecord>> get onSleepLogsChanged {
    final user = _auth.currentUser; 
    if (user == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('sleep_logs')
        .orderBy('date', descending: true)
        .limit(7)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SleepRecord.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> addSleepRecord(SleepRecord record, AppUser appUser) async {
    final userRef = _db.collection('users').doc(appUser.uid);
    final recordRef = userRef.collection('sleep_logs').doc(record.id);
    final batch = _db.batch();

    try {
      batch.set(recordRef, record.toMap());
      batch.update(userRef, {
        'stats': appUser.stats.toMap(),
      });
      
      await batch.commit();
    } catch (e) {
      rethrow; 
    }
  }
}