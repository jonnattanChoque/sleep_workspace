import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_record_model.dart';

abstract class IlinkingRepository {
  Stream<List<SleepRecord>> get onSleepLogsChanged;
  Future<void> addSleepRecord(SleepRecord record, AppUser appUser);
}