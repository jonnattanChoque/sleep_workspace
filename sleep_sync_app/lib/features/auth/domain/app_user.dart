class AppUser {
  final String uid;
  final String email;
  final String? partnerId;
  final String? pairingCode;
  final bool? verifiedEmail;

  AppUser({
    required this.uid,
    required this.email,
    this.partnerId,
    this.pairingCode,
    this.verifiedEmail,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      uid: id,
      email: map['email'] ?? '',
      partnerId: map['partnerId'],
      pairingCode: map['pairingCode'],
      verifiedEmail: map['verifiedEmail'],
    );
  }
}