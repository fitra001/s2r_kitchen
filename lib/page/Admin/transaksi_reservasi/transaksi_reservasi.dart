import 'package:s2r_kitchen/page/Admin/transaksi_reservasi/belum_lunas/belum_lunas.dart';
import 'package:s2r_kitchen/page/Admin/transaksi_reservasi/lunas/lunas.dart';
import 'package:s2r_kitchen/page/Admin/transaksi_reservasi/pesanan_reservasi/pesanan_reservasi.dart';
import 'package:s2r_kitchen/page/Admin/transaksi_reservasi/selesai_reservasi/selesai_reservasi.dart';
import 'package:flutter/material.dart';

class TransaksiReservasi extends StatefulWidget {
  const TransaksiReservasi({Key? key}) : super(key: key);

  @override
  _TransaksiReservasiState createState() => _TransaksiReservasiState();
}

class _TransaksiReservasiState extends State<TransaksiReservasi> {
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
                    child: Text('Belum Lunas'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lunas'),
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
              // border: Border(top: BTransaksi_reservasiide(color: Colors.grey, width: 0.5))
              ),
          child: const TabBarView(children: [
            PesananReservasi(),
            BelumLunas(),
            Lunas(),
            SelesaiReservasi(),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
          ]),
        ),
      ),
    );
  }
}
