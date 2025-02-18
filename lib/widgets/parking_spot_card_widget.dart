
import 'package:flutter/material.dart';

class ParkingSpotCardWidget extends StatelessWidget {
  final int index;
  final bool isOccupied;
  final String plate;
  final DateTime? entryTime;
  final VoidCallback? onTap;
  

  const ParkingSpotCardWidget(
      {super.key, required this.index,
      required this.isOccupied,
      required this.plate,
      required this.entryTime,
      this.onTap});


  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration:
              BoxDecoration(color: isOccupied ? Colors.red : Colors.green),
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Vaga ${index + 1}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(
              isOccupied ? "Ocupada" : "Disponível",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            if (isOccupied)
              Text("Placa: $plate",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
          ])),
    );
  }
}
