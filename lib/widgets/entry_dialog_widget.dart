import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: Text('Entrada de veículo'),
      content: TextField(
        decoration: InputDecoration(labelText: "Placa"),
        onChanged: (value) {
          plate = value;
        },
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar")),
        ElevatedButton(
          onPressed: () {
            if (plate.isNotEmpty) {
              widget.onConfirm(plate);
              Navigator.pop(context);
            }
          },
          child: Text("Registrar entrada"),
        ),
      ],
    );
  }
}
