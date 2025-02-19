import 'package:flutter/material.dart';

class TransactionFiltredButtonWidget extends StatelessWidget {
  final int filterStatus;
  final Function(String) onFilterChange;
  final Function()? onDateFilterSelected; // Add this parameter

  const TransactionFiltredButtonWidget({
    super.key,
    required this.filterStatus,
    required this.onFilterChange,
    this.onDateFilterSelected, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.filter_list),
      onSelected: (String choice) {
        if (choice == "filterByDate" && onDateFilterSelected != null) {
          onDateFilterSelected!(); // Call only if it's not null
        } else {
          onFilterChange(choice);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _menuItem("filterAll", Icons.dynamic_feed_rounded, "Mostrar Todos"),
        _menuItem("filterFinished", Icons.directions_bus_filled_rounded, "Mostrar Apenas Finalizados"),
        _menuItem("filterActive", Icons.directions_bus_outlined, "Mostrar Apenas Ativos"),
        _menuItem("filterByDate", Icons.date_range, "Filtrar por Data"), // Add this option
      ],
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(leading: Icon(icon), title: Text(text)),
    );
  }
}
