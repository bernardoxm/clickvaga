import 'package:flutter/material.dart';


// ParkingSpotCardWidget is a StatelessWidget that shows a card with information about a parking spot.
// ParkingSpotCardWidget é um StatelessWidget que exibe um cartão com informações sobre uma vaga de estacionamento.
// The card shows the parking spot number, if it's occupied or available, the vehicle plate, and the entry time.  
// O cartão mostra o número da vaga de estacionamento, se está ocupada ou disponível, a placa do veículo e o horário de entrada.
// The card can be tapped to show more details about the parking spot.
// O cartão pode ser tocado para mostrar mais detalhes sobre a vaga de estacionamento.
// The onTap function is called when the card is tapped.
// A função onTap é chamada quando o cartão é tocado.
// The card color is red if the spot is occupied and blue if it's available.
// A cor do cartão é vermelha se a vaga estiver ocupada e azul se estiver disponível.
// The plate and entryTime parameters are optional and only shown if the spot is occupied.
// Os parâmetros plate e entryTime são opcionais e só são mostrados se a vaga estiver ocupada.
// The index parameter is the parking spot number.
// O parâmetro index é o número da vaga de estacionamento.
// The isOccupied parameter indicates if the spot is occupied or available.
// O parâmetro isOccupied indica se a vaga está ocupada ou disponível.

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
