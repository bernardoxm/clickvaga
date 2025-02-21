class ParkingSpotModel {
  final String id;
  final String spotId;
  final String plate;
  final DateTime? entrydate;
  final DateTime? exitdate;

  ParkingSpotModel({
    required this.id,
    required this.spotId,
    required this.plate,
    this.entrydate,
    this.exitdate,
  });

  ParkingSpotModel copyWith({
    String? id,
    String? spotId,
    String? plate,
    DateTime? entrydate,
    DateTime? exitdate,
  }) {
    return ParkingSpotModel(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      plate: plate ?? this.plate,
      entrydate: entrydate ?? this.entrydate,
      exitdate: exitdate ?? this.exitdate,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spotId': spotId,
      'plate': plate,
      'entrydate': entrydate?.millisecondsSinceEpoch,
      'exitdate': exitdate?.millisecondsSinceEpoch,
    };
  }

  
  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      id: json['id'].toString(),
      spotId: json['spotId'].toString(),
      plate: json['plate'].toString(),
      entrydate: json['entrydate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['entrydate'] as int)
          : null,
      exitdate: json['exitdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['exitdate'] as int)
          : null,
    );
  }
}
