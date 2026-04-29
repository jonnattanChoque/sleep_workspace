import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sleep_sync_app/core/services/storage_service.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/sleep_chart.dart';
import 'package:sleep_sync_app/features/graphics/domain/repositories/i_sleep_chart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepChartRepository implements ISleepChartRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  
  @override
  Future<List<SleepLogEntity>> getAllSleepLogs(String uid) async {
    final localLogs = await getMyLocalLogs();
    DateTime? lastDate;
    if (localLogs.isNotEmpty) {
      localLogs.sort((a, b) => a.dateId.compareTo(b.dateId));
      lastDate = DateTime.parse(localLogs.last.dateId);
    }

    Query query = _db.collection('users').doc(uid).collection('sleep_logs');
    
    if (lastDate != null) {
      query = query.where(FieldPath.documentId, isGreaterThan: localLogs.last.dateId);
    }

    final snapshot = await query.get();
    final newLogs = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return SleepLogEntity(
        dateId: doc.id,
        hours: (data?['hours'] ?? 0.0).toDouble(),
        quality: (data?['quality'] ?? 0.0).toDouble(),
      );
    }).toList();

    final totalLogs = [...localLogs, ...newLogs];
    
    if (newLogs.isNotEmpty) {
      await _storageService.saveSleepLogs(StorageService.myLogsKey, totalLogs.map((e) => e.toJson()).toList());
    }

    return totalLogs;
  }
  
  @override
  Future<DateTime?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('last_sleep_sync');
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  @override
  Future<void> updateLastSyncDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sleep_sync', date.toIso8601String());
  }

  @override
  Future<List<SleepLogEntity>> getMyLocalLogs() async {
    final jsonString = await _storageService.getSleepLogs(StorageService.myLogsKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => SleepLogEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<SleepLogEntity>> getPartnerLocalLogs() async {
    final jsonString = await _storageService.getSleepLogs(StorageService.partnerLogsKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => SleepLogEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveLogsLocally(List<SleepLogEntity> myLogs, List<SleepLogEntity> partnerLogs) async {
    await Future.wait([
      _storageService.saveSleepLogs(StorageService.myLogsKey, myLogs.map((e) => e.toJson()).toList()),
      _storageService.saveSleepLogs(StorageService.partnerLogsKey, partnerLogs.map((e) => e.toJson()).toList()),
    ]);
  }
}