import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class FindWidget extends StatefulWidget {
  final int totalSpots;
  final int spotsOccupied;
  final Function(String) onSearch;

  const FindWidget({
    Key? key,
    required this.totalSpots,
    required this.spotsOccupied,
    required this.onSearch,
  }) : super(key: key);



  @override
  State<FindWidget> createState() => _FindWidgetState();
}






class _FindWidgetState extends State<FindWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Color.fromRGBO(69, 77, 102, 1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Disponíveis: ${widget.totalSpots - widget.spotsOccupied}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                'Ocupadas: ${widget.spotsOccupied}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextField(
           
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: "Pesquisar Placa",
                hintText: "Digite a placa",
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ), inputFormatters: [
                  PlacaVeiculoInputFormatter(),
                ],
              onChanged:  widget.onSearch,
            ),
          ),
        ],
      ),
    );
  }
}
