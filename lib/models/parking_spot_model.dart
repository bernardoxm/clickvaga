

class ParkingSpotModel {
  String name;
  String plate;
  bool isOccupied;
  DateTime? entrydate; 
  DateTime? exitdate;  

  ParkingSpotModel({
    required this.name,
    required this.plate,
    required this.isOccupied,
    this.entrydate,
    this.exitdate,
  });

  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      name: json['name'],
      plate: json['plate'],
      isOccupied: json['isOccupied'] ?? false,
      entrydate: json['entrydate'] != null ? DateTime.parse(json['entrydate']) : null,
      exitdate: json['exitdate'] != null ? DateTime.parse(json['exitdate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'plate': plate,
      'isOccupied': isOccupied,
      'entrydate': entrydate?.toIso8601String(),
      'exitdate': exitdate?.toIso8601String(),
    };
  }
}
