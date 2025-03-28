class AssistedRegisterEphemeralKeyResponse {
  final bool requiresVerification;

  AssistedRegisterEphemeralKeyResponse({
    required this.requiresVerification,
  });

  factory AssistedRegisterEphemeralKeyResponse.fromMap(Map<String, dynamic> map) {
    return AssistedRegisterEphemeralKeyResponse(
      requiresVerification: map['requiresVerification'],
    );
  }
}
