
import 'package:bloc/bloc.dart';
import 'package:clickvagas/models/spot_card_info.dart';
import 'package:clickvagas/models/spot_model.dart';
import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/repository/parking_spot_repository.dart';
import 'spot_event.dart';
import 'spot_state.dart';

class SpotBloc extends Bloc<SpotEvent, SpotState> {
  final ParkingSpotRepository repository;

  SpotBloc({required this.repository}) : super(SpotInitial()) {
    on<LoadSpotsEvent>((event, emit) async {
      emit(SpotLoading());
      try {
        List<SpotModel> spots = await repository.loadSpots();
        List<ParkingSpotModel> parkingEntries = await repository.getParkingSpots();
        List<SpotCardInfo> cardInfos = await repository.loadSpotCardInfos();
        emit(SpotLoaded(
          spots: spots,
          parkingEntries: parkingEntries,
          spotCardInfos: cardInfos,
        ));
      } catch (e) {
        emit(SpotError(e.toString()));
      }
    });


  

    on<AddSpotEvent>((event, emit) async {
      if (state is SpotLoaded) {
        await repository.creatANewSpot(event.spot);
        add(LoadSpotsEvent());
      }
    });

    on<RemoveLastSpotEvent>((event, emit) async {
      if (state is SpotLoaded) {
        SpotLoaded current = state as SpotLoaded;
        if (current.spots.isNotEmpty) {
          await repository.deleteSpot(current.spots.last.id);
          add(LoadSpotsEvent());
        }
      }
    });

    on<RegistryEntryEvent>((event, emit) async {
      try {
        await repository.registryEntryForSpot(event.spot, event.plate);
        add(LoadSpotsEvent());
      } catch (e) {
        emit(SpotError(e.toString()));
      }
    });

    on<RegistryExitEvent>((event, emit) async {
      try {
        await repository.registryExitForSpot(event.spot);
        add(LoadSpotsEvent());
      } catch (e) {
        emit(SpotError(e.toString()));
      }
    });

    on<ApplyFilterEvent>((event, emit) {
      if (state is SpotLoaded) {
        SpotLoaded current = state as SpotLoaded;
        emit(current.copyWith(filterStatus: event.filterStatus));
      }
    });

    on<SearchPlateEvent>((event, emit) {
      if (state is SpotLoaded) {
        SpotLoaded current = state as SpotLoaded;
        emit(current.copyWith(search: event.plate));
      }
    });
  }
}
