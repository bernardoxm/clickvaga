import 'package:clickvagas/data/data_functions.dart';
import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/models/spot_card_info.dart';
import 'package:clickvagas/models/spot_model.dart';
import 'package:uuid/uuid.dart';

class ParkingSpotRepository {
  final DataFunctions dataFunctions = DataFunctions();

  Future<List<SpotModel>> createSpots(int totalSpots) async {
    List<SpotModel> spots = [];
    for (int i = 0; i < totalSpots; i++) {
      spots.add(SpotModel(
        id: Uuid().v4(),
        name: 'Spot $i',
        isOccupied: false,
      ));
    }

    await dataFunctions.insertSpots(spots);
    return spots;
  }

  Future<List<SpotModel>> loadSpots() async {
    return await dataFunctions.getSpots();
  }

  Future<void> creatANewSpot(SpotModel spot) async {
    await dataFunctions.insertANewSpot(spot);
  }

  Future<void> deleteSpot(String id) async {
    await dataFunctions.deleteSpot(id);
  }

  Future<void> registryEntryForSpot(SpotModel spot, String plate) async {
    bool exists = await dataFunctions.isPlateAlreadyActive(plate);
    if (exists) {
      throw Exception("Esta placa já está em uso.");
    }

    if (spot.isOccupied) {
      throw Exception("Este spot já está ocupado");
    }

    final parkingEntry = ParkingSpotModel(
      id: Uuid().v4(),
      spotId: spot.id,
      plate: plate,
      entrydate: DateTime.now(),
      exitdate: null,
    );

    await dataFunctions.insertPlateWithSpot(parkingEntry);
  }

  Future<void> registryExitForSpot(SpotModel spot) async {
    final entries = await getParkingSpots();
    final entry = entries.firstWhere(
      (e) => e.spotId == spot.id,
      orElse: () => throw Exception(
          "Nenhum registro de entrada encontrado para esse spot"),
    );

    final updatedEntry = entry.copyWith(
      exitdate: DateTime.now(),
      spotId: "",
    );
    await dataFunctions.updateParkingExit(updatedEntry);

    await dataFunctions.freeSpot(spot.id);
  }

  Future<List<SpotCardInfo>> loadSpotCardInfos() async {
    return await DataFunctions().loadSpotCardInfos();
  }

  Future<void> insertPlateWithSpot(ParkingSpotModel parkingSpot) async {
    print("insertPlateWithSpot iniciado com: ${parkingSpot.toJson()}");
    await DataFunctions().insertParkingEntry(parkingSpot);
  }


  Future<List<ParkingSpotModel>> getParkingSpots() async {
    return await dataFunctions.getParkingSpots();
  }


  
}
