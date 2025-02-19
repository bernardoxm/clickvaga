// This file contains the model for the parking spot
// Este arquivo contém o modelo para a vaga de estacionamento
// The ParkingSpotModel class has the attributes name, plate, and isOccupied
// A classe ParkingSpotModel tem os atributos name, plate e isOccupied
// The name attribute is a string that represents the parking spot name
// O atributo name é uma string que representa o nome da vaga de estacionamento
// The plate attribute is a string that represents the vehicle plate parked in the spot
// O atributo plate é uma string que representa a placa do veículo estacionado na vaga
// The isOccupied attribute is a boolean that indicates if the spot is occupied
// O atributo isOccupied é um booleano que indica se a vaga está ocupada
// The ParkingSpotModel class has a constructor that receives the values for the attributes name, plate, and isOccupied
// A classe ParkingSpotModel tem um construtor que recebe os valores para os atributos name, plate e isOccupied

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
