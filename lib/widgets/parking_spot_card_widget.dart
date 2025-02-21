import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:clickvagas/widgets/license_plate_widget.dart';
import 'package:flutter/material.dart';

class ParkingSpotCardWidget extends StatelessWidget {
  DataColor dataColor = DataColor();
  DataText dataText = DataText();
  final int index;
  final bool isOccupied;
  final String plate;
  final DateTime? entryTime;
  final VoidCallback? onTap;
  final String spotName;

   ParkingSpotCardWidget({
    super.key,
    required this.index,
    required this.isOccupied,
    required this.plate,
    required this.entryTime,
    this.onTap,
    required this.spotName,
  });

  String formatSpotName(String originalName) {
    if (originalName.toLowerCase().startsWith("spot")) {
      List<String> parts = originalName.split(" ");
      if (parts.length >= 2) {
        int? num = int.tryParse(parts[1]);
        if (num != null) {
          return "VAGA ${num + 1}";
        }
      }
    }
    return "VAGA $originalName";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
       
              Container(
                height: 70,
                width: 40,
                decoration: BoxDecoration(
                  color: isOccupied ? dataColor.colorRed : dataColor.colorsGren,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    isOccupied ? Icons.car_rental : Icons.local_parking,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

     
              Expanded(
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          formatSpotName(spotName),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          isOccupied ? dataText.textSpotOccup : dataText.textSpotAvailable,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isOccupied
                                ? dataColor.colorRed
                                : dataColor.colorsGren,
                          ),
                        ),
                      ],
                    ),
                    if (isOccupied == false)
                      LicensePlateWidget(
                        plate: dataText.textSpotAvailable,
                      ),
                    if (isOccupied) ...[
                      LicensePlateWidget(
                        plate: plate,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
