import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tpm_tugas3/pages/loginPage.dart';
import 'package:tpm_tugas3/pages/subPages/groupPage.dart';
import 'package:tpm_tugas3/pages/subPages/helpPage.dart';
import 'package:tpm_tugas3/pages/subPages/menuPage.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _pages = [
    MenuPage(),
    GroupPage(),
    HelpPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas TPM 3'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.cyan,
        backgroundColor: Colors.transparent,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.group,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.help,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}




