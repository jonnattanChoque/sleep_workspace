import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/services/storage_service.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/chart_bars.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/chart_pie.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/sleep_chart.dart';
import 'package:sleep_sync_app/features/graphics/domain/repositories/i_sleep_chart_repository.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class SleepChartController extends StateNotifier<AsyncValue<SleepChartStateData>> {
  final ISleepChartRepository _repository;
  final String myUid;
  final String partnerUid;

  List<SleepLogEntity> _myFullHistory = [];
  List<SleepLogEntity> _partnerFullHistory = [];

  SleepChartController(this._repository, this.myUid, this.partnerUid) 
      : super(const AsyncLoading()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final _storageService = StorageService();

    if (_myFullHistory.isNotEmpty || _partnerFullHistory.isNotEmpty) {
      return;
    }

    try {
      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month}-${now.day}";
      final lastSync = await _storageService.getLastSyncDate();
    
    if (lastSync == todayStr) {
      final localMy = await _repository.getMyLocalLogs();
      final localPartner = await _repository.getPartnerLocalLogs();

      if (localMy.isNotEmpty || localPartner.isNotEmpty) {
        _myFullHistory = localMy;
        _partnerFullHistory = localPartner;
        setRange(ChartRange.week);
        return;
      }
    }

    final results = await Future.wait([
      _repository.getAllSleepLogs(myUid),
      _repository.getAllSleepLogs(partnerUid),
    ]);
    
    _myFullHistory = results[0];
    _partnerFullHistory = results[1];

    await _repository.saveLogsLocally(_myFullHistory, _partnerFullHistory);
    await _storageService.setLastSyncDate(todayStr);
    
    setRange(ChartRange.week);

  } catch (e, st) {
    state = AsyncError(e, st);
  }
}

  PieChartState get pieChartData {
    final data = state.value;
    if (data == null) return PieChartState.empty();

    final myAvg = data.myLogs.isEmpty 
        ? 0.0 
        : data.myLogs.map((e) => e.quality.toDouble()).average;
        
    final partnerAvg = data.partnerLogs.isEmpty 
        ? 0.0 
        : data.partnerLogs.map((e) => e.quality.toDouble()).average;
    
    final myShare = (myAvg / 5) * 50; 
    final partnerShare = (partnerAvg / 5) * 50;
    
    return PieChartState(
      myShare: myShare,
      partnerShare: partnerShare,
      greyArea: 100 - (myShare + partnerShare),
      totalPercent: (myShare + partnerShare).toInt(),
      avgStars: (myAvg + partnerAvg) / 2,
    );
  }

  BarChartState get barChartData {
    final data = state.value;
    if (data == null) return BarChartState.empty();

    final allDates = {
      ...data.myLogs.map((e) => e.dateId), 
      ...data.partnerLogs.map((e) => e.dateId)
    }.toList()..sort();

    // 2. Generamos los grupos de barras
    final barGroups = List.generate(allDates.length, (i) {
      final date = allDates[i];
      final myLog = data.myLogs.firstWhereOrNull((e) => e.dateId == date);
      final partnerLog = data.partnerLogs.firstWhereOrNull((e) => e.dateId == date);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: double.parse((myLog?.hours ?? 0).toStringAsFixed(2)),
            color: TwonDSColors.success,
            width: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: double.parse((partnerLog?.hours ?? 0).toStringAsFixed(2)),
            color: TwonDSColors.secondText,
            width: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });

    final calculatedWidth = data.range == ChartRange.week ? 0.0 : allDates.length * 50.0;

    return BarChartState(
      allDates: allDates,
      barGroups: barGroups,
      calculatedWidth: calculatedWidth,
    );
  }

  void setRange(ChartRange range) {
    final now = DateTime.now();
    DateTime startDate;

    if (range == ChartRange.week) {
      startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    } else {
      startDate = DateTime(now.year, now.month, 1);
    }
    final filteredMy = _myFullHistory.where((log) {
      final logDate = DateTime.parse(log.dateId);
      return logDate.isAtSameMomentAs(startDate) || logDate.isAfter(startDate);
    }).toList();

    final filteredPartner = _partnerFullHistory.where((log) {
      final logDate = DateTime.parse(log.dateId);
      return logDate.isAtSameMomentAs(startDate) || logDate.isAfter(startDate);
    }).toList();

    filteredMy.sort((a, b) => a.dateId.compareTo(b.dateId));
    filteredPartner.sort((a, b) => a.dateId.compareTo(b.dateId));

    state = AsyncValue.data(SleepChartStateData(
      myLogs: filteredMy,
      partnerLogs: filteredPartner,
      range: range,
    ));
  }
}