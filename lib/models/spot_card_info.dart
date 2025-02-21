class SpotCardInfo {
  final String spotId;
  final String spotName;
  final bool isOccupied;
  final String? parkingSpotId;
  final String? plate; 
  final DateTime? entryDate;
  final DateTime? exitDate;

  SpotCardInfo({
    required this.spotId,
    required this.spotName,
    required this.isOccupied,
    this.parkingSpotId,
    this.plate,
    this.entryDate,
    this.exitDate,
  });

  factory SpotCardInfo.fromJson(Map<String, dynamic> json) {
    return SpotCardInfo(
      spotId: json['spotId'].toString(),
      spotName: json['spotName'].toString(), 
      isOccupied: (json['isOccupied'] is int
          ? (json['isOccupied'] as int) == 1
          : false),
      parkingSpotId: json['parkingSpotId'] != null
          ? json['parkingSpotId'].toString()
          : null,
      plate: json['plate'] != null ? json['plate'].toString() : null,
      entryDate: json['entryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['entryDate'] is int
              ? json['entryDate']
              : int.tryParse(json['entryDate'].toString()) ?? 0)
          : null,
      exitDate: json['exitDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['exitDate'] is int
              ? json['exitDate']
              : int.tryParse(json['exitDate'].toString()) ?? 0)
          : null,
    );
  }
}
