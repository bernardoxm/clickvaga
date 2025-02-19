class TransactionModel {
  final String id;
  final String? plate;
  final DateTime? entrydate;
   DateTime? endDate;


  TransactionModel(
      {required this.id,
  
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
