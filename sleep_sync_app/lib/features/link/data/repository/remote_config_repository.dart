import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:sleep_sync_app/features/link/domain/repository/i_remote_config_repository.dart';

class RemoteConfigRepository implements IRemoteConfigRepository {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.setDefaults({"show_history_tab": false});
  }

  @override
  Future<bool> fetchNewConfigs() async {
    return await _remoteConfig.fetchAndActivate();
  }

  @override
  bool get isHistoryEnabled => _remoteConfig.getBool('show_history_tab');
}