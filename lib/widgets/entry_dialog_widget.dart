import 'package:clickvagas/bloc/bloc_plate/plate_bloc.dart';
import 'package:clickvagas/bloc/bloc_plate/plate_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';

class EntryDialogWidget extends StatefulWidget {
  final Function(String) onConfirm;

  const EntryDialogWidget({super.key, required this.onConfirm});

  @override
  State<EntryDialogWidget> createState() => _EntryDialogWidgetState();
}

class _EntryDialogWidgetState extends State<EntryDialogWidget> {
  String plate = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlateBloc, PlateState>(builder: (context, state) {
      return AlertDialog(
        title: Text('Entrada de veículo'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.height * 1,
          child: Column(
            spacing: 10,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Placa",
                  hintText: "AAA-1234 ou AAA1A23",
                  errorText: state.plate.isNotEmpty && !state.isValid
                      ? "Placa inválida"
                      : null,
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [],
                onChanged: (value) {
                  context.read<PlateBloc>().add(UpdatePlate(value));
                  plate = value;
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: state.plate,
                    selection:
                        TextSelection.collapsed(offset: state.plate.length),
                  ),
                ),
              ),
              Text(
                  "Entrada: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}"),
            ],
          ),
        ),
        actions: [
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton( style: ButtonStyle(backgroundColor:WidgetStateProperty.all(
             Color.fromRGBO(207, 54, 87, 1), //cor da raro
            ), ),
                  onPressed: () {
                    plate = "";
                    context.read<PlateBloc>().add(UpdatePlate(""));
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  )),
              ElevatedButton(
                onPressed: () {
                  var plate = context.read<PlateBloc>().state.plate;
                  if (plate.isNotEmpty &&
                      context.read<PlateBloc>().state.isValid) {
                    widget.onConfirm(plate);
                    Navigator.pop(context);
                    plate = "";
                    context.read<PlateBloc>().add(UpdatePlate(""));
                  }
                },
                child: Text(
                  "Entrada",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
