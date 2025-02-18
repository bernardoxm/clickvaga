class ParkingSpotModel {
  String name;
  String? plate;
  bool? isOccupied;


  ParkingSpotModel(
      {required this.name,
      this.plate,
       this.isOccupied,
  });

  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      name: json['name'],
      plate: json['plate'],
      isOccupied: json['isOccupied'],
  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'plate': plate,
      'isOccupied': isOccupied,

    };
  }
}
