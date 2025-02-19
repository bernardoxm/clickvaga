import 'package:clickvaga/bloc/bloc_transaction/transaction_event.dart';
import 'package:clickvaga/bloc/bloc_transaction/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  ParkingBloc() : super(ParkingState(occupiedSpots: [], totalSpots: 10)) {
    on<AddVehicle>((event, emit) {
      if (state.occupiedSpots.length < state.totalSpots) {
        emit(ParkingState(
            occupiedSpots: List.from(state.occupiedSpots)..add(event.plate),
            totalSpots: state.totalSpots));
      }
    });

    on<RemoveVehicle>((event, emit) {
      emit(ParkingState(
          occupiedSpots: List.from(state.occupiedSpots)..remove(event.plate),
             
          totalSpots: state.totalSpots));
    });
  }
}
