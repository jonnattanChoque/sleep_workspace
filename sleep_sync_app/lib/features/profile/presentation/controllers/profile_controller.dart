
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/core/provider/loader_provider.dart';
import 'package:sleep_sync_app/core/provider/theme_provider.dart';
import 'package:sleep_sync_app/features/profile/domain/enum/profile_failure.dart';
import 'package:sleep_sync_app/features/profile/domain/repositories/i_profile_repository.dart';

class ProfileController extends StateNotifier<AsyncValue<ProfileActionState>> {
  final IProfileRepository _repository;
  final Ref _ref;

  ProfileController(this._repository, this._ref) : super(const AsyncData(ProfileActionState.initial));

  Future<bool> updateName(String name) async {
    final trimmedName = name.trim();
    
    if (trimmedName.isEmpty) {
      state = AsyncError(AppStrings.errorEmptyFields, StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    try {
      final ProfileFailure result = await _repository.updateName(name);

      if (result == ProfileFailure.none) {
        state = const AsyncData(ProfileActionState(
          message: AppStrings.nameUpdated, 
          isError: false,
        ));
      } else {
        state = AsyncData(ProfileActionState(
          message: _mapFailureToMessage(result), 
          isError: true,
        ));
      }
      return true;
    } catch (e) {
      state = const AsyncData(ProfileActionState(
        message: AppStrings.errorGeneral, 
        isError: true,
      ));
      return false;
    }
  }

  Future<void> togglePush(bool isOn) async {
    state = const AsyncLoading();

    final storage = _ref.read(storageServiceProvider);
    storage.setNotificationsEnabled(isOn);

    state = AsyncData(ProfileActionState(
      message: isOn ? AppStrings.pushOn : AppStrings.pushOff,
      isError: false,
    ));
  }

  Future<void> unlink() async {
    _ref.read(loaderProvider.notifier).state = const LoaderState(
      isLoading: true, 
      message: AppStrings.unlinkProcess
    );

    state = const AsyncLoading();
    
    try {
      final ProfileFailure result = await _repository.unlink();

      if (result == ProfileFailure.none) {
        state = const AsyncData(ProfileActionState(
          message: AppStrings.unlinkedSuccess,
          isError: false,
        ));
      } else {
        state = AsyncData(ProfileActionState(
          message: _mapFailureToMessage(result), 
          isError: true,
        ));
      }
    } catch (e) {
      state = const AsyncData(ProfileActionState(
        message: AppStrings.errorGeneral, 
        isError: true,
      ));
    } finally {
      await Future.delayed(const Duration(milliseconds: 1000));
      _ref.read(loaderProvider.notifier).state = const LoaderState(isLoading: false);
    }
  }

  String _mapFailureToMessage(ProfileFailure failure) {
    switch (failure) {
      case ProfileFailure.serverError:
        return AppStrings.errorNetwork;
      case ProfileFailure.noAuthenticatedUser:
        return AppStrings.errorUserNotFound;
      case ProfileFailure.notLinked:
        return AppStrings.noLinkend;
      default:
        return AppStrings.errorGeneral;
    }
  }
}