// ignore: file_names
import 'package:clickvagas/pages/report_transactions.dart';
import 'package:clickvagas/pages/parking_spots_page.dart';
import 'package:flutter/material.dart';

class NaviPage extends StatefulWidget {
  const NaviPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NaviPageState createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage> {
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
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color.fromRGBO(69, 77, 102, 1),
        selectedItemColor:  Color.fromRGBO(68, 194, 253,1), 
        unselectedItemColor: Color.fromRGBO(232, 232, 232, 1),
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