import 'package:clickvaga/models/transaction_model.dart';
import 'package:clickvaga/widgets/transaction_card_widget.dart';
import 'package:clickvaga/widgets/transaction_filtred_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ReportTransactions extends StatefulWidget {
  const ReportTransactions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportTransactionsState createState() => _ReportTransactionsState();
}

class _ReportTransactionsState extends State<ReportTransactions> {
  List<TransactionModel> transactions = [];
  int filterStatus = 0; // 0 = Todos, 1 = Apenas Ativos, 2 = Apenas Finalizados

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedData = prefs.getStringList('parkingTransactions');

    if (savedData != null) {
      setState(() {
        transactions = savedData
            .map((t) => TransactionModel.fromJson(json.decode(t)))
            .toList();
      });
    }
  }

  List<TransactionModel> _getFilteredTransactions() {
    if (filterStatus == 1) {
      return transactions
          .where((t) => t.endDate == null)
          .toList(); // Apenas Ativos
    } else if (filterStatus == 2) {
      return transactions
          .where((t) => t.endDate != null)
          .toList(); // Apenas Finalizados
    }
    return transactions; // Todos
  }

  String _formatDuration(DateTime entry, DateTime? exit) {
    if (exit == null) return "Ainda no estacionamento";
    Duration duration = exit.difference(entry);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "$hours horas e $minutes minutos";
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionModel> filteredTransactions = _getFilteredTransactions();

    return Scaffold(
      appBar: AppBar(
        title: Text("Gestão de Transações"),
        actions: [
          TransactionFiltredButtonWidget(
            filterStatus: filterStatus,
            onFilterChange: () {
              setState(() {
                filterStatus = (filterStatus + 1) % 3;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: filteredTransactions.isEmpty
            ? Center(child: Text("Nenhuma transação registrada"))
            : ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  TransactionModel transaction = filteredTransactions[index];

                  return TransactionCardWidget(
                      transactionModel: transaction,
                      formatDuration: _formatDuration);
                },
              ),
      ),
    );
  }
}
