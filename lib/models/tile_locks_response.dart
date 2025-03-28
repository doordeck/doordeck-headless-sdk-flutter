class TileLocksResponse {
  final String siteId;
  final String tileId;
  final List<String> deviceIds;

  TileLocksResponse({
    required this.siteId,
    required this.tileId,
    required this.deviceIds,
  });

  factory TileLocksResponse.fromMap(Map<String, dynamic> map) {
    return TileLocksResponse(
      siteId: map['siteId'],
      tileId: map['tileId'],
      deviceIds: List<String>.from(map['deviceIds']),
    );
  }
}