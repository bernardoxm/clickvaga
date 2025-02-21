import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistCardWidget extends StatelessWidget {
  final ParkingSpotModel transactionModel;
  final String Function(DateTime, DateTime?) formatDuration;
  DataColor dataColors = DataColor();
  DataText dataText = DataText();

 HistCardWidget(
      {super.key,
      required this.transactionModel,
      required this.formatDuration});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(
          '${dataText.textPlate} ${transactionModel.plate ?? dataText.textunknown }',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: dataText.textEntry,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: transactionModel.entrydate != null
                        ? DateFormat('dd/MM/yyyy HH:mm')
                            .format(transactionModel.entrydate!)
                        : dataText.textNoDate,
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
                    text: transactionModel.exitdate != null
                        ? DateFormat('dd/MM/yyyy HH:mm')
                            .format(transactionModel.exitdate!)
                        : dataText.textStillSpot,
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: dataText.textDuration,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: transactionModel.entrydate != null
                        ? formatDuration(transactionModel.entrydate!,
                            transactionModel.exitdate)
                        : dataText.textUnavailable,
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: Icon(
          transactionModel.exitdate == null
              ? Icons.directions_bus
              : Icons.check_circle,
          color: transactionModel.exitdate == null
              ? dataColors.colorRed
              : dataColors.colorsGren,
        ),
      ),
    );
  }
}
