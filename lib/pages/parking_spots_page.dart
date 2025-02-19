import 'package:clickvagas/repository/parking_spot_repository.dart';
import 'package:clickvagas/models/parking_spot_model.dart';

import 'package:clickvagas/widgets/created_parking_spots_widget.dart';
import 'package:clickvagas/widgets/entry_dialog_widget.dart';
import 'package:clickvagas/widgets/exit_dialog_widget.dart';
import 'package:clickvagas/widgets/find_widget.dart';
import 'package:clickvagas/widgets/parking_spot_card_widget.dart';
import 'package:flutter/material.dart';

class ParkingSpotsPage extends StatefulWidget {
  const ParkingSpotsPage({super.key});

  @override
  _ParkingSpotsPageState createState() => _ParkingSpotsPageState();
}

class _ParkingSpotsPageState extends State<ParkingSpotsPage> {
  final ParkingSpotRepository _repository = ParkingSpotRepository();
  List<ParkingSpotModel> parkingSpots = [];
  List<ParkingSpotModel> filteredSpots = [];
  bool isSearching = false;
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

  /// **Carrega as vagas do repositório**
  Future<void> _loadParkingSpots() async {
    List<ParkingSpotModel> spots = await _repository.loadSpots();
    setState(() {
      parkingSpots = spots;
      filteredSpots = spots;
      totalSpots = spots.length;
    });

    if (totalSpots == 0) {
      _createdParkingSpots();
    }
  }

  Future<void> _addNewSpot() async {
    await _repository.addNewSpot(parkingSpots);
    _loadParkingSpots();
  }

  Future<void> _removeLastSpot() async {
    try {
      await _repository.removeLastSpot(parkingSpots);
      _loadParkingSpots();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _createdParkingSpots() async {
    TextEditingController spotsController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text("Vamos começar!!!", textAlign: TextAlign.center),
              content:
                  CreatedParkingSpotsWidget(spotsController: spotsController),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      int? spots = int.tryParse(spotsController.text);
                      if (spots != null && spots > 0) {
                        await _repository.initializeParkingSpots(spots);
                        await _loadParkingSpots();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  void _showEntryDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EntryDialogWidget(
          onConfirm: (plate) async {
            try {
              await _repository.registryEntry(parkingSpots, index, plate);
              _loadParkingSpots();
            } catch (e) {
              _showErrorDialog(e.toString());
            }
          },
        );
      },
    );
  }

  void _showExitDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return ExitDialogWidget(
          plate: parkingSpots[index].plate,
          entryTime: parkingSpots[index].entrydate!,
          onConfirm: () async {
            await _repository.registryExit(parkingSpots, index);
            _loadParkingSpots();
          },
        );
      },
    );
  }

  List<ParkingSpotModel> getFilteredSpots() {
    if (isSearching) return filteredSpots;
    if (filterStatus == 1)
      return parkingSpots.where((spot) => spot.isOccupied).toList();
    if (filterStatus == 2)
      return parkingSpots.where((spot) => !spot.isOccupied).toList();
    return parkingSpots;
  }

  @override
  Widget build(BuildContext context) {
    int spotsOccupied = parkingSpots.where((spot) => spot.isOccupied).length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pátio"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (String choice) {
              if (choice == "add") {
                _addNewSpot();
              } else if (choice == "remove") {
                _removeLastSpot();
              } else if (choice == "viewSquare") {
                setState(() {
                  filter = 2; // Define duas colunas (quadrados)
                  filter2 = 1.9; // Mantém o formato quadrado
                });
              } else if (choice == "viewLines") {
                setState(() {
                  filter = 1; // Define uma única coluna (linhas)
                  filter2 = 4; // Formato mais largo
                });
              } else if (choice == "filterAll") {
                setState(() => filterStatus = 0);
              } else if (choice == "filterOccupied") {
                setState(() => filterStatus = 1);
              } else if (choice == "filterAvailable") {
                setState(() => filterStatus = 2);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "add",
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Adicionar Vaga"),
                ),
              ),
              PopupMenuItem(
                value: "remove",
                child: ListTile(
                  leading: Icon(Icons.remove),
                  title: Text("Remover Última Vaga"),
                ),
              ),
              PopupMenuItem(
                value: "viewSquare",
                child: ListTile(
                  leading: Icon(Icons.apps_rounded),
                  title: Text("Visualizar em Quadrados"),
                ),
              ),
              PopupMenuItem(
                value: "viewLines",
                child: ListTile(
                  leading: Icon(Icons.article_outlined),
                  title: Text("Visualizar em Linhas"),
                ),
              ),
              PopupMenuItem(
                value: "filterAll",
                child: ListTile(
                  leading: Icon(Icons.car_repair),
                  title: Text("Mostrar Todas"),
                ),
              ),
              PopupMenuItem(
                value: "filterOccupied",
                child: ListTile(
                  leading: Icon(Icons.directions_bus),
                  title: Text("Mostrar Ocupadas"),
                ),
              ),
              PopupMenuItem(
                value: "filterAvailable",
                child: ListTile(
                  leading: Icon(Icons.directions_bus_filled_outlined),
                  title: Text("Mostrar Disponíveis"),
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          FindWidget(
            totalSpots: totalSpots,
            spotsOccupied: spotsOccupied,
            onSearch: (String plate) {
              setState(() {
                isSearching = plate.isNotEmpty;
                filteredSpots = parkingSpots
                    .where((spot) =>
                        spot.plate.isNotEmpty &&
                        spot.plate.toLowerCase().contains(plate.toLowerCase()))
                    .toList();
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: getFilteredSpots().isEmpty
                  ? Center(child: Text("Não há vagas disponíveis ou ocupadas"))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: filter,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: filter2,
                      ),
                      itemCount: getFilteredSpots().length,
                      itemBuilder: (context, index) {
                        int originalIndex = parkingSpots.indexWhere((spot) =>
                            spot.name == getFilteredSpots()[index].name);

                        return ParkingSpotCardWidget(
                          index: originalIndex,
                          isOccupied: getFilteredSpots()[index].isOccupied,
                          plate: getFilteredSpots()[index].plate,
                          entryTime: getFilteredSpots()[index].entrydate,
                          onTap: () {
                            if (originalIndex != -1) {
                              if (getFilteredSpots()[index].isOccupied) {
                                _showExitDialog(originalIndex);
                              } else {
                                _showEntryDialog(originalIndex);
                              }
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
}
