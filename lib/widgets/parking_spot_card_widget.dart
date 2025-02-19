import 'package:flutter/material.dart';




class ParkingSpotCardWidget extends StatelessWidget {
  final int index;
  final bool isOccupied;
  final String plate;
  final DateTime? entryTime;
  final VoidCallback? onTap;

  const ParkingSpotCardWidget({
    super.key,
    required this.index,
    required this.isOccupied,
    required this.plate,
    required this.entryTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isOccupied ? Colors.red : Color.fromRGBO(68, 194, 253, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: MediaQuery.of(context).size.height * -0.01,
              top: -10,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
                width: MediaQuery.of(context).size.height * 0.11,
                child: isOccupied ?  Image.asset('assets/truckP.png') : Image.asset('assets/truck.png'),
              ),
            ),
            Align(
              alignment: Alignment.lerp(
                  Alignment.center, Alignment.bottomRight, 0.89)!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vaga ${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isOccupied ? "Ocupada" : "Disponível",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isOccupied)
                    Text(
                      "Placa: $plate",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
