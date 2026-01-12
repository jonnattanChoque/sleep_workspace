class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? partnerId;
  final String? partnerName;
  final String? pairingCode;
  final bool? verifiedEmail;
  final bool? notificationsEnabled;
  final double? sleepGoal;
  final UserStats stats;

  AppUser({
    required this.uid,
    required this.email,
    required this.stats,
    this.name,
    this.partnerId,
    this.partnerName,
    this.pairingCode,
    this.verifiedEmail,
    this.notificationsEnabled = false,
    this.sleepGoal = 8.0,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    UserStats? stats,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      stats: stats ?? this.stats,
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> data, String uid, String? email, bool? verified, String? partnerName) {
    final notification = data['fcmToken'] == null || data['fcmToken'].toString().isEmpty ? false : true;

    return AppUser(
      uid: uid,
      email: email ?? data['email'] ?? '',
      verifiedEmail: verified ?? data['verifiedEmail'] ?? false,
      name: data['name'] as String?,
      partnerId: data['partnerId'] as String?,
      partnerName: partnerName,
      notificationsEnabled: notification,
      sleepGoal: (data['sleepGoal'] as num? ?? 8.0).toDouble(),
      pairingCode: data['pairingCode'] as String?,
      stats: UserStats.fromMap(data['stats'] ?? {}),
    );
  }
}

class UserStats {
  final double totalHours;
  final int totalQualityStars;
  final int totalRecords;
  final double avgHours;
  final double avgQuality;

  UserStats({
    this.totalHours = 0.0,
    this.totalQualityStars = 0,
    this.totalRecords = 0,
    this.avgHours = 0.0,
    this.avgQuality = 0.0,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalHours: (map['totalHours'] ?? 0.0).toDouble(),
      totalQualityStars: map['totalQualityStars'] ?? 0,
      totalRecords: map['totalRecords'] ?? 0,
      avgHours: (map['avgHours'] ?? 0.0).toDouble(),
      avgQuality: (map['avgQuality'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'totalHours': totalHours,
    'totalQualityStars': totalQualityStars,
    'totalRecords': totalRecords,
    'avgHours': avgHours,
    'avgQuality': avgQuality,
  };
}