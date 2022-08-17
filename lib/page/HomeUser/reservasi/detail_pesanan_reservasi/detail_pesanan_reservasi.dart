import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPesananReservasi extends StatefulWidget {
  const DetailPesananReservasi({Key? key, required this.idTransaksiReservasi}) : super(key: key);
  final String idTransaksiReservasi;

  @override
  _DetailPesananReservasiState createState() => _DetailPesananReservasiState();
}

class _DetailPesananReservasiState extends State<DetailPesananReservasi> {

  bool loading = true;
  Map reservasi = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReservasi();
  }

  fetchReservasi() async {
    final res = await ApiService().getReservasiDetailPesananById(widget.idTransaksiReservasi);
    if (mounted) {
      setState(() {
        reservasi = res['data'];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.chevron_left_circle,
            color: Color(0xFFFFC107),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: (loading) ? const Center(child: CircularProgressIndicator(),) :Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.network(
              ApiService.imageReservasiUrl + reservasi['foto'],
              width: double.infinity,
              height: 250,
              fit: BoxFit.fitWidth,
            ),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservasi['reservasi'],
                      style: const TextStyle( fontSize: 24),
                    ),
                    Text(CurrencyFormat.convertToIdr(
                        int.parse(reservasi['harga']), 0),
                        style: const TextStyle(
                            fontSize: 24,
                            color: Color(0x99FFC107))),
                    const SizedBox(height: 20,),
                    const Text(
                      'Deskripsi',
                      style: TextStyle( fontSize: 24),
                    ),
                    Text(
                      reservasi['deskripsi']
                    ),
                    // ListView.builder(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: 2,
                    //   itemBuilder: (context, index) {
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Image.asset(
                    //             'assets/images/bgsplash.png',
                    //             height: 50,
                    //           ),
                    //           Expanded(
                    //             flex: 1,
                    //             child: Row(
                    //               mainAxisSize: MainAxisSize.max,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceAround,
                    //               children: const [
                    //                 Text(
                    //                   'Nasi Goreng',
                    //                   style: TextStyle( fontSize: 14),
                    //                   textAlign: TextAlign.start,
                    //                 ),
                                    
                    //                 Text(
                    //                   'X1',
                    //                   style: TextStyle(
                    //                       fontSize: 18),
                    //                 ),
                                    
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
            
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Table(
                    border: const TableBorder(
                        horizontalInside:
                            BorderSide(width: 0.5, color: Colors.grey)),
                    children: [
                      TableRow(children: [
                        const Text(
                          'Booking',
                          style: TextStyle( fontSize: 18),
                        ),
                        const Text(':'),
                        Text(reservasi['tgl_reservasi'],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color(0x99FFC107))),
                      ]),
                      TableRow(children: [
                        const Text(
                          'Tanggal Pesan',
                          style: TextStyle( fontSize: 18),
                        ),
                        const Text(':'),
                        Text(reservasi['tgl_transaksi'],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color(0x99FFC107))),
                      ]),
                      TableRow(children: [
                        const Text(
                          'Status Pesanan',
                          style: TextStyle( fontSize: 18),
                        ),
                        const Text(':'),
                        Text(reservasi['status'],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color(0x99FFC107))),
                      ]),
                      TableRow(children: [
                        const Text(
                          'Pemesan',
                          style: TextStyle( fontSize: 18),
                        ),
                        const Text(':'),
                        Text(reservasi['nama'],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color(0x99FFC107))),
                      ])
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: (loading) ? const Center(child: CircularProgressIndicator(),) : Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Table(
              children: [
                TableRow(children: [
                  const Text(
                    'Total Pesanan',
                    style: TextStyle( fontSize: 24),
                  ),
                  const Text(''),
                  Text(CurrencyFormat.convertToIdr(
                        int.parse(reservasi['total']), 0),
                      style: const TextStyle(
                        fontFamily: 'Satisfy',
                        fontSize: 24,
                        color: Color(0x99FFC107),
                      )),
                ]),
              ],
            ),
          )),
    );
    
  }

}
