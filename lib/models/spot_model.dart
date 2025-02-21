class SpotModel {
  final String id;
  final String name;
  final bool isOccupied;

  SpotModel({
    required this.id,
    required this.name,
    required this.isOccupied,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isOccupied': isOccupied ? 1 : 0,
    };
  }

  factory SpotModel.fromJson(Map<String, dynamic> json) {
    return SpotModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      isOccupied: (json['isOccupied'] as int) == 1,
    );
  }
}
