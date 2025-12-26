import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Mi Sueño'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          )
        ],
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: RadialSleepChart(
              userProgress: 0.75, 
              partnerProgress: 0.5,
              label: "Sincronía",
            ),
          ),
        ],
      ),
    );
  }
}