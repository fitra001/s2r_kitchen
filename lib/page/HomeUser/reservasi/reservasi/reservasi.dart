import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/page/HomeUser/reservasi/detail_paket/detail_paket.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/material.dart';

class Reservasi extends StatefulWidget {
  const Reservasi({ Key? key }) : super(key: key);

  @override
  State<Reservasi> createState() => _PesananSayaState();
}

class _PesananSayaState extends State<Reservasi> {
  bool loading = true;
  List reservasi = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReservasi();
  }

  fetchReservasi() async {
    final res = await ApiService().getReservasi();
    if (res['success']) {
      setState(() {
        reservasi = res['data'];
        loading = false;
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return (loading) ? const Center(child: CircularProgressIndicator(),) : Container(
      margin: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: reservasi.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPaket(idReservasi : reservasi[index]['id_reservasi']))),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (reservasi[index]['foto'] == null) ?
                      Image.asset(
                          'assets/images/bgsplash.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        )
                      :Image.network(
                        ApiService.imageReservasiUrl + reservasi[index]['foto'],
                        height: 120,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                reservasi[index]['reservasi'],
                                style: const TextStyle(fontSize: 24),
                              ),
                              Text(CurrencyFormat.convertToIdr(
                                              int.parse(reservasi[index]['harga']), 0),
                                  style: const TextStyle(
                                      fontFamily: 'Satisfy',
                                      fontSize: 24,
                                      color: Color(0x99FFC107))),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      reservasi[index]['deskripsi'],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}