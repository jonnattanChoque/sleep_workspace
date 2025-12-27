import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/linking/data/repository/firebase_linking_repository.dart';
import 'package:sleep_sync_app/features/linking/domain/repository/i_linking_repository.dart';
import 'package:sleep_sync_app/features/linking/presentation/controllers/linking_controller.dart';

final linkingRepositoryProvider = Provider<ILinkingRepository>((ref) {
  return FirebaseLinkingRepository();
});

final linkingControllerProvider = StateNotifierProvider<LinkingController, AsyncValue<String?>>((ref) {
  final repository = ref.watch(linkingRepositoryProvider);
  return LinkingController(repository, ref);
});
