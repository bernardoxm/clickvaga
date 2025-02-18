import 'package:flutter/material.dart';

class TransactionFiltredButtonWidget extends StatelessWidget {
  final int filterStatus;
  final Function() onFilterChange;
  const TransactionFiltredButtonWidget(
      {super.key, required this.filterStatus, required this.onFilterChange});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.filter_list),
      onSelected: (String choice) {
        onFilterChange();
      },
     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "filter",
          child: ListTile(
            leading: Icon(Icons.filter_list),
            title: Text(filterStatus == 0
                ? "Mostrar Apenas Ativos"
                : filterStatus == 1
                    ? "Mostrar Apenas Finalizados"
                    : "Mostrar Todos"),)
        ),
      ],
    );
  }
}
