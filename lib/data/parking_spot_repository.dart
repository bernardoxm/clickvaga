import 'dart:convert';

import 'package:clickvagas/models/parking_spot_model.dart';
import 'package:clickvagas/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingSpotRepository {
  Future<List<ParkingSpotModel>> loadSpots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? totalSpots = prefs.getInt('totalSpots');
    List<String>? savedData = prefs.getStringList('parkingSpots');

    if (totalSpots == null || totalSpots <= 0) {
      return [];
    }

    if (savedData != null) {
      return savedData
          .map((spot) => ParkingSpotModel.fromJson(json.decode(spot)))
          .toList();
    } else {
      return List.generate(
        totalSpots,
        (index) => ParkingSpotModel(
          name: 'Vaga ${index + 1}',
          plate: '',
          isOccupied: false,
          entrydate: null,
        ),
      );
    }
  }

  /// **Salvar todas as vagas no armazenamento**
  Future<void> saveSpots(List<ParkingSpotModel> parkingSpots) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> spotsData =
        parkingSpots.map((spot) => json.encode(spot.toJson())).toList();
    await prefs.setStringList('parkingSpots', spotsData);
  }

  /// **Verifica se a placa já está ocupando uma vaga**
  Future<bool> plateExists(String plate) async {
    List<ParkingSpotModel> spots = await loadSpots();
    return spots.any((spot) => spot.plate == plate && spot.isOccupied);
  }

  Future<void> registryEntry(
      List<ParkingSpotModel> parkingSpots, int index, String plate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await plateExists(plate)) {
      throw Exception('Placa já está no estacionamento.');
    }

    parkingSpots[index].isOccupied = true;
    parkingSpots[index].plate = plate;
    parkingSpots[index].entrydate = DateTime.now();

    await saveSpots(parkingSpots);

    TransactionModel newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plate: plate,
      entrydate: DateTime.now(),
    );

    List<String> savedData = prefs.getStringList('parkingTransactions') ?? [];
    savedData.add(json.encode(newTransaction.toJson()));

    await prefs.setStringList('parkingTransactions', savedData);
  }

  Future<void> registryExit(
      List<ParkingSpotModel> parkingSpots, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String plate = parkingSpots[index].plate;

    parkingSpots[index].isOccupied = false;
    parkingSpots[index].plate = '';
    parkingSpots[index].entrydate = null;

    await saveSpots(parkingSpots);

    List<String>? savedData = prefs.getStringList('parkingTransactions');
    if (savedData == null) return;

    List<TransactionModel> transactions = savedData
        .map((transaction) =>
            TransactionModel.fromJson(json.decode(transaction)))
        .toList();

    for (var i = 0; i < transactions.length; i++) {
      if (transactions[i].plate == plate && transactions[i].isActive()) {
        transactions[i] = transactions[i].copyWith(endDate: DateTime.now());
        break;
      }
    }

    List<String> updatedData = transactions
        .map((transaction) => json.encode(transaction.toJson()))
        .toList();
    await prefs.setStringList('parkingTransactions', updatedData);
  }

  Future<void> addNewSpot(List<ParkingSpotModel> parkingSpots) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int totalSpots = (prefs.getInt('totalSpots') ?? 0) + 1;

    parkingSpots.add(ParkingSpotModel(
      name: 'Vaga $totalSpots',
      plate: '',
      isOccupied: false,
      entrydate: null,
    ));

    await prefs.setInt('totalSpots', totalSpots);
    await saveSpots(parkingSpots);
  }

  Future<void> removeLastSpot(List<ParkingSpotModel> parkingSpots) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int indexToRemove = parkingSpots.lastIndexWhere((spot) => !spot.isOccupied);

    if (indexToRemove == -1) {
      throw Exception("Não é possível remover uma vaga ocupada.");
    }

    parkingSpots.removeAt(indexToRemove);
    int totalSpots = (prefs.getInt('totalSpots') ?? 1) - 1;

    if (totalSpots <= 0) {
      await prefs.remove('totalSpots');
      await prefs.remove('parkingSpots');
    } else {
      await prefs.setInt('totalSpots', totalSpots);
      await saveSpots(parkingSpots);
    }
  }
}
