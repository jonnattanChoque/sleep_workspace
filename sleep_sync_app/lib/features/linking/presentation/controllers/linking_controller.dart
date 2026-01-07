import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/core/provider/loader_provider.dart';
import 'package:sleep_sync_app/core/utils/code_generator.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/linking/data/repository/firebase_linking_repository.dart';
import 'package:sleep_sync_app/features/linking/domain/enum/linking_failure.dart';
import 'package:sleep_sync_app/features/linking/domain/repository/i_linking_repository.dart';

class LinkingController extends StateNotifier<AsyncValue<String?>> {
  final ILinkingRepository _repository;
  final Ref ref;

  LinkingController(this._repository, this.ref) : super(const AsyncLoading());

  Future<void> initLinkingFlow() async {
    state = const AsyncLoading();
    try {
      final user = (_repository as FirebaseLinkingRepository).currentFirebaseUser;
      if (user == null) throw Exception("No hay sesión activa");

      String? existingCode = await _repository.getUserLinkCode(user.uid);
      if (existingCode == null) {
        final profile = await _repository.getUserProfile(user.uid);
        final String userName = profile?['name'] ?? 'US';
        final initials = _getInitials(userName);
        existingCode = CodeGenerator.generateSyncCode(initials);
        await _repository.saveUserLinkCode(user.uid, existingCode);
      }

      state = AsyncData(existingCode);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> linkWithPartner(String partnerCode) async {
    ref.read(loaderProvider.notifier).state = const LoaderState(
      isLoading: true, 
      message: AppStrings.linkProcess
    );

    final currentCode = state.value;
    state = const AsyncLoading<String?>().copyWithPrevious(state);

    state = const AsyncLoading();
    final myUid = (_repository as FirebaseLinkingRepository).currentFirebaseUser!.uid;

    final result = await _repository.linkWithPartner(
      myUid: myUid,
      partnerCode: partnerCode.toUpperCase(),
    );
    
    if (result == LinkingFailure.none) {
      try {
        final auth = ref.read(authControllerProvider.notifier);
        await auth.syncUserStatus(force: true);
        state = const AsyncData(AppStrings.linkSuccess);
      } catch (e) {
        state = AsyncError(e.toString(), StackTrace.current);
      } finally {
        await Future.delayed(const Duration(milliseconds: 1000));
        ref.read(loaderProvider.notifier).state = const LoaderState(isLoading: false);
        await Future.delayed(const Duration(milliseconds: 450));
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      ref.read(loaderProvider.notifier).state = const LoaderState(isLoading: false);
      await Future.delayed(const Duration(milliseconds: 450));

      final errorMessage = _mapFailureToMessage(result);
      state = AsyncError<String?>(errorMessage, StackTrace. current)
        .copyWithPrevious(AsyncData(currentCode));
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : name.length).toUpperCase();
  }

  String _mapFailureToMessage(LinkingFailure failure) {
    switch (failure) {
      case LinkingFailure.invalidCode:
        return AppStrings.errorInvalidLinkCode;
      case LinkingFailure.partnerAlreadyLinked:
        return AppStrings.errorPartnerAlreadyLinked;
      case LinkingFailure.selfLinking:
        return AppStrings.errorLinkedWithSelf;
      default:
        return AppStrings.errorGeneral;
    }
  }
}