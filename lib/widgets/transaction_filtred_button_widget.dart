import 'package:flutter/material.dart';

class TransactionFiltredButtonWidget extends StatelessWidget {
  final int filterStatus;
  final Function(String) onFilterChange;
  final Function()? onDateFilterSelected;

  const TransactionFiltredButtonWidget({
    super.key,
    required this.filterStatus,
    required this.onFilterChange,
    this.onDateFilterSelected, 
  });

  // Add the new option to the PopupMenuButton widget
  // and call the onDateFilterSelected function when it's selected 
  //Adiciona a nova opção ao widget PopupMenuButton e chama a função 
  //onDateFilterSelected quando ela é selecionada

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.filter_list),
      onSelected: (String choice) {
        if (choice == "filterByDate" && onDateFilterSelected != null) {
          onDateFilterSelected!();
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
