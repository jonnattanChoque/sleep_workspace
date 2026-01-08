import 'package:sleep_sync_app/features/unlink/domain/enum/linking_failure.dart';

abstract class IUnlinkingRepository {
  Future<String?> getUserLinkCode(String uid);
  Future<void> saveUserLinkCode(String uid, String code);
  Future<Map<String, dynamic>?> getUserProfile(String uid);
  Future<LinkingFailure> linkWithPartner({required String myUid, required String partnerCode});
}