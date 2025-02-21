import 'package:clickvagas/bloc/hist_bloc/hist_bloc.dart';
import 'package:clickvagas/bloc/hist_bloc/hist_event.dart';
import 'package:clickvagas/bloc/hist_bloc/hist_state.dart';
import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:clickvagas/repository/parking_spot_repository.dart';
import 'package:clickvagas/widgets/hist_card_widget.dart';
import 'package:clickvagas/widgets/hist_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistSpotPage extends StatefulWidget {
  const HistSpotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistSpotPageState createState() => _HistSpotPageState();
}

class _HistSpotPageState extends State<HistSpotPage> {
  late HistBloc histBloc;
  DataText dataText = DataText();
  DataColor dataColors = DataColor();

  @override
  void initState() {
    super.initState();
    histBloc = HistBloc(repository: ParkingSpotRepository());
    histBloc.add(LoadHistEvent());
  }

  @override
  void dispose() {
    histBloc.close();
    super.dispose();
  }

  String _formatDuration(DateTime entry, DateTime? exit) {
    if (exit == null) return dataText.textStillSpot;
    Duration duration = exit.difference(entry);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "$hours horas e $minutes minutos";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistBloc>(
      create: (context) => histBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(dataText.textTitleHist),
        ),
        body: Column(
          children: [
            HistFilterWidget(
              onFilterAll: () => histBloc.add(ApplyStatusFilterHistEvent(0)),
              onFilterActive: () => histBloc.add(ApplyStatusFilterHistEvent(1)),
              onFilterFinished: () =>
                  histBloc.add(ApplyStatusFilterHistEvent(2)),
              onFilterByDate: () async {
                DateTime now = DateTime.now();
                DateTime firstDate = DateTime(now.year, 1, 1);
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: firstDate,
                  lastDate: now,
                  locale: const Locale('pt', 'BR'),
                );
                if (picked != null) {
                  histBloc.add(ApplyDateFilterHistEvent(
                      start: picked.start, end: picked.end));
                }
              },
            ),
            Expanded(
              child: BlocBuilder<HistBloc, HistState>(
                builder: (context, state) {
                  if (state is HistLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HistError) {
                    return Center(child: Text("Erro: ${state.message}"));
                  } else if (state is HistLoaded) {
                    List<ParkingSpotModel> filteredTransactions =
                        state.transactions;
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: filteredTransactions.isEmpty
                          ? Center(child: Text(dataText.textNoMovimentRecorded))
                          : ListView.builder(
                              itemCount: filteredTransactions.length,
                              itemBuilder: (context, index) {
                                ParkingSpotModel transaction =
                                    filteredTransactions[index];
                                return HistCardWidget(
                                  transactionModel: transaction,
                                  formatDuration: _formatDuration,
                                );
                              },
                            ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
