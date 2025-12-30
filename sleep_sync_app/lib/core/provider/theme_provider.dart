import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

final themeLoadingProvider = StateProvider<bool>((ref) => false);

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});