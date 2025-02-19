import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatedParkingSpotsWidget extends StatefulWidget {
  const CreatedParkingSpotsWidget({
    super.key,
    required this.spotsController,
  });

  final TextEditingController spotsController;

  @override
  State<CreatedParkingSpotsWidget> createState() => _CreatedParkingSpotsWidgetState();
}

class _CreatedParkingSpotsWidgetState extends State<CreatedParkingSpotsWidget> {
  @override
  void initState() {
    super.initState();
   
    widget.spotsController.addListener(() {
      if (mounted) {
        setState(() {}); 
      }
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
            child: Image(
              image: AssetImage('assets/iconApp.png'),
            ),
          ),
          Text(
            'Bem Vindo ao ClickVagas!',
            textAlign: TextAlign.center,
          ),
          Text(
            'Para começar, informe o número de vagas disponíveis no seu estacionamento: '
            '${widget.spotsController.text.isEmpty ? 0 : widget.spotsController.text} Vagas',
            textAlign: TextAlign.center,
          ),
          TextFormField(
            controller: widget.spotsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Número de vagas"),
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
