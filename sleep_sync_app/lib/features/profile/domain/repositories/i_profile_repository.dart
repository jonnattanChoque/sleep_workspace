import 'package:sleep_sync_app/features/profile/domain/enum/profile_failure.dart';

abstract class IProfileRepository {
  Future<ProfileFailure> updateName(String newName);
  Future<void> updatePhoto(String url);
  Future<ProfileFailure> unlink();
}