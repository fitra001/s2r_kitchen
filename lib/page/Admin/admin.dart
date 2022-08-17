import 'package:s2r_kitchen/page/Admin/dashboard/dashboard.dart';
import 'package:s2r_kitchen/page/Admin/master/master.dart';
import 'package:s2r_kitchen/page/Admin/profil_admin/profil_admin.dart';
import 'package:s2r_kitchen/page/Admin/transaksi/transaksi.dart';
import 'package:s2r_kitchen/page/Admin/transaksi_reservasi/transaksi_reservasi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({ Key? key }) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int _selectedNavbar = 0;
  final List _children = [
    const Dashboard(),
    const Transaksi(),
    const TransaksiReservasi(),
    const Master(),
    const ProfilAdmin(),
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
            label: 'Dashboard',
            icon: Icon(CupertinoIcons.speedometer),
          ),
          BottomNavigationBarItem(
            label: 'Transaksi',
            icon: Icon(CupertinoIcons.bookmark),
          ),
          BottomNavigationBarItem(
            label: 'Reservasi',
            icon: Icon(CupertinoIcons.list_bullet),
          ),
          BottomNavigationBarItem(
            label: 'Master',
            icon: Icon(CupertinoIcons.square_list),
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