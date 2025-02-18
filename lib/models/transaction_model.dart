class TransactionModel {
  final String id;
  final String? plate;
  final DateTime? date;
  final DateTime? finalDate;

  TransactionModel(
      {required this.id,
  
      this.plate,
      this.date,
      this.finalDate});

  TransactionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],

        plate = json['plate'],
        date = json['date'] != null ? DateTime.parse(json['date']) : null,
        finalDate = json['finalDate'] != null
            ? DateTime.parse(json['finalDate'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate': plate,
      'date': date?.toIso8601String(),
      'finalDate': finalDate?.toIso8601String(),
    };
  }
}
