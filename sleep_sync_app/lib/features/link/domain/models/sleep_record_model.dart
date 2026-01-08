class SleepRecord {
  final String id;
  final DateTime date;
  final double hours;
  final int quality;

  SleepRecord({
    required this.id,
    required this.date,
    required this.hours,
    this.quality = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'hours': hours,
      'quality': quality,
    };
  }

  factory SleepRecord.fromMap(Map<String, dynamic> map, String id) {
    return SleepRecord(
      id: id,
      date: DateTime.parse(map['date']),
      hours: (map['hours'] as num).toDouble(),
      quality: map['quality'] as int,
    );
  }
}