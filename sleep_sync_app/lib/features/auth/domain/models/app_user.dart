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

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.partnerId,
    this.partnerName,
    this.pairingCode,
    this.verifiedEmail,
    this.notificationsEnabled = false,
    this.sleepGoal = 8.0,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid, String? email, bool? verified, String? partnerName) {
    return AppUser(
      uid: uid,
      email: email ?? data['email'] ?? '',
      verifiedEmail: verified ?? data['verifiedEmail'] ?? false,
      name: data['name'] as String?,
      partnerId: data['partnerId'] as String?,
      partnerName: partnerName,
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      sleepGoal: (data['sleepGoal'] as num? ?? 8.0).toDouble(),
      pairingCode: data['pairingCode'] as String?
    );
  }
}