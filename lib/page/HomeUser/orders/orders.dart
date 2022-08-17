import 'package:s2r_kitchen/page/HomeUser/orders/pesanan/pesanan.dart';
import 'package:s2r_kitchen/page/HomeUser/orders/riwayat/riwayat.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({ Key? key }) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
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
            // border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
          ),
          child: const TabBarView(
            children: [
              PesananSaya(),
              RiwayatPesanan(),
            ]
          ),
        ),
      ),
    );
  }
}
