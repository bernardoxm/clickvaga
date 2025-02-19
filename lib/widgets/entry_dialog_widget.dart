import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryDialogWidget extends StatefulWidget {
  final Function(String) onConfirm;

  const EntryDialogWidget({super.key, required this.onConfirm});

  @override
  State<EntryDialogWidget> createState() => _EntryDialogWidgetState();
}


// EntryDialogWidget is a StatefulWidget that shows a dialog to register a vehicle entry.
// EntryDialogWidget é um StatefulWidget que exibe um diálogo para registrar a entrada de um veículo.
// The dialog has a text field to enter the vehicle plate and a text with the current date and time.
// O diálogo possui um campo de texto para inserir a placa do veículo e um texto com a data e hora atuais.
// When the user clicks on the "Registrar entrada" button, the onConfirm function is called with the plate value.
// Quando o usuário clica no botão "Registrar entrada", a função onConfirm é chamada com o valor da placa.
// The dialog can be closed by clicking on the "Cancelar" button.
// O diálogo pode ser fechado clicando no botão "Cancelar".
// The onConfirm function is passed as a parameter to the widget constructor. 
// A função onConfirm é passada como parâmetro para o construtor do widget.

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
