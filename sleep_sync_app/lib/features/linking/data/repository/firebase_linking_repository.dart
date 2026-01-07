import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_sync_app/features/linking/domain/enum/linking_failure.dart';
import 'package:sleep_sync_app/features/linking/domain/repository/i_linking_repository.dart';

class FirebaseLinkingRepository implements ILinkingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentFirebaseUser => _auth.currentUser;

  @override
  Future<String?> getUserLinkCode(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['pairingCode'] as String?;
  }

  @override
  Future<void> saveUserLinkCode(String uid, String code) async {
    final batch = _db.batch();
    batch.update(_db.collection('users').doc(uid), {'pairingCode': code});
    batch.set(_db.collection('link_codes').doc(code), {'userId': uid});
    await batch.commit();
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }
  
  @override
  Future<LinkingFailure> linkWithPartner({
    required String myUid, 
    required String partnerCode,
  }) async {
    try {
      final codeDoc = await _db.collection('link_codes').doc(partnerCode).get();
      if (!codeDoc.exists) return (LinkingFailure.invalidCode);

      final String? partnerUid = codeDoc.data()?['userId'];
      final bool isAvailable = codeDoc.data()?['isAvailable'] ?? true; 
      if (!isAvailable) return LinkingFailure.partnerAlreadyLinked;
      if (partnerUid == null) return (LinkingFailure.invalidCode);
      if (partnerUid == myUid) return (LinkingFailure.selfLinking);

      final partnerDoc = await _db.collection('users').doc(partnerUid).get();
      if (!partnerDoc.exists) return LinkingFailure.invalidCode;


      final partnerData = partnerDoc.data();
      final partnerId = partnerData?['partnerId'];
      if (partnerId != null && partnerId.toString().isNotEmpty) {
        return (LinkingFailure.partnerAlreadyLinked);
      }

      final batch = _db.batch();
      batch.update(_db.collection('users').doc(myUid), {'partnerId': partnerUid});
      batch.update(_db.collection('users').doc(partnerUid), {'partnerId': myUid});
      batch.update(_db.collection('link_codes').doc(partnerCode), {
        'isAvailable': false,
        'usedBy': myUid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      return LinkingFailure.none;

    } catch (e) {
      rethrow;
    }
  }
}