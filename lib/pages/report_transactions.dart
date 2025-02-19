import 'package:clickvagas/models/transaction_model.dart';
import 'package:clickvagas/widgets/transaction_card_widget.dart';
import 'package:clickvagas/widgets/transaction_filtred_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

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


  String _formatDuration(DateTime entry, DateTime? exit) {
    if (exit == null) return "Ainda no estacionamento";
    Duration duration = exit.difference(entry);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "$hours horas e $minutes minutos";
  }


  List<TransactionModel> _getFilteredTransactions() {
    List<TransactionModel> filteredList = transactions;

    if (filterStatus == 1) {
      filteredList = filteredList.where((t) => t.endDate == null).toList();
    } else if (filterStatus == 2) {
      filteredList = filteredList.where((t) => t.endDate != null).toList();
    }

    if (selectedStartDate != null && selectedEndDate != null) {
      filteredList = filteredList.where((t) {
        return t.entrydate
                .isAfter(selectedStartDate!.subtract(Duration(days: 1))) &&
            t.entrydate!.isBefore(selectedEndDate!.add(Duration(days: 1)));
      }).toList();
    }

    return filteredList;
  }

// filtrar
  Future<void> _dateFilter() async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year, 1, 1);

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime.now(),
     locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked.start;
        selectedEndDate = picked.end;
      });

   
      String formattedStart = DateFormat("dd/MM/yyyy").format(picked.start);
      String formattedEnd = DateFormat("dd/MM/yyyy").format(picked.end);

      debugPrint("Data selecionada: $formattedStart até $formattedEnd");
    }
  }

  void _filterChange(String choice) {
    setState(() {
      if (choice == "filterAll") {
        filterStatus = 0;
        selectedStartDate = null;
        selectedEndDate = null;
      } else if (choice == "filterFinished") {
        filterStatus = 2;
      } else if (choice == "filterActive") {
        filterStatus = 1;
      }
    });
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
            onFilterChange: _filterChange,
            onDateFilterSelected: _dateFilter,
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
