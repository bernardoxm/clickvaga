import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:flutter/material.dart';

class LicensePlateWidget extends StatelessWidget {
  final String plate;

  const LicensePlateWidget({super.key, required this.plate});

  @override
  Widget build(BuildContext context) {
    DataText dataText = DataText();
    DataColor dataColor = DataColor();
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: dataColor.colorWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dataColor.colorBlack, width: 3),
        boxShadow: [
          BoxShadow(
            color: dataColor.colorBlack26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
 
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: dataColor.colorBlue900,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                   dataText.textBrazil,
                    style: TextStyle(
                      color: dataColor.colorWhite,
                      fontWeight: FontWeight.bold,
                      fontSize:10,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset(
                    'assets/flagbrazil.png',
                    width: 20,
                    height: 12,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
     
          Expanded(
            child: Center(
              child: Text(
                plate,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
