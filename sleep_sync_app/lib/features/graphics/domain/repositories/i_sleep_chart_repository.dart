import 'package:sleep_sync_app/features/graphics/domain/models/sleep_chart.dart';

abstract class ISleepChartRepository {
  Future<List<SleepLogEntity>> getAllSleepLogs(String uid);
  Future<DateTime?> getLastSyncDate();
  Future<void> updateLastSyncDate(DateTime date);
  Future<void> saveLogsLocally(List<SleepLogEntity> myLogs, List<SleepLogEntity> partnerLogs);
  Future<List<SleepLogEntity>> getPartnerLocalLogs();
  Future<List<SleepLogEntity>> getMyLocalLogs();
}