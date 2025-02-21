
import 'package:clickvagas/pages/hist_spot_page.dart';
import 'package:clickvagas/pages/parking_spots_page.dart';
import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:flutter/material.dart';

class NaviPage extends StatefulWidget {
  const NaviPage({super.key});

  @override

  _NaviPageState createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage> {
  DataColor dataColors = DataColor();
  DataText dataText = DataText();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ParkingSpotsPage(),
    HistSpotPage(),
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

        backgroundColor: dataColors.colorBlueGrey,
        selectedItemColor: dataColors.colorRaroBlue,
        unselectedItemColor: dataColors.colorRaroBlueDark,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_parking),
            label: dataText.textPatio,
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: dataText.textManagement,
          ),
        ],
      ),
    );
  }
}
