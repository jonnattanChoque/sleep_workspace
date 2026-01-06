
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/profile/domain/repositories/i_profile_repository.dart';

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final IProfileRepository _repository;

  ProfileController(this._repository) : super(const AsyncData(null));

  Future<bool> updateName(String name) async {
    final trimmedName = name.trim();
    
    if (trimmedName.isEmpty) {
      state = AsyncError('El nombre no puede estar vacío', StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    try {
      await _repository.updateName(trimmedName);
      if (!mounted) return false;

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError('Error al actualizar: $e', st);
      return false;
    }
  }
}