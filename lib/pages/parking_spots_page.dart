import 'package:clickvaga/bloc/bloc_transaction/transaction_bloc.dart';
import 'package:clickvaga/bloc/bloc_transaction/transaction_state.dart';
import 'package:clickvaga/models/transaction_model.dart';
import 'package:clickvaga/widgets/entry_dialog_widget.dart';
import 'package:clickvaga/widgets/exit_dialog_widget.dart';
import 'package:clickvaga/widgets/parking_spot_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ParkingSpot is a class that represents a parking spot.
// ParkingSpot é uma classe que representa uma vaga de estacionamento.
// It has three properties: isOccupied, plate, and entryTime.
// Possui três propriedades: isOccupied, plate e entryTime.
// isOccupied is a boolean that indicates if the spot is occupied or available.
// isOccupied é um booleano que indica se a vaga está ocupada ou disponível.
// plate is a string that represents the vehicle plate parked in the spot.
// plate é uma string que representa a placa do veículo estacionado na vaga.
// entryTime is a DateTime that represents the time when the vehicle entered the spot.
// entryTime é um DateTime que representa o horário em que o veículo entrou na vaga.
// The ParkingSpot class has a toMap
// method that converts the object to a map of key-value pairs.
// A classe ParkingSpot tem um método toMap que converte o objeto em um mapa de pares chave-valor.
// The ParkingSpot class has a fromMap method that creates a ParkingSpot object from a map.
// A classe ParkingSpot tem um método fromMap que cria um objeto ParkingSpot a partir de um mapa.
// The ParkingSpotsPage is a StatefulWidget that shows a list of parking spots.
// A classe ParkingSpotsPage é um StatefulWidget que exibe uma lista de vagas de estacionamento.
// It has a list of ParkingSpot objects and a totalSpots variable.
// Possui uma lista de objetos ParkingSpot e uma variável totalSpots.
// The _loadParkingSpots method loads the parking spots from SharedPreferences.
// O método _loadParkingSpots carrega as vagas de estacionamento do SharedPreferences.
// The _saveParkingSpots method saves the parking spots to SharedPreferences.
// O método _saveParkingSpots salva as vagas de estacionamento no SharedPreferences.
// The _addNewSpot method adds a new parking spot to the list.
// O método _addNewSpot adiciona uma nova vaga de estacionamento à lista.
// The _removeLastSpot method removes the last available parking spot from the list.
// O método _removeLastSpot remove a última vaga de estacionamento disponível da lista.
// The getFilteredSpots method returns a list of parking spots based on the filterStatus.
// O método getFilteredSpots retorna uma lista de vagas de estacionamento com base no filterStatus.

class ParkingSpot {
  bool isOccupied;
  String plate;
  DateTime? entryTime;

  ParkingSpot({this.isOccupied = false, this.plate = "", this.entryTime});

  Map<String, dynamic> toMap() {
    return {
      'isOccupied': isOccupied,
      'plate': plate,
      'entryTime': entryTime?.toIso8601String(),
    };
  }

  factory ParkingSpot.fromMap(Map<String, dynamic> map) {
    return ParkingSpot(
      isOccupied: map['isOccupied'] ?? false,
      plate: map['plate'] ?? "",
      entryTime:
          map['entryTime'] != null ? DateTime.parse(map['entryTime']) : null,
    );
  }
}

class ParkingSpotsPage extends StatefulWidget {
  const ParkingSpotsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParkingSpotsPageState createState() => _ParkingSpotsPageState();
}

class _ParkingSpotsPageState extends State<ParkingSpotsPage> {
  List<ParkingSpot> parkingSpots = [];
  int totalSpots = 0;
  int filter = 1;
  double filter2 = 4;
  int filterStatus =
      0; // 0 = Todos, 1 = Apenas Ocupados, 2 = Apenas Disponíveis

  @override
  void initState() {
    super.initState();
    _loadParkingSpots();
  }

  Future<void> _loadParkingSpots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedSpots = prefs.getInt('totalSpots');

