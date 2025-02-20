import 'package:clickvagas/models/parking_spot_model.dart';
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
  List<ParkingSpotModel> transactions = [];
  // @todo criar um enum para esses valores
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
            .map((t) => ParkingSpotModel.fromJson(json.decode(t)))
            .toList();
      });
    }
  }


  String _formatDuration(DateTime entry, DateTime? exit) {
    //@todoo revisar texto - hardcode
    if (exit == null) return "Ainda no estacionamento";
    Duration duration = exit.difference(entry);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "$hours horas e $minutes minutos";
  }


  List<ParkingSpotModel> _getFilteredTransactions() {
    List<ParkingSpotModel> filteredList = transactions;
//@todo valores soltos devem ser substituidos por constantes
    if (filterStatus == 1) {
      filteredList = filteredList.where((t) => t.exitdate == null).toList();
    } else if (filterStatus == 2) {
      filteredList = filteredList.where((t) => t.exitdate != null).toList();
    }

    if (selectedStartDate != null && selectedEndDate != null) {
      filteredList = filteredList.where((t) {
        return t.entrydate!.isAfter(selectedStartDate!.subtract(Duration(days: 1))) &&
            t.entrydate!.isBefore(selectedEndDate!.add(Duration(days: 1)));
      }).toList();
    }

    return filteredList;
  }

// filtrar @todo talvez apor questao de tempo nao priorizar filtro por data
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

   // @todo mais um exemplo de funcao que poderia ser extraida para uma classe utilitaria
      String formattedStart = DateFormat("dd/MM/yyyy").format(picked.start);
      String formattedEnd = DateFormat("dd/MM/yyyy").format(picked.end);
//@todo lembre-se de remover os prints antes de submeter o codigo
      debugPrint("Data selecionada: $formattedStart até $formattedEnd");
    }
  }

  void _filterChange(String choice) {
    setState(() {
      //@todo talvez caberia um enum para esses valores
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
    List<ParkingSpotModel> filteredTransactions = _getFilteredTransactions();

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
        //@todo transacao eh um termo muito generico, talvez fosse melhor usar "registro" ou "movimentacao"
            ? Center(child: Text("Nenhuma transação registrada"))
            : ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  ParkingSpotModel transaction = filteredTransactions[index];

                  return TransactionCardWidget(
                      transactionModel: transaction,
                      formatDuration: _formatDuration);
                },
              ),
      ),
    );
  }
}
