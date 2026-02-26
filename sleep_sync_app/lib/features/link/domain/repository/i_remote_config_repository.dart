abstract class IRemoteConfigRepository {
  Future<void> init();
  Future<bool> fetchNewConfigs();
  bool get isHistoryEnabled;
}