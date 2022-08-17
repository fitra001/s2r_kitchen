import 'package:s2r_kitchen/page/Admin/master/menu/daftar_kategori/daftar_kategori.dart';
import 'package:s2r_kitchen/page/Admin/master/menu/daftar_menu/daftar_menu.dart';
import 'package:s2r_kitchen/page/Admin/master/menu/menu.dart';
import 'package:s2r_kitchen/page/Admin/master/reservasi/daftar_reservasi/daftar_reservasi.dart';
import 'package:flutter/material.dart';

class Master extends StatefulWidget {
  const Master({Key? key}) : super(key: key);

  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Container(
            // margin: const EdgeInsets.symmetric(vertical:8.0),
            decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 7, 85, 255)),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: const TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                tabs: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Menu'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Kategori'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Reservasi'),
                  ),
                ]),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              // border: Border(top: BTransaksiide(color: Colors.grey, width: 0.5))
              ),
          child: const TabBarView(children: [
            DaftarMenu(),
            DaftarKategori(),
            // Menu(),
            DaftarReservasi()
          ]),
        ),
        
      ),
    );
  }
}
