import 'package:s2r_kitchen/page/HomeUser/home_page/home_page.dart';
import 'package:s2r_kitchen/page/HomeUser/orders/orders.dart';
import 'package:s2r_kitchen/page/HomeUser/profil/profil.dart';
import 'package:s2r_kitchen/page/HomeUser/reservasi/reservasi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedNavbar = 0;
  final List _children = [
    const HomePage(),
    const ReservasiHome(),
    const Orders(),
    const Profil(),
  ];

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _children[_selectedNavbar],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xffFFC107),
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: _changeSelectedNavBar,
        currentIndex: _selectedNavbar,
        items: const [
          BottomNavigationBarItem(
            label: 'Beranda',
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Reservasi',
            icon: Icon(CupertinoIcons.bookmark),
          ),
          BottomNavigationBarItem(
            label: 'Pesanan Saya',
            icon: Icon(CupertinoIcons.list_bullet),
          ),
          BottomNavigationBarItem(
            label: 'Profil',
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),
    );
  }
}