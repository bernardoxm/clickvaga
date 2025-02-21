import 'package:clickvagas/bloc/spot_bloc/spot_bloc.dart';
import 'package:clickvagas/bloc/spot_bloc/spot_event.dart';
import 'package:clickvagas/bloc/spot_bloc/spot_state.dart';
import 'package:clickvagas/models/spot_card_info.dart';
import 'package:clickvagas/models/spot_model.dart';
import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:clickvagas/repository/parking_spot_repository.dart';
import 'package:clickvagas/widgets/created_parking_spots_widget.dart';
import 'package:clickvagas/widgets/entry_spot_plate_widget.dart';
import 'package:clickvagas/widgets/exit_dialog_widget.dart';
import 'package:clickvagas/widgets/find_widget.dart';
import 'package:clickvagas/widgets/parking_spot_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ParkingSpotsPage extends StatefulWidget {
  const ParkingSpotsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParkingSpotsPageState createState() => _ParkingSpotsPageState();
}

class _ParkingSpotsPageState extends State<ParkingSpotsPage> {
  DataText dataText = DataText();
  DataColor dataColors = DataColor();
  late SpotBloc spotBloc;

  @override
  void initState() {
    super.initState();
    spotBloc = SpotBloc(repository: ParkingSpotRepository());
    spotBloc.add(LoadSpotsEvent());
  }

  @override
  void dispose() {
    spotBloc.close();
    super.dispose();
  }

  Future<void> _createdParkingSpots(BuildContext context) async {
    TextEditingController spotsController = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text(dataText.textLetsGetStarted,
                  textAlign: TextAlign.center),
              content:
                  CreatedParkingSpotsWidget(spotsController: spotsController),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      int? spots = int.tryParse(spotsController.text);
                      if (spots != null && spots > 0) {
                        await spotBloc.repository.createSpots(spots);
                        Future.delayed(Duration.zero, () {
                          spotBloc.add(LoadSpotsEvent());
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Text(
                      dataText.textSave,
                      style: TextStyle(color: dataColors.colorWhite),
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

  void _showEntryDialogForSpot(SpotModel spot) {
    showDialog(
      context: context,
      builder: (context) {
        return EntryDialogWidget(
          onConfirm: (plate) async {
            try {
              spotBloc.add(RegistryEntryEvent(spot: spot, plate: plate));
            } catch (e) {
              _showErrorDialog(e.toString());
            }
          },
        );
      },
    );
  }

  void _showExitDialogForSpot(SpotModel spot) {
    final currentState = spotBloc.state;
    if (currentState is SpotLoaded) {
      final cardInfo = currentState.spotCardInfos.firstWhere(
        (card) => card.spotId == spot.id,
        orElse: () => throw Exception(
            "Registro de entrada não encontrado para esse spot"),
      );
      showDialog(
        context: context,
        builder: (context) {
          return ExitDialogWidget(
            plate: cardInfo.plate ?? "",
            entryTime: cardInfo.entryDate!,
            onConfirm: () async {
              try {
                spotBloc.add(RegistryExitEvent(spot));
              } catch (e) {
                _showErrorDialog(e.toString());
              }
            },
          );
        },
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(dataText.textOk),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpotBloc>(
      create: (context) => spotBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(dataText.textPatio),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                spotBloc.add(LoadSpotsEvent());
              },
            ),
            IconButton(
              onPressed: () {
                final currentState = spotBloc.state;
                if (currentState is SpotLoaded) {
                  spotBloc.add(AddSpotEvent(
                    SpotModel(
                      id: Uuid().v4(),
                      name: '${currentState.spots.length + 1}',
                      isOccupied: false,
                    ),
                  ));
                }
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
            onPressed: () {
              final currentState = spotBloc.state;
              if (currentState is SpotLoaded) {
                final lastSpot = currentState.spots.isNotEmpty ? currentState.spots.last : null;
                if (lastSpot != null && !lastSpot.isOccupied) {
                  spotBloc.add(RemoveLastSpotEvent());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(dataText.textDelSpotIsOccupied))
                  );
                }
              }
            },
            icon: Icon(Icons.delete),
          )
          ],
        ),
        body: BlocBuilder<SpotBloc, SpotState>(
          builder: (context, state) {
            if (state is SpotLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SpotError) {
            } else if (state is SpotLoaded) {
              List<SpotCardInfo> filteredCards =
                  state.spotCardInfos.where((card) {
                if (state.search.isNotEmpty) {
                  String plate = card.plate ?? "";
                  return plate
                      .toLowerCase()
                      .contains(state.search.toLowerCase());
                }
                if (state.filterStatus == 1) {
                  return card.isOccupied;
                } else if (state.filterStatus == 2) {
                  return !card.isOccupied;
                }
                return true;
              }).toList();

              if (state.spotCardInfos.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _createdParkingSpots(context);
                });
              }

              int spotsOccupied =
                  state.spotCardInfos.where((card) => card.isOccupied).length;

              return Column(
                children: [
                  FindWidget(
                    totalSpots: state.spots.length,
                    spotsOccupied: spotsOccupied,
                    onSearch: (plate) {
                      spotBloc.add(SearchPlateEvent(plate));
                    },
                    onAdd: () {
                      spotBloc.add(AddSpotEvent(
                        SpotModel(
                          id: Uuid().v4(),
                          name: 'Spot ${state.spots.length}',
                          isOccupied: false,
                        ),
                      ));
                    },
                    onRemove: () {
                      spotBloc.add(RemoveLastSpotEvent());
                    },
                    onFilterAll: () {
                      spotBloc.add(const ApplyFilterEvent(0));
                    },
                    onFilterOccupied: () {
                      spotBloc.add(const ApplyFilterEvent(1));
                    },
                    onFilterAvailable: () {
                      spotBloc.add(const ApplyFilterEvent(2));
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: filteredCards.isEmpty
                          ?  Center(
                              child:
                                  Text(dataText.textSpotNotAvailables,),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 4,
                              ),
                              itemCount: filteredCards.length,
                              itemBuilder: (context, index) {
                                final cardInfo = filteredCards[index];
                                final SpotModel spot = SpotModel(
                                  id: cardInfo.spotId,
                                  name: cardInfo.spotName,
                                  isOccupied: cardInfo.isOccupied,
                                );
                                return ParkingSpotCardWidget(
                                  index: index,
                                  isOccupied: cardInfo.isOccupied,
                                  plate: cardInfo.plate ?? "",
                                  spotName: cardInfo.spotName,
                                  entryTime: cardInfo.entryDate,
                                  onTap: () {
                                    if (cardInfo.isOccupied) {
                                      _showExitDialogForSpot(spot);
                                    } else {
                                      _showEntryDialogForSpot(spot);
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
