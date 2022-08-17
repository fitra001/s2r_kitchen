import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/menu_model.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/page/Admin/master/menu/edit_menu/edit_menu.dart';
import 'package:s2r_kitchen/page/HomeUser/cart_item/cart_item.dart';
import 'package:s2r_kitchen/page/HomeUser/home/home.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'detail_item_c.dart';

class DetailItem extends StatefulWidget {
  const DetailItem({
    Key? key,
    required this.idMenu,
  }) : super(key: key);

  final String? idMenu;

  @override
  _DetailItemState createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  late ApiService apiService;
  final controller = DetailItemC();
  final _qtyController = TextEditingController();
  User? user;
  bool loadingKeranjang = false;
  int jumlahKeranjang = 0;
  bool loadingDelete = false;
  
  @override
  void initState() {
    super.initState();

    user = User();
    apiService = ApiService();
    _qtyController.text = "1";
    _login();
  }

  _login() async {
    final getUser = await MySharedPref().getModel();
    if (getUser != null) {
      _getJumlahKeranjang(getUser.id_user.toString());
      setState(() {
        user = getUser;
      });
    }
  }

  _getJumlahKeranjang(String idUser) async {
    final getJumlahKeranjang = await apiService.getJumlahKeranjang(idUser);
    setState(() {
      jumlahKeranjang = int.parse(getJumlahKeranjang['data']['jumlah'] ?? "0");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder(
          future: apiService.getDetailMenuByIdMenu(widget.idMenu!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              Menu menu = snapshot.data as Menu;
              return Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          icon: const Icon(
                            CupertinoIcons.chevron_left_circle,
                            color: Color(0xFFFFC107),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        expandedHeight: 350.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: const Text(''),
                          background: (menu.photo.isEmpty) ?
                            Image.asset(
                              'assets/images/bgsplash.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                            ApiService.imageMenuUrl + menu.photo,
                            fit: BoxFit.fill,
                          ),
                        ),
                        actions: [
                          (user!.role_id != "3")? const SizedBox():Stack(
                            children: [
                              IconButton(
                                color: Colors.black,
                                icon: const Icon(
                                  CupertinoIcons.cart,
                                  color: Color(0xFFFFC107),
                                ),
                                onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const CartItem())),
                              ),
                              if(jumlahKeranjang > 0) Positioned(
                                top: 2.0,
                                right: 4.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.red
                                  ),
                                  height: 10,
                                  width: 10,
                                )
                              )
                            ]
                          )
                        ],
                      )
                    ];
                  },
                  body: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menu.menu,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                      CurrencyFormat.convertToIdr(
                                          int.parse(menu.harga), 0),
                                      style: const TextStyle(
                                          fontFamily: 'satisfy',
                                          fontSize: 24,
                                          color: Color(0x99FFC107))),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    menu.deskripsi,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text( 
                                    'Tersedia : ' + menu.stok,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: SizedBox(
                  height: 50,
                  child: (user!.role_id == "3") ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xffDD6060)),
                          onPressed: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
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
                                                    TextButton(
                                                        onPressed: () {
                                                          int currentValue =
                                                              int.parse(
                                                                  _qtyController
                                                                      .text);
                                                          setState(() {
                                                            currentValue--;
                                                            _qtyController
                                                                .text = (currentValue >
                                                                        1
                                                                    ? currentValue
                                                                    : 1)
                                                                .toString(); // decrementing value
                                                          });
                                                        },
                                                        child: const Icon(
                                                            CupertinoIcons
                                                                .minus)),
                                                    Expanded(
                                                      child: TextFormField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        controller:
                                                            _qtyController,
                                                        keyboardType: TextInputType.number,
                                                        onChanged: (val){
                                                          if (int.parse(val) >= int.parse(menu.stok)) {
                                                            _qtyController.text = menu.stok.toString();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          int currentValue =
                                                              int.parse(
                                                                  _qtyController
                                                                      .text);
                                                          setState(() {
                                                            currentValue++;
                                                            _qtyController
                                                                .text = (currentValue <
                                                                        int.parse(menu.stok)
                                                                    ? currentValue
                                                                    : menu.stok)
                                                                .toString(); // incrementing value
                                                          });
                                                        },
                                                        child: const Icon(
                                                            CupertinoIcons
                                                                .plus))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              OutlinedButton.icon(
                                                icon: const Icon(
                                                    CupertinoIcons.cart),
                                                onPressed: (loadingKeranjang)? (){}: () async{
                                                  setState((){
                                                    loadingKeranjang = true;
                                                  });
                                                  final addKeranjang = await controller.addKeranjang(
                                                      idUser: user!.id_user,
                                                      idMenu: widget.idMenu,
                                                      qty: _qtyController.text);
                                                  if(addKeranjang){
                                                    Navigator.pop(context);

                                                    setState(() {
                                                      _getJumlahKeranjang(user!.id_user.toString());
                                                            loadingKeranjang =
                                                                false;
                                                          });
                                                  }else {
                                                    setState(() {
                                                            loadingKeranjang =
                                                                false;
                                                          });
                                                  }
                                                },
                                                label: (loadingKeranjang)
                                                    ? const Text(
                                                        '. . . . .')
                                                    : const Text(
                                                    'TAMBAHKAN KE KERANJANG'),
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
                                  });
                                });
                          },
                          child: const Icon(
                            CupertinoIcons.cart,
                            color: Colors.black,
                          )),
                      Expanded(
                        child: TextButton(
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
                                                        TextButton(
                                                            onPressed: () {
                                                              int currentValue =
                                                                  int.parse(
                                                                      _qtyController
                                                                          .text);
                                                              setState(() {
                                                                currentValue--;
                                                                _qtyController
                                                                    .text = (currentValue >
                                                                            1
                                                                        ? currentValue
                                                                        : 1)
                                                                    .toString(); // decrementing value
                                                              });
                                                            },
                                                            child: const Icon(
                                                                CupertinoIcons
                                                                    .minus)),
                                                        Expanded(
                                                          child: TextFormField(
                                                            textAlign:
                                                                TextAlign.center,
                                                            controller:
                                                                _qtyController,
                                                            keyboardType: TextInputType.number,
                                                            onChanged: (val){
                                                              if (int.parse(val) >= int.parse(menu.stok)) {
                                                                _qtyController.text = menu.stok.toString();
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              int currentValue =
                                                                  int.parse(
                                                                      _qtyController
                                                                          .text);
                                                              setState(() {
                                                                currentValue++;
                                                                _qtyController
                                                                    .text = (currentValue <
                                                                            int.parse(menu.stok)
                                                                        ? currentValue
                                                                        : menu.stok)
                                                                    .toString(); // incrementing value
                                                              });
                                                            },
                                                            child: const Icon(
                                                                CupertinoIcons
                                                                    .plus))
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
                                                      modalPesan(context, menu: menu);
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
                            )),
                      ),
                    ],
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
                          modalConfirmDelete(context,menu: menu);
                          
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
                                  (context) => EditMenu(menu : menu)
                                )
                              )
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Color(0xffFFC107)),
                            )),
                      ),
                  
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<dynamic> modalPesan(BuildContext context6,{ Menu? menu }) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              height: 300,
              width: 300,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu!.menu,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Image.asset('assets/images/bgsplash.png', height: 120,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                    CurrencyFormat.convertToIdr(
                                        int.parse(menu.harga), 0),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0x99FFC107))),
                              ],
                            ),
                          ),
                          Text('X${_qtyController.text}',
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0x99FFC107))),
                          Text(
                              CurrencyFormat.convertToIdr(
                                  int.parse(menu.harga) *
                                      int.parse(_qtyController.text),
                                  0),
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0x99FFC107))),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(CupertinoIcons.clear),
                      onPressed: () => Navigator.pop(context),
                      label: const Text('BATAL'),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(24)),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(CupertinoIcons.cart),
                      onPressed: () {
                        modalConfirmPesanan(context, menu: menu);
                      },
                      label: const Text('PESAN'),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(24)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> modalConfirmPesanan(BuildContext context,{Menu? menu}) {
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
                  
                  final order = await apiService.addOrder(
                      idUser: user!.id_user, total: (int.parse(_qtyController.text) * int.parse(menu!.harga)).toString());

                  if (order['success']) {
                    
                      final addDetailOrder = apiService.addDetailOrder(
                          lastId: order['last_id'].toString(),
                          idMenu: menu.id_menu.toString(),
                          harga: (int.parse(_qtyController.text) * int.parse(menu.harga)).toString(),
                          qty: _qtyController.text);
                          
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Home()));

                    Fluttertoast.showToast(msg: order['message']);
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

  Future<dynamic> modalConfirmDelete(BuildContext context, {Menu? menu}) {
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
                  final res = await ApiService().deleteMenu(menu!.id_menu);
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
      }
    );
  }
}
