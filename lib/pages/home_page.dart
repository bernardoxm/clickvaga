import 'package:clickvaga/pages/report_transactions.dart';
import 'package:clickvaga/pages/parking_spots_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 


  final List<Widget> _pages = [
    ParkingSpotsPage(),
    ReportTransactions(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Renderiza a tela atual
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Cor do ícone selecionado
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Pátio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: 'Gestão',
          ),
        
        ],
      ),
    );
  }
}