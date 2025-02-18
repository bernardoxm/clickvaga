import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      content: SizedBox(height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.height * 1,
        child: Column( spacing: 10,
          children: [
            
            TextField(
              decoration: InputDecoration(labelText: "Placa"),
              onChanged: (value) {
                plate = value;
              }, 
            ),
            Text("Entrada: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}"),
          ],
        ),
      ),
      actions: [
        Row(children: [   TextButton(
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
        ),],)
     
      ],
    );
  }
}
