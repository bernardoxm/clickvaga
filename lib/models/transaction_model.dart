class TransactionModel {
  final String id;
  final String plate;
  final DateTime entrydate;
  DateTime? endDate;

  TransactionModel({
    required this.id,
    required this.plate,
    required this.entrydate,
    this.endDate,
  });


  bool isActive() {
    return endDate == null;
  }


  TransactionModel copyWith({
    String? id,
    String? plate,
    DateTime? entrydate,
    DateTime? endDate,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      entrydate: entrydate ?? this.entrydate,
      endDate: endDate ?? this.endDate,
    );
  }

  // Converter um JSON para TransactionModel
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      plate: json['plate'] as String,
      entrydate: json['entrydate'] != null
          ? DateTime.parse(json['entrydate'])
          : DateTime.now(), // Se não tiver data de entrada, assume agora
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  // Converter TransactionModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate': plate,
      'entrydate': entrydate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
