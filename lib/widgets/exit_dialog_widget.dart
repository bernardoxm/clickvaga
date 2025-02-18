

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExitDialogWidget extends StatelessWidget {
  final String plate;
  final DateTime entryTime;
  final VoidCallback onConfirm;

  const ExitDialogWidget(
      {super.key, required this.plate, required this.entryTime, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text('Saída do veículo'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       Text("Placa: $plate"),
          Text("Entrada: ${DateFormat('dd/MM/yyyy HH:mm').format(entryTime)}"),
          Text("Saída: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}"),
        Text("Duração: ${_formatDuration(DateTime.now().difference(entryTime))}"),

      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Cancelar"),
      ),
      ElevatedButton(
        onPressed: (){onConfirm();  Navigator.pop(context);},
        
        child: Text("Registrar saída"),
      ),
    ],
    );
    
  }String _formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  return "$hours horas e $minutes minutos";
}
}
