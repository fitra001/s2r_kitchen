import 'dart:io';

import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTransaksiReservasi extends StatefulWidget {
  const DetailTransaksiReservasi({Key? key, required this.idTransaksi}) : super(key: key);
  final String? idTransaksi;

  @override
  _DetailTransaksiState createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksiReservasi> {
  Map<String, dynamic> reservasi = <String, dynamic>{};
  List<dynamic> item = <dynamic>[];
  bool isLoading = true;
  User? user;
  TextEditingController _totalBayarController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _fetchDetail();
    _login();
    _fetchReservasiDetail();
  }

  _login() async {
    final getUser = await MySharedPref().getModel();
    setState(() {
      user = getUser;
    });
  }

  // _fetchDetail() async {
  //   final data =
  //       await ApiService().getDetailOrder(idTransaksi: widget.idTransaksi);
  //   setState(() {
  //     item = data['data'];
  //     transaksi = data['transaksi'];
  //     isLoading = false;
  //   });
  // }

  _fetchReservasiDetail() async {
    final res = await ApiService().getReservasiDetailPesananById(widget.idTransaksi!);
    if (mounted) {
      setState(() {
        reservasi = res['data'];
        isLoading = false;
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
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
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
                          'Bayar',
                          style: TextStyle(fontSize: 18),
                        ),
                        const Text(':'),
                        Text(reservasi['bayar'],
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
                      ]),
                      
                    ],
                  )),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          launchWhatsApp(
            phone: reservasi['no_telp'], 
            message: "Total Pesanan ${reservasi['total']}, ${reservasi['status']}"
          )
        },
        child:  ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/icons/icon-whatsapp.gif')
        ),
      ),
      bottomNavigationBar: (reservasi['status'] == 'Belum Bayar') ? buttonKonfirmasi('BAYAR PESANAN', 'bayar') 
        : (reservasi['status'] == 'Belum Lunas') ? buttonKonfirmasi('LUNAS', 'Lunas') 
        : (reservasi['status'] == 'Lunas') ? buttonKonfirmasi('SELESAI', 'Selesai')  
        : const SizedBox(height: 0,) 
    );
  }

  void launchWhatsApp({
    @required String? phone,
    @required String? message,
  }) async {
    String url() {
      // if (kIsWeb) {
      //   return "https://api.whatsapp.com/send?phone=$phone&message=${Uri.parse(message!)}"; // new line
      // }else{
        if (Platform.isIOS) {
          // add the [https]
          return "https://wa.me/$phone/?text=${Uri.parse(message!)}"; // new line
        } else {
          // add the [https]
          return "whatsapp://send?phone=$phone&text=${Uri.parse(message!)}"; 
          // return "https://api.whatsapp.com/send?phone=$phone&message=${Uri.parse(message!)}"; // new line
        }
      // }
    }

    if (await canLaunchUrl(Uri.parse(url()))) {
      await launchUrl(Uri.parse(url()));
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Widget buttonKonfirmasi(String title, status) {
    return SizedBox(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Color(0xff404040)),
                child: TextButton(
                  onPressed: () {
                    (status == 'bayar') ? modalConfirmBayar(context) 
                    : modalConfirmPesanan(context, status);
                  },
                  child: Text(
                    title,
                    style: const TextStyle(color: Color(0xffFFC107)),
                  )
                )
              ),
            ),
          ],
        ),
      );
  }

  Future<dynamic> modalConfirmPesanan(BuildContext context, status) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Konfirmasi Pesanan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.clear),
                onPressed: () => Navigator.pop(context),
                label: const Text('BATAL'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.cart),
                onPressed: () async {
                  final updateStatus = await ApiService().updateStatusPesananReservasi(
                    status: status, idTransaksi: widget.idTransaksi, total: reservasi['total'] 
                  );
                    
                  Fluttertoast.showToast(msg: updateStatus['message']);
                  if (updateStatus['success']) {
                    // if(transaksi['status'] !='Belum Bayar'){
                      launchWhatsApp(
                        phone: reservasi['no_telp'],
                        message: "Total Pesanan ${reservasi['total']}, ${reservasi['status']}"
                      );
                    // }
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (_) => const Admin())
                    );
                  }
                  
                },
                label: const Text('Konfirmasi'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
            ],
          );
        });
  }

  Future<dynamic> modalConfirmBayar(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Konfirmasi Pesanan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _totalBayarController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    prefixIcon:Padding(
                      padding: EdgeInsetsDirectional.only(start: 12.0),
                      child: Text('Rp.'),
                    ),
                    hintText: 'Nominal',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                  ),
                )
              ),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.clear),
                onPressed: () => Navigator.pop(context),
                label: const Text('BATAL'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.cart),
                onPressed: () async {
                  final bayar = await ApiService().bayarReservasiPesanan(idTransaksi: widget.idTransaksi, total: reservasi['total'], bayar: _totalBayarController.text, petugas: user?.id_user);
                  // final updateStatus = await ApiService().updateStatusPesanan(
                //       status: status,
                //       idTransaksi: widget.idTransaksi,
                //       petugas: (status == "Diproses") ? user!.id_user : null);

                  Fluttertoast.showToast(msg: bayar['message']);
                  if (bayar['success']) {
                    // if(transaksi['status'] !='Belum Bayar'){
                    launchWhatsApp(
                        phone: reservasi['no_telp'],
                        message:
                            'Total Pesanan ${reservasi['total']}, telah dibayar');
                    // }
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Admin()));
                  }
                },
                label: const Text('Konfirmasi'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
            ],
          );
        });
  }
}
