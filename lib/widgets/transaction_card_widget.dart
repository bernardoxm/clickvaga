import 'package:clickvaga/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCardWidget extends StatelessWidget {
  final TransactionModel transactionModel;
  final String Function(DateTime, DateTime?) formatDuration;

  const TransactionCardWidget(
      {super.key,
      required this.transactionModel,
      required this.formatDuration});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(
          'Placa: ${transactionModel.plate ?? 'Desconhyecida'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Entrada: ${transactionModel.entrydate != null ? DateFormat('dd/MM/yyyy HH:mm').format(transactionModel.entrydate!) : 'Sem data'}"),
            Text(
                "Saída: ${transactionModel.endDate != null ? DateFormat('dd/MM/yyyy HH:mm').format(transactionModel.endDate!) : "Ainda no estacionamento"}"),
            Text(
                "Duração: ${transactionModel.entrydate != null ? formatDuration(transactionModel.entrydate!, transactionModel.endDate) : 'Indisponível'}"),
          ],
        ), 
        leading: Icon(
          transactionModel.endDate == null ? Icons.directions_bus : Icons.check_circle,
          color: transactionModel.endDate == null ? Colors.red :  Color.fromRGBO(68, 194, 253,1),
        ),
      ),
    );
  }
}
