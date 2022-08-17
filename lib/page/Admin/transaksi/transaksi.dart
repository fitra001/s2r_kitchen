import 'package:s2r_kitchen/page/Admin/transaksi/pesanan/pesanan.dart';
import 'package:s2r_kitchen/page/Admin/transaksi/pesanan_proses/pesanan_proses.dart';
import 'package:s2r_kitchen/page/Admin/transaksi/pesanan_siap/pesanan_siap.dart';
import 'package:s2r_kitchen/page/Admin/transaksi/selesai/selesai.dart';
import 'package:flutter/material.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({Key? key}) : super(key: key);

  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
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
                    child: Text('Pesanan'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Diproses'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Pesanan Siap'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Selesai'),
                  ),
                ]),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              // border: Border(top: BTransaksiide(color: Colors.grey, width: 0.5))
              ),
          child: const TabBarView(children: [
            Pesanan(),
            PesananProses(),
            PesananSiap(),
            PesananSelesai(),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
          ]),
        ),
      ),
    );
  }
}
