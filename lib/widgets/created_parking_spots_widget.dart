import 'package:clickvagas/repository/data_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatedParkingSpotsWidget extends StatefulWidget {
  final TextEditingController spotsController;
  const CreatedParkingSpotsWidget({super.key, required this.spotsController});

  @override
  State<CreatedParkingSpotsWidget> createState() => _CreatedParkingSpotsWidgetState();
}

class _CreatedParkingSpotsWidgetState extends State<CreatedParkingSpotsWidget> {
DataText dataText = DataText();


  @override
  void initState() {
    super.initState();
    widget.spotsController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    widget.spotsController.removeListener(() {}); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset('assets/iconApp.png'),
          ),
          Text(
            dataText.textAppWelcomeTitle,
            textAlign: TextAlign.center,
          ),
          Text(
            '${dataText.textToStart} ${widget.spotsController.text.isEmpty ? 0 : widget.spotsController.text} ${dataText.textSpots}',
            textAlign: TextAlign.center,
          ),
          TextFormField(
            controller: widget.spotsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: dataText.textNumofSpots),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
          ),
        ],
      ),
    );
  }
}
