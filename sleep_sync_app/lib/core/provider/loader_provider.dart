import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoaderState {
  final bool isLoading;
  final String? message;

  const LoaderState({this.isLoading = false, this.message});
}

final loaderProvider = StateProvider<LoaderState>((ref) => const LoaderState());