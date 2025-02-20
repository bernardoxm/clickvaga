

class ParkingSpotModel {
  var id;
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
    required this.id,
  });
    

    copyWith({
    String? name,
    String? plate,
    bool? isOccupied,
    DateTime? entrydate, //@todo manter o padrao de nomenclatura isOccupied entryDate exitDate
    DateTime? exitdate,
    int? id,})
    {
      return ParkingSpotModel(
        name: name ?? this.name,
        plate: plate ?? this.plate,
        isOccupied: isOccupied ?? this.isOccupied,
        entrydate: entrydate,
        exitdate: exitdate,
        id: id,
      );
    }


  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      name: json['name'],
      plate: json['plate'],
      isOccupied: json['isOccupied'] ?? false,
      entrydate:
          json['entrydate'] != null ? DateTime.parse(json['entrydate']) : null,
      exitdate:
          json['exitdate'] != null ? DateTime.parse(json['exitdate']) : null,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'plate': plate,
      'isOccupied': isOccupied,
      'entrydate': entrydate?.toIso8601String(),
      'exitdate': exitdate?.toIso8601String(),
      'id': id,
    };
  }

  bool isActive() {

    return isOccupied && exitdate == null;
  }
}
