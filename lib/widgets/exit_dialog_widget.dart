import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: TextButton(
                
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Color.fromRGBO(207, 54, 87, 1), //cor da raro
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Veículo $plate saiu do estacionamento")),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
                onConfirm();
              },
              child: Text(
                "Saída",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "$hours horas e $minutes minutos";
  }
}
