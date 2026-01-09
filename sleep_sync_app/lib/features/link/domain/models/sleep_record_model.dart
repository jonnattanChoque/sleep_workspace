class SleepRecord {
  final String id;
  final String userId; // Añadido
  final DateTime date;
  final double hours;
  final double goal;   // Añadido para el cálculo de progreso
  final int quality;

  SleepRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.hours,
    this.goal = 8.0,
    this.quality = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'hours': hours,
      'quality': quality,
      'goal': goal
    };
  }

  factory SleepRecord.empty(String userId) => SleepRecord(
    id: '',
    userId: userId,
    date: DateTime.now(),
    hours: 0,
    quality: 0,
  );

  factory SleepRecord.fromMap(Map<String, dynamic> map, String id) {
    return SleepRecord(
      id: id,
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date']),
      hours: (map['hours'] as num).toDouble(),
      goal: (map['goal'] as num? ?? 8.0).toDouble(),
      quality: map['quality'] as int,
    );
  }
}