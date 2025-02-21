// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/repository/parking_spot_repository.dart';
import 'hist_event.dart';
import 'hist_state.dart';

class HistBloc extends Bloc<HistEvent, HistState> {
  final ParkingSpotRepository repository;
  List<ParkingSpotModel> allTransactions = []; // Armazena todos os dados originais

  HistBloc({required this.repository}) : super(HistInitial()) {
    on<LoadHistEvent>((event, emit) async {
      emit(HistLoading());
      try {
        allTransactions = await repository.getParkingSpots(); // Carrega os dados originais
        emit(HistLoaded(transactions: allTransactions)); // Exibe os dados completos
      } catch (e) {
        emit(HistError(e.toString()));
      }
    });

    on<ApplyDateFilterHistEvent>((event, emit) async {
      if (state is HistLoaded) {
        HistLoaded current = state as HistLoaded;
        List<ParkingSpotModel> filtered = allTransactions.where((t) {
          if (t.entrydate == null) return false;
          return t.entrydate!.isAfter(event.start.subtract(const Duration(days: 1))) &&
              t.entrydate!.isBefore(event.end.add(const Duration(days: 1)));
        }).toList();
        emit(current.copyWith(transactions: filtered, startDate: event.start, endDate: event.end));
      }
    });

    on<ClearDateFilterHistEvent>((event, emit) async {
      if (state is HistLoaded) {
        HistLoaded current = state as HistLoaded;
        emit(current.copyWith(transactions: allTransactions, startDate: null, endDate: null));
      }
    });

    on<ApplyStatusFilterHistEvent>((event, emit) {
      if (state is HistLoaded) {
        HistLoaded current = state as HistLoaded;
        List<ParkingSpotModel> filtered = [];

        switch (event.filterStatus) {
          case 0: // Mostrar Todos
            filtered = List.from(allTransactions);
            break;
          case 1: // Mostrar Apenas Ativos (Sem exitdate)
            filtered = allTransactions.where((t) => t.exitdate == null).toList();
            break;
          case 2: // Mostrar Apenas Finalizados (Com exitdate)
            filtered = allTransactions.where((t) => t.exitdate != null).toList();
            break;
        }

        emit(current.copyWith(transactions: filtered, statusFilter: event.filterStatus));
      }
    });

    on<SearchPlateHistEvent>((event, emit) {
      if (state is HistLoaded) {
        HistLoaded current = state as HistLoaded;
        List<ParkingSpotModel> filtered = allTransactions.where((t) {
          return t.plate.toLowerCase().contains(event.plate.toLowerCase());
        }).toList();
        emit(current.copyWith(transactions: filtered, search: event.plate));
      }
    });
  }
}
