enum ProfileFailure {
  none,
  serverError,
  networkError,
  permissionDenied,
  noAuthenticatedUser,
  notLinked,
}

class ProfileActionState {
  final String message;
  final bool isError;

  const ProfileActionState({this.message = '', this.isError = false});
  static const initial = ProfileActionState();
}
