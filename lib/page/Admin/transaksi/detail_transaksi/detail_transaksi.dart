import 'dart:convert';
import 'dart:io';

import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/page/HomeUser/detail_item/detail_item.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTransaksi extends StatefulWidget {
  const DetailTransaksi({Key? key, required this.idTransaksi}) : super(key: key);
  final String? idTransaksi;

  @override
  _DetailTransaksiState createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  Map<String, dynamic> transaksi = <String, dynamic>{};
  List<dynamic> item = <dynamic>[];
  bool isLoading = true;
  User? user;
  String pesanChat = "";
  String lItemChat = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchDetail();
    _login();
  }

  _login() async {
    final getUser = await MySharedPref().getModel();
    setState(() {
      user = getUser;
    });
  }

  _fetchDetail() async {
    final data =
        await ApiService().getDetailOrder(idTransaksi: widget.idTransaksi);
    setState(() {
      item = data['data'];
      transaksi = data['transaksi'];
      isLoading = false;

      lItemChat = item.map((e) => e['menu']).toString();
      
      if (transaksi['status'] == "Belum Bayar") {
        pesanChat = "Hallo *${transaksi['nama']}* dengan nomor ${transaksi['no_telp']} Pesanan *$lItemChat* ditanggal ${transaksi['tgl_transaksi'].replaceAll(':','.')} *${transaksi['status']}* , Silahkan melakukan pembayaran dengan total *Rp. ${transaksi['total']}* , Dengan Batas pembayaran *${transaksi['kadaluwarsa']?.replaceAll(':','.')}* ";
      }else{
        pesanChat = "Hallo *${transaksi['nama']}* dengan nomor ${transaksi['no_telp']} Pesanan *$lItemChat* ditanggal ${transaksi['tgl_transaksi'].replaceAll(':','.')} , *${transaksi['status']}*";
      }
    });
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailItem(
                                  idMenu:
                                      item[index]['id_menu'].toString())));
                    },
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            ApiService.imageMenuUrl + item[index]['photo'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    item[index]['menu'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                      CurrencyFormat.convertToIdr(
                                          int.parse(item[index]['harga']), 0),
                                      style: const TextStyle(
                                          fontFamily: 'Satisfy',
                                          fontSize: 24,
                                          color: Color(0x99FFC107))),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'X${item[index]['qty']}',
                                        style:
                                            const TextStyle(fontSize: 24),
                                      ),
                                      Text(
                                          CurrencyFormat.convertToIdr(
                                              int.parse(item[index]['qty']) *
                                                  int.parse(item[index]['harga']),
                                              0),
                                          style: const TextStyle(
                                              fontFamily: 'Satisfy',
                                              fontSize: 24,
                                              color: Color(0x99FFC107))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
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
                            'Tanggal Pesan',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text(':'),
                          Text(transaksi['tgl_transaksi'],
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0x99FFC107))),
                        ]),
                        TableRow(children: [
                          const Text(
                            'Status Pesanan',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text(':'),
                          Text(transaksi['status'],
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0x99FFC107))),
                        ]),
                        TableRow(children: [
                          const Text(
                            'Pemesan',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text(':'),
                          Text(transaksi['nama'],
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0x99FFC107))),
                        ])
                      ],
                    )),
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
                      children: [
                        TableRow(children: [
                          const Text(
                            'Total Pesanan',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text(''),
                          Text(
                              CurrencyFormat.convertToIdr(
                                  int.parse(transaksi['total']), 0),
                              style: const TextStyle(
                                fontFamily: 'Satisfy',
                                fontSize: 24,
                                color: Color(0x99FFC107),
                              )),
                        ]),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          launchWhatsApp(
            phone: transaksi['no_telp'], 
            message: pesanChat
          )
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/icons/icon-whatsapp.gif')
        ),
      ),
      bottomNavigationBar: (transaksi['status'] == 'Belum Bayar') 
        ? buttonKonfirmasi('BAYAR PESANAN', 'Diproses') : (transaksi['status'] == 'Diproses') 
        ? buttonKonfirmasi('PESANAN SIAP', 'Pesanan Sudah Siap') : (transaksi['status'] == 'Pesanan Sudah Siap')  
        ? buttonKonfirmasi('SELESAI', 'Selesai')  : const SizedBox(height: 0,) 
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
                    modalConfirmPesanan(context, status);
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
                  final updateStatus = await ApiService().updateStatusPesanan(
                    status: status, idTransaksi: widget.idTransaksi, petugas:(status == "Diproses")?user!.id_user :null 
                  );
                    
                  Fluttertoast.showToast(msg: updateStatus['message']);
                  if (updateStatus['success']) {
                    // if(transaksi['status'] !='Belum Bayar'){
                      launchWhatsApp(
                        phone: transaksi['no_telp'],
                        message: "Hallo *${transaksi['nama']}* dengan nomor ${transaksi['no_telp']} Pesanan *$lItemChat* ditanggal ${transaksi['tgl_transaksi'].replaceAll(':','.')} , *$status*"
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
}
