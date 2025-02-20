import 'package:clickvagas/models/parking_spot_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TransactionCardWidget extends StatelessWidget {
  final ParkingSpotModel transactionModel;
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
        // revisar todos os textos para nao contem erros de portugues @todo
        title: Text(
          'Placa: ${transactionModel.plate ?? 'Desconhyecida'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          // @todo se uma funcao eh utilizada mais de uma x faz sentido criar um metodo para ela
          // DateFormat('dd/MM/yyyy HH:mm').format(transactionModel.entrydate) 
          // revisar se esse metodo deveria ser em uma classe utilitaria
          children: [
            Text(
                "Entrada: ${transactionModel.entrydate != null ? DateFormat('dd/MM/yyyy HH:mm').format(transactionModel.entrydate!) : 'Sem data'}"),
            Text(
                "Saída: ${transactionModel.exitdate != null ? DateFormat('dd/MM/yyyy HH:mm').format(transactionModel.exitdate!) : "Ainda no estacionamento"}"),
            Text(
                "Duração: ${transactionModel.entrydate != null ? formatDuration(transactionModel.entrydate!, transactionModel.exitdate) : 'Indisponível'}"),
          ],
        ), 
        leading: Icon(
          transactionModel.exitdate == null ? Icons.directions_bus : Icons.check_circle,
          color: transactionModel.exitdate == null ? Colors.red :  Color.fromRGBO(0, 224, 30, 1),
        ),
      ),
    );
  }
}
