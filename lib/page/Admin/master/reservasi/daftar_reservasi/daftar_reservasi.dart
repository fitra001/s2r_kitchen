import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/menu_model.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/master/reservasi/daftar_reservasi/tambah_reservasi/tambah_reservasi.dart';
import 'package:s2r_kitchen/page/HomeUser/detail_item/detail_item.dart';
import 'package:s2r_kitchen/page/HomeUser/reservasi/detail_paket/detail_paket.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DaftarReservasi extends StatefulWidget {
  const DaftarReservasi({ Key? key }) : super(key: key);

  @override
  State<DaftarReservasi> createState() => _DaftarReservasiState();
}

class _DaftarReservasiState extends State<DaftarReservasi> {
  User? user;
  bool isLoading = true;
  List reservasi = [];
  late ApiService apiService;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService = ApiService();

    _fetchUser();

    // _searchController.addListener(() {
    //   if (_searchController.text.isNotEmpty) {
    //     _searchList(_searchController.text);
    //   } 
    // });
    _fetchReservasi();
  }

  _fetchUser() async {
    final getUser = await MySharedPref().getModel();
    if (getUser != null) {
      user = getUser;
    }
  }

  _fetchReservasi() async{
    final getReservasi = await apiService.getReservasi();

    setState(() {
      reservasi = getReservasi['data']!;
      isLoading = false;
    });

  }

  // _searchList(String text) async {
  //   final getSearch = await apiService.getMenuByNama(text);
  //   if (mounted) {
  //     setState(() {
  //       reservasi = getSearch!;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : isLoading 
      ? const Center(child: CircularProgressIndicator(),) 
      : Column(
        children: [
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   child: TextFormField(
          //     controller: _searchController,
          //     style: const TextStyle(fontFamily: 'sans serif'),
          //     decoration: const InputDecoration(
          //       prefixIcon: Icon(CupertinoIcons.search,
          //           color: Color(0x99FFC107)),
          //       hintText: 'Pencarian',
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Color(0x99FFC107)),
          //           borderRadius:
          //               BorderRadius.all(Radius.circular(20.0))),
          //       border: OutlineInputBorder(
          //           borderSide: BorderSide(color: Color(0x99FFC107)),
          //           borderRadius:
          //               BorderRadius.all(Radius.circular(20.0))),
          //     ),
          //   )
          // ),
          reservasi.isEmpty
          ? const Center(
              child: Text('Menu Tidak Ada'),
            )
          : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: reservasi.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPaket(
                              idReservasi: reservasi[index]
                                  ['id_reservasi']))),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            (reservasi[index]['foto'] == null) ?
                            Image.asset(
                                'assets/images/bgsplash.png',
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )
                            :Image.network(
                              ApiService.imageReservasiUrl +
                                  reservasi[index]['foto'],
                              height: 120,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      reservasi[index]['reservasi'],
                                      style: const TextStyle(
                                          fontSize: 24),
                                    ),
                                    Text(
                                        CurrencyFormat.convertToIdr(int.parse(reservasi[index]['harga']),0),
                                        style: const TextStyle(
                                            fontFamily: 'Satisfy',
                                            fontSize: 24,
                                            color: Color(
                                                0x99FFC107))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5))),
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
                                  top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5))),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const TambahReservasi()))
        },
        child: Icon(CupertinoIcons.plus),
      ),
    );
  }
}