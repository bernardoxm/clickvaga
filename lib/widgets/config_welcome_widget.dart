import 'package:flutter/material.dart';


class ConfigWelcomeWidget extends StatefulWidget {
  const ConfigWelcomeWidget({
    super.key,
    required this.spotsController,
  });

  final TextEditingController spotsController;

  @override
  State<ConfigWelcomeWidget> createState() => _ConfigWelcomeWidgetState();
}

class _ConfigWelcomeWidgetState extends State<ConfigWelcomeWidget> {
  @override
  void initState() {
    super.initState();
    // Adiciona um listener para atualizar o estado enquanto o usuário digita
    widget.spotsController.addListener(() {
      if (mounted) {
        setState(() {}); // Atualiza o texto imediatamente ao digitar
      }
    });
  }

  @override
  void dispose() {
    widget.spotsController
        .dispose(); // Libera a memória quando a tela for destruída
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        spacing: 10,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Image(
              image: AssetImage('assets/iconApp.png'),
            ),
          ),
          Text(
            'Bem Vindo ao ClickVaga!',
            textAlign: TextAlign.center,
          ),
          Text(
            'Para começar, informe o número de vagas disponíveis no seu estacionamento: ${widget.spotsController.text.isEmpty ? 0 : widget.spotsController.text} Vagas',
            textAlign: TextAlign.center,
          ),
          TextFormField(
            controller: widget.spotsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Número de vagas"),
          ),
        ],
      ),
    );
  }
}
