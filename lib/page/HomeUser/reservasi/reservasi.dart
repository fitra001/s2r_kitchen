
import 'package:s2r_kitchen/page/HomeUser/reservasi/pesanan/pesanan_reservasi.dart';
import 'package:s2r_kitchen/page/HomeUser/reservasi/reservasi/reservasi.dart';
import 'package:s2r_kitchen/page/HomeUser/reservasi/riwayat/riwayat_reservasi.dart';
import 'package:flutter/material.dart';

class ReservasiHome extends StatefulWidget {
  const ReservasiHome({ Key? key }) : super(key: key);

  @override
  _ReservasiHomeState createState() => _ReservasiHomeState();
}

class _ReservasiHomeState extends State<ReservasiHome> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffFFC107)
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: const TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white
                ),
                tabs: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Reservasi'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Pesanan Saya'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Riwayat Pesanan'),
                  ),
                ]
              ),
            ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            // border: Border(top: BReservasiHomeide(color: Colors.grey, width: 0.5))
          ),
          child: const TabBarView(
            children: [
              Reservasi(),
              PesananReservasiSaya(),
              RiwayatReservasi()
            ]
          ),
        ),
      ),
    );
  }
}
