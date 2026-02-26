import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/link/domain/repository/i_remote_config_repository.dart';

class DashboardController extends StateNotifier<bool> {
  final IRemoteConfigRepository _repository;

  DashboardController(this._repository) : super(false) {
    _init();
  }

  Future<void> _init() async {
    await _repository.init();
    state = _repository.isHistoryEnabled;
  }

  Future<void> syncFeatures() async {
    await _repository.init(); 
  
    bool updated = await _repository.fetchNewConfigs();
    
    if (updated) {
      state = _repository.isHistoryEnabled;
    }
  }
}