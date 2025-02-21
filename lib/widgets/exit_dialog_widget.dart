import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
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
      DataText dataText = DataText();
    DataColor dataColors = DataColor();
    return AlertDialog(
      title: Text(
        dataText.textVehicleExit,
      ),
      
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text: dataText.textPlate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: plate), 
              ],
            ),
          ),
          if (entryTime != null)
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: dataText.textEntry,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: DateFormat('dd/MM/yyyy HH:mm').format(entryTime!),
                  ),
                ],
              ),
            ),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text: dataText.textExit,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                ),
              ],
            ),
          ),
          if (entryTime != null)
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: dataText.textDuration,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        _formatDuration(DateTime.now().difference(entryTime)),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        Row( spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                   dataColors.colorRed , 
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(dataText.textCancel,
                    style: TextStyle(color: dataColors.colorWhite)),
              ),
            ),



            Expanded(
              child: ElevatedButton(
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
                  dataText.textBtnExit,
                  style: TextStyle(color: dataColors.colorWhite),
                ),
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
