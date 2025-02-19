import 'package:clickvagas/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// TransactionCardWidget is a StatelessWidget that shows a card with information about a transaction.
// TransactionCardWidget é um StatelessWidget que exibe um cartão com informações sobre uma transação.
// The card shows the vehicle plate, entry date, exit date, and duration of the transaction.
// O cartão mostra a placa do veículo, a data de entrada, a data de saída e a duração da transação.
// The card also shows an icon indicating if the transaction is still active or finished.
// O cartão também mostra um ícone indicando se a transação ainda está ativa ou finalizada.
// The formatDuration function is used to format the duration of the transaction.
// A função formatDuration é usada para formatar a duração da transação.
// The transactionModel parameter is the transaction data.
// O parâmetro transactionModel é os dados da transação.
// The formatDuration parameter is a function that receives the entry date and exit date and returns a formatted string.
// O parâmetro formatDuration é uma função que recebe a data de entrada e a data de saída e retorna uma string formatada.
// The card color is red if the transaction is still active and blue if it's finished.
// A cor do cartão é vermelha se a transação ainda está ativa e azul se estiver finalizada.
// The icon is a bus if the transaction is still active and a check circle if it's finished.
// O ícone é um ônibus se a transação ainda está ativa e um círculo de verificação se estiver finalizada.
// The icon color is red if the transaction is still active and blue if it's finished.
// A cor do ícone é vermelha se a transação ainda está ativa e azul se estiver finalizada.

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
