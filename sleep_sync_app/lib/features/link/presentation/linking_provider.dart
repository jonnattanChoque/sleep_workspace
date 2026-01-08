import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/link/data/repository/firebase_linking_repository.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_record_model.dart';
import 'package:sleep_sync_app/features/link/domain/repository/i_linking_repository.dart';
import 'package:sleep_sync_app/features/link/presentation/controller/linking_controller.dart';

final linkingRepositoryProvider = Provider<IlinkingRepository>((ref) {
  return FirebaseLinkingRepository();
});

final sleepLogsProvider = StreamProvider<List<SleepRecord>>((ref) {
  return ref.watch(linkingRepositoryProvider).onSleepLogsChanged;
});

final linkingControllerProvider = StateNotifierProvider<LinkingController, AsyncValue<String?>>((ref) {
  final user = ref.watch(authControllerProvider).value;
  final currentSleepGoal = user?.sleepGoal ?? 8.0;
  final repository = ref.watch(linkingRepositoryProvider);
  return LinkingController(repository, ref, currentSleepGoal);
});


final partnerProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final currentUser = ref.watch(authControllerProvider).value;
  
  if (currentUser == null || currentUser.partnerId == null || currentUser.partnerId!.isEmpty) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.partnerId)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) return null;
        
        final data = snapshot.data()!;
        
        return AppUser.fromMap(
          data, 
          snapshot.id,
          data['email'] as String?,
          data['verified'] as bool?,
          currentUser.name,
        );
      });
});