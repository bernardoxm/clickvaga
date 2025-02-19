// Modelo de transação
// A classe TransactionModel representa uma transação de estacionamento.  
// A classe possui os atributos id, plate, entrydate e endDate.
// O atributo id é uma string que identifica a transação.
// O atributo plate é uma string que representa a placa do veículo.
// O atributo entrydate é um DateTime que representa a data de entrada do veículo.
// O atributo endDate é um DateTime que representa a data de saída do veículo.
// A classe possui um construtor que recebe os valores dos atributos id, plate, entrydate e endDate.
// A classe possui um método toJson
// A classe possui um método fromJson
// O método fromJson recebe um mapa de strings e dinâmicos e retorna uma instância de TransactionModel.
// O método toJson retorna um mapa de strings e dinâmicos com os valores dos atributos da instância de TransactionModel.


class TransactionModel {
  final String? id;
  final String? plate;
  final DateTime? entrydate;
   DateTime? endDate;


  TransactionModel(
      { this.id,
  
      this.plate,
      this.entrydate,
      this.endDate});

  TransactionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],

        plate = json['plate'],
        entrydate = json['date'] != null ? DateTime.parse(json['date']) : null,
        endDate = json['finalDate'] != null
            ? DateTime.parse(json['finalDate'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate': plate,
      'date': entrydate?.toIso8601String(),
      'finalDate': endDate?.toIso8601String(),
    };
  }
}
