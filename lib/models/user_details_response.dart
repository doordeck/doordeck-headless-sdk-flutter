class UserDetailsResponse {
  final String? userId;
  final String publicKey;
  final String email;
  final String? displayName;
  final bool emailVerified;
  final bool certificateChainAboutToExpire;
  final bool tokenAboutToExpire;

  UserDetailsResponse({
    this.userId,
    required this.publicKey,
    required this.email,
    this.displayName,
    required this.emailVerified,
    required this.certificateChainAboutToExpire,
    required this.tokenAboutToExpire,
  });

  factory UserDetailsResponse.fromMap(Map<String, dynamic> map) {
    return UserDetailsResponse(
      userId: map['userId'],
      publicKey: map['publicKey'],
      email: map['email'],
      displayName: map['displayName'],
      emailVerified: map['emailVerified'],
      certificateChainAboutToExpire: map['certificateChainAboutToExpire'],
      tokenAboutToExpire: map['tokenAboutToExpire'],
    );
  }
}