    if (savedSpots == null || savedSpots <= 0) {
      _showConfigDialog();
    } else {
      setState(() {
        totalSpots = savedSpots;
        List<String>? savedData = prefs.getStringList('parkingSpots');
        if (savedData != null) {
          parkingSpots = savedData
              .map((spot) => ParkingSpot.fromMap(json.decode(spot)))
              .toList();
        } else {
          parkingSpots = List.generate(totalSpots, (index) => ParkingSpot());
        }
      });
    }
  }

  Future<void> _saveParkingSpots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> spotsData =
        parkingSpots.map((spot) => json.encode(spot.toMap())).toList();
    await prefs.setStringList('parkingSpots', spotsData);
  }

  Future<void> _addNewSpot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalSpots += 1;
      parkingSpots.add(ParkingSpot());
    });
    await prefs.setInt('totalSpots', totalSpots);
    await _saveParkingSpots();
  }

  Future<void> _removeLastSpot() async {
    int indexToRemove = parkingSpots.lastIndexWhere((spot) => !spot.isOccupied);
    if (indexToRemove == -1) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro"),
              content: Text("Não é possível remover uma vaga ocupada"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Ok"),
                ),
              ],
            );
          });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalSpots -= 1;
      parkingSpots.removeAt(indexToRemove);
    });
    if (totalSpots <= 0) {
      _showConfigDialog();
    } else {
      await prefs.setInt('totalSpots', totalSpots);
      await _saveParkingSpots();
    }
  }

  List<ParkingSpot> getFilteredSpots() {
    if (filterStatus == 1) {
      return parkingSpots.where((spot) => spot.isOccupied).toList();
    } else if (filterStatus == 2) {
      return parkingSpots.where((spot) => !spot.isOccupied).toList();
    } else {
      return parkingSpots;
    }
  }

  Future<void> _showConfigDialog() async {
    TextEditingController spotsController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Informe o número de vagas"),
          content: TextField(
            controller: spotsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Número de vagas"),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  int? spots = int.tryParse(spotsController.text);
                  if (spots != null && spots > 0) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setInt('totalSpots', spots);

                    setState(() {
                      totalSpots = spots;
                      parkingSpots =
                          List.generate(totalSpots, (index) => ParkingSpot());
                    });

                    await _saveParkingSpots();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                child: Text("Salvar"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ParkingSpot> filteredSpots = getFilteredSpots();
    if (totalSpots == 0) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Pátio",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.white),
            onSelected: (String choice) {
              if (choice == "add") {
                _addNewSpot();
              } else if (choice == "remove") {
                _removeLastSpot();
              } else if (choice == "viewSquare") {
                setState(() {
                  filter = 2;
                  filter2 = 1.9;
                });
              } else if (choice == "viewLines") {
                setState(() {
                  filter = 1;
                  filter2 = 4;
                });
              } else if (choice == "filterAll") {
                setState(() {
                  filterStatus = 0;
                });
              } else if (choice == "filterOccupied") {
                setState(() {
                  filterStatus = 1;
                });
              } else if (choice == "filterAvailable") {
                setState(() {
                  filterStatus = 2;
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  value: "add",
                  child: ListTile(
                      leading: Icon(Icons.add), title: Text("Adicionar Vaga"))),
              PopupMenuItem<String>(
                  value: "remove",
                  child: ListTile(
                      leading: Icon(Icons.remove),
                      title: Text("Remover Última Vaga"))),
              PopupMenuItem<String>(
                value: "viewSquare",
                child: ListTile(
                    leading: Icon(Icons.apps_rounded),
                    title: Text("Visualizar em Quadrados")),
              ),
              PopupMenuItem<String>(
                value: "viewLines",
                child: ListTile(
                  leading: Icon(Icons.article_outlined),
                  title: Text("Visualizar em Linhas"),
                ),
              ),
              PopupMenuItem<String>(
                  value: "filterAll",
                  child: ListTile(
                    leading: Icon(Icons.car_repair),
                    title: Text("Mostrar Todas as Vagas"),
                  )),
              PopupMenuItem<String>(
                  value: "filterOccupied",
                  child: ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text("Mostrar Apenas Vagas Ocupadas"),
                  )),
              PopupMenuItem<String>(
                  value: "filterAvailable",
                  child: ListTile(
                    leading: Icon(Icons.directions_bus_filled_outlined),
                    title: Text("Mostrar Apenas Vagas Disponíveis"),
                  )),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<ParkingBloc, ParkingState>(
            builder: (context, state) {
              return Container(
                color: Colors.blue,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Disponíveis: ${state.availableSpots}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Ocupados: ${state.occupiedSpots.length}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: filteredSpots.isEmpty
                  ? Center(
                      child: Text("Não a vagas disponíveis ou ocupadas"),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: filter,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: filter2,
                      ),
                      itemCount: filteredSpots.length,
                      itemBuilder: (context, index) {
                        int originalIndex =
                            parkingSpots.indexOf(filteredSpots[index]);
                        return ParkingSpotCardWidget(
                          index: originalIndex,
                          isOccupied: filteredSpots[index].isOccupied,
                          plate: filteredSpots[index].plate,
                          entryTime: filteredSpots[index].entryTime,
                          onTap: () {
                            if (filteredSpots[index].isOccupied) {
                              _showExitDialog(
                                  parkingSpots.indexOf(filteredSpots[index]));
                            } else {
                              _showEntryDialog(
                                  parkingSpots.indexOf(filteredSpots[index]));
                            }
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerEntry(String plate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    TransactionModel newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plate: plate,
      entrydate: DateTime.now(),
    );

    List<String>? savedData = prefs.getStringList('parkingTransactions') ?? [];
    savedData.add(json.encode(newTransaction.toJson()));

    await prefs.setStringList('parkingTransactions', savedData);
  }

  void _showEntryDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EntryDialogWidget(
          onConfirm: (plate) {
            setState(() {
              parkingSpots[index].isOccupied = true;
              parkingSpots[index].plate = plate;
              parkingSpots[index].entryTime = DateTime.now();

              _saveParkingSpots();
              _registerEntry(plate);
            });
          },
        );
      },
    );
  }

  Future<void> _registerExit(String plate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedData = prefs.getStringList('parkingTransactions');

    if (savedData == null) return;

    List<TransactionModel> transactions = savedData
        .map((t) => TransactionModel.fromJson(json.decode(t)))
        .toList();

    for (var transaction in transactions) {
      if (transaction.plate == plate && transaction.endDate == null) {
        transaction.endDate = DateTime.now();
        break;
      }
    }

    List<String> updatedData =
        transactions.map((t) => json.encode(t.toJson())).toList();
    await prefs.setStringList('parkingTransactions', updatedData);
  }

  void _showExitDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return ExitDialogWidget(
          plate: parkingSpots[index].plate,
          entryTime: parkingSpots[index].entryTime!,
          onConfirm: () {
            setState(() {
              parkingSpots[index].isOccupied = false;

              parkingSpots[index].entryTime = null;
              _saveParkingSpots();
              _registerExit(parkingSpots[index].plate);
              parkingSpots[index].plate = "";
            });
          },
        );
      },
    );
  }
}
