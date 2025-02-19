import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ExitDialogWidget is a StatelessWidget that shows a dialog to register a vehicle exit.
// ExitDialogWidget é um StatelessWidget que exibe um diálogo para registrar a saída de um veículo.
// The dialog shows the vehicle plate, entry time, exit time, and duration.
// O diálogo mostra a placa do veículo, o horário de entrada, o horário de saída e a duração.
// When the user clicks on the "Registrar saída" button, the onConfirm function is called.
// Quando o usuário clica no botão "Registrar saída", a função onConfirm é chamada.
// The dialog can be closed by clicking on the "Cancelar" button.
// O diálogo pode ser fechado clicando no botão "Cancelar".
// The onConfirm function is passed as a parameter to the widget constructor.
// A função onConfirm é passada como parâmetro para o construtor do widget.

class ExitDialogWidget extends StatelessWidget {

  

  final String plate;
  final DateTime entryTime;
  final VoidCallback onConfirm;

  const ExitDialogWidget(
      {super.key,
      required this.plate,
      required this.entryTime,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Saída do veículo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Placa: $plate"),
          Text("Entrada: ${DateFormat('dd/MM/yyyy HH:mm').format(entryTime)}"),
          Text(
              "Saída: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}"),
          Text(
              "Duração: ${_formatDuration(DateTime.now().difference(entryTime))}"),
        ],
      ),
      actions: [

        Row(children: [TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
          
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Veículo $plate saiu do estacionamento")),
            );
            if (context.mounted) {
              Navigator.pop(context);
            }
            onConfirm();
          },
          child: Text("Registrar Saída"),
        ),],),
        
      ],
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "$hours horas e $minutes minutos";
  }
}
