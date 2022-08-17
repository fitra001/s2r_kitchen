import 'package:s2r_kitchen/page/Admin/master/menu/daftar_kategori/daftar_kategori.dart';
import 'package:s2r_kitchen/page/Admin/master/menu/daftar_menu/daftar_menu.dart';
import 'package:s2r_kitchen/page/Admin/master/menu/tambah_menu/tambah_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffFFC107)),
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
                    child: Text('Daftar Menu'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Kategori'),
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
            DaftarKategori()
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(context, 
              MaterialPageRoute(builder: (_) => const TambahMenu())
            )
          },
          child: Icon(CupertinoIcons.plus),
        ),
      ),
    );
  }
}
