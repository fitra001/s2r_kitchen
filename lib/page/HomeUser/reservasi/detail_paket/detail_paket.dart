import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/page/Admin/master/reservasi/edit_reservasi/edit_reservasi.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailPaket extends StatefulWidget {
  const DetailPaket({Key? key, this.idReservasi}) : super(key: key);
  final String? idReservasi;

  @override
  _DetailPaketState createState() => _DetailPaketState();
}

class _DetailPaketState extends State<DetailPaket> {
  DateTime? _dateTime;
  bool loading = true;
  bool loadingDelete = false;
  bool loadingListPesanan = true;
  Map reservasi = {};
  List listPesanan = [];

  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _login();
    fetchReservasi();
    fetchListPesanan();
  }

  _login() async {
    final getUser = await MySharedPref().getModel();
    if (getUser != null) {
      setState(() {
        user = getUser;
      });
    }
  }

  fetchListPesanan() async {
    final res = await ApiService().getListPesananReservasiById(widget.idReservasi!);
    if (mounted) {
      setState(() {
        listPesanan = res['data'];
        loadingListPesanan = false;

      });
    }
  }

  fetchReservasi() async {
    final res = await ApiService().getReservasiById(widget.idReservasi!);
    if (res['success']) {
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
          'Detail Paket',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: (loading) ? const Center(child: CircularProgressIndicator(),) : Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            (reservasi['foto'] == null)
            ? Image.asset(
                'assets/images/bgsplash.png',
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              )
            : Image.network(
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
                    Text(CurrencyFormat.convertToIdr(int.parse(reservasi['harga']), 0),
                      style: const TextStyle(
                          fontFamily: 'Satisfy',
                          fontSize: 24,
                          color: Color(0x99FFC107))),
                    const SizedBox(height: 20,),
                    const Text(
                      'Deskripsi',
                      style: TextStyle( fontSize: 24),
                    ),
                    const SizedBox(height: 20,),
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
              child: (loading) ? const Center(child: SizedBox(),) : Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pesanan', style: TextStyle(fontSize: 24),),
                    const SizedBox(height: 16,),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listPesanan.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(listPesanan[index]['tgl_reservasi'],style: const TextStyle(fontSize:18,)),
                            Text(listPesanan[index]['nama'], style: const TextStyle(fontSize:18,)),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16,)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: (user?.role_id == "3") ? TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xff404040),
            ),
            onPressed: () {
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return Wrap(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(24),
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(
                                            horizontal: 24),
                                    width: MediaQuery.of(context)
                                            .size
                                            .width *
                                        0.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                showDatePicker(
                                                  context: context, 
                                                  initialDate: DateTime.now(), 
                                                  firstDate: DateTime(2022), 
                                                  lastDate: DateTime(2050),
                                                  // initialEntryMode: DatePickerEntryMode.input,
                                                ).then((date) {
                                                  setState((){
                                                    _dateTime = date;
                                                  });
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: const BorderRadius.all(Radius.circular(15.0))
                                                ),
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _dateTime == null ? 'Pilih Tanggal' : '${_dateTime?.toLocal()}'.split(' ')[0],
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  OutlinedButton.icon(
                                    icon: const Icon(
                                        CupertinoIcons.cart),
                                    onPressed: () {
                                      (_dateTime != null ) ? modalConfirmPesanan(context) : null;
                                    },
                                    label: const Text(
                                        'PESAN SEKARANG'),
                                    style: OutlinedButton.styleFrom(
                                        padding:
                                            const EdgeInsets.all(
                                                24)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    );
                  });
            },
            child: const Text(
              'PESAN SEKARANG',
              style: TextStyle(color: Color(0xffFFC107)),
            )
          )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffDD6060)),
                  onPressed: () async {
                    modalConfirmDelete(context, reservasi: reservasi);
                    
                  },
                  child: loadingDelete ? Text('. . .') : const Icon(
                    CupertinoIcons.trash,
                    color: Colors.black,
                  )),
                Expanded(
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff404040),
                      ),
                      onPressed: () => {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: 
                            (context) => EditReservasi(reservasi : reservasi)
                          )
                        )
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Color(0xffFFC107)),
                      )),
                ),
            
              ],
            )
            ,
      )
    );
    
  }

  Future<dynamic> modalConfirmPesanan(BuildContext context) {
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
                  final res = await ApiService().addOrderReservasi(idReservasi: widget.idReservasi, idUser: user?.id_user, total: reservasi['harga'], tglReservasi: '${_dateTime?.toLocal()}'.split(' ')[0]);
                  Fluttertoast.showToast(msg: res['message']);
                  if (res['success']) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                label: const Text('PESAN'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
            ],
          );
        });
  }

  Future<dynamic> modalConfirmDelete(BuildContext context, {dynamic reservasi}) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Konfirmasi Hapus',
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
                  setState(() {
                    loadingDelete = true;
                  });
                  final res = await ApiService().deleteReservasi(reservasi['id_reservasi']);
                  if (res['success']) {
                    setState(() {
                      loadingDelete = false;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Admin()));
                  }
                },
                label: const Text('Hapus'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
            ],
          );
        });
  }
}
