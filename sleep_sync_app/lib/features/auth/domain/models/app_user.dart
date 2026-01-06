class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? partnerId;
  final String? partnerName;
  final String? pairingCode;
  final bool? verifiedEmail;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.partnerId,
    this.partnerName,
    this.pairingCode,
    this.verifiedEmail,
  });
}