import 'package:clickvagas/bloc/bloc_plate/plate_bloc.dart';
import 'package:clickvagas/bloc/bloc_plate/plate_event.dart';
import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EntryDialogWidget extends StatefulWidget {
  final Function(String) onConfirm;

  const EntryDialogWidget({super.key, required this.onConfirm});

  @override
  State<EntryDialogWidget> createState() => _EntryDialogWidgetState();
}

class _EntryDialogWidgetState extends State<EntryDialogWidget> {
  DataColor dataColors = DataColor();
  DataText dataText = DataText();
  String plate = "";
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlateBloc, PlateState>(builder: (context, state) {
      return AlertDialog(
        title: Text(dataText.textVehicleEntry),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(maxLength: 7,
                decoration: InputDecoration(
                 
                  hintText: dataText.textPlateEx,
                  errorText: state.plate.isNotEmpty && !state.isValid
                      ? dataText.textInvalidPlate
                      : null,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    errorMessage = null; 
                  });
                  context.read<PlateBloc>().add(UpdatePlate(value));
                  plate = value;
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: state.plate,
                    selection: TextSelection.collapsed(offset: state.plate.length),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${dataText.textEntry} ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
                style: TextStyle(fontSize: 14),
              ),
              if (errorMessage != null) 
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: dataColors.colorRed, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(dataColors.colorRed),
                ),
                onPressed: () {
                  plate = "";
                  context.read<PlateBloc>().add(UpdatePlate(""));
                  Navigator.pop(context);
                },
                child: Text(
                 dataText.textCancel,
                  style: TextStyle(color: dataColors.colorWhite),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  var plate = context.read<PlateBloc>().state.plate;

                  if (plate.isEmpty) {
                    setState(() {
                      errorMessage = "O campo de placa não pode estar vazio.";
                    });
                    return;
                  }

                  if (!context.read<PlateBloc>().state.isValid) {
                    setState(() {
                      errorMessage = "Formato de placa inválido.";
                    });
                    return;
                  }

                  bool exists = await context.read<PlateBloc>().checkIfPlateIsActive(plate);

                  if (exists) {
                    setState(() {
                      errorMessage = "Esta placa já está em uso.";
                    });
                    return;
                  }

                  widget.onConfirm(plate);
                  Navigator.pop(context);
                  context.read<PlateBloc>().add(UpdatePlate(""));
                },
                child: Text(
                 dataText.textBtnEntry,
                  style: TextStyle(color: dataColors.colorWhite),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
