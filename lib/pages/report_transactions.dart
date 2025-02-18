import 'package:flutter/material.dart';

class ReportTransactions extends StatelessWidget {
  const ReportTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
        title: Text("Gestão"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (String choice) {
              if (choice == "add") {
               
              } else if (choice == "remove") {
               
              }else if (choice == "filtro") {
               
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: "add", child: ListTile(leading: Icon(Icons.add), title: Text("Adicionar Vaga"))),
              PopupMenuItem<String>(value: "remove", child: ListTile(leading: Icon(Icons.remove), title: Text("Remover Última Vaga"))),
               PopupMenuItem<String>(value: "filtro", child: ListTile(leading: Icon(Icons.filter_1_sharp), title: Text("Visualizar"))),
            ],
          ),
        ],
      ),);
  }
}