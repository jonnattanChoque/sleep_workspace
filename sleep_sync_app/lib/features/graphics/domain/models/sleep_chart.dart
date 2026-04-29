class SleepChartData {
  final DateTime date;
  final double userHours;
  final double partnerHours;
  final double userQuality;
  final double partnerQuality;
  final double userBedtime;
  final double userWakeup;
  final double partnerBedtime;
  final double partnerWakeup;

  SleepChartData({
    required this.date,
    this.userHours = 0,
    this.partnerHours = 0,
    this.userQuality = 0,
    this.partnerQuality = 0,
    this.userBedtime = 0,
    this.userWakeup = 0,
    this.partnerBedtime = 0,
    this.partnerWakeup = 0,
  });
}

class SleepLogEntity {
  final String dateId;
  final double hours;
  final double quality;

  SleepLogEntity({
    required this.dateId, 
    required this.hours, 
    required this.quality
  });

    factory SleepLogEntity.fromJson(Map<String, dynamic> json) {
      return SleepLogEntity(
        dateId: json['dateId'] as String,
        hours: (json['hours'] as num).toDouble(),
        quality: json['quality'] as double
      );
    }

    // Método para convertir de Objeto a JSON (Map)
    Map<String, dynamic> toJson() {
      return {
        'dateId': dateId,
        'hours': hours,
        'quality': quality
      };
    }
}

enum ChartRange { week, month }

class SleepChartStateData {
  final List<SleepLogEntity> myLogs;
  final List<SleepLogEntity> partnerLogs;
  final ChartRange range;

  SleepChartStateData({
    required this.myLogs,
    required this.partnerLogs,
    required this.range,
  });
}