import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/keranjang_model.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/HomeUser/detail_item/detail_item.dart';
import 'package:s2r_kitchen/page/HomeUser/home/home.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartItem extends StatefulWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late ApiService apiService;
  late List<Keranjang?> listKeranjang = [];
  bool isLoading = true;
  final List<TextEditingController> _qtyControllerList = [];
  late int total;
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService = ApiService();
    _fetchKeranjang();
  }

  _fetchKeranjang() async {
    total = 0;
    final getUser = await MySharedPref().getModel();
    final getKeranjang =
        await apiService.getKeranjang(getUser!.id_user.toString());
        
    if (getKeranjang != null) {
      for (var item in getKeranjang) {
        total += int.parse(item.harga) * int.parse(item.qty);
      }
      setState(() {
        listKeranjang = getKeranjang;
        total = total;
        user = getUser;
        isLoading = false;
      });
    }else{
      setState(() {
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
            'Keranjang',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: isLoading ? loading() : item(),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: isLoading
                      ? loading()
                      : Text(
                          CurrencyFormat.convertToIdr(total, 0),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff404040)
                  ),
                  child: (listKeranjang.isNotEmpty) ? TextButton(
                    onPressed: () {
                      modalPesan(context);
                    },
                    child: const Text(
                      'PESAN',
                      style: TextStyle(color: Color(0xffFFC107)),
                    )
                  ) : const Center(
                    child: Text('Keranjang Kosong',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xffFFC107)
                        ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      );
  }

  Future<dynamic> modalPesan(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                itemCount: listKeranjang.length,
                itemBuilder: (context, index) {
                  return Card(
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
                            listKeranjang[index]!.menu,
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
                                            int.parse(listKeranjang[index]!.harga), 0),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0x99FFC107))),
                                  ],
                                ),
                              ),
                              Text('X${listKeranjang[index]!.qty}',
                                  style: const TextStyle(
                                      fontSize: 18, color: Color(0x99FFC107))),
                              Text(
                                  CurrencyFormat.convertToIdr(
                                      int.parse(listKeranjang[index]!.harga) *
                                          int.parse(listKeranjang[index]!.qty),
                                      0),
                                  style: const TextStyle(
                                      fontSize: 18, color: Color(0x99FFC107))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                      style:
                          OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(CupertinoIcons.cart),
                      onPressed: () {
                        modalConfirmPesanan(context);
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
                  final order = await apiService.addOrder(
                      idUser: user.id_user, total: total.toString());

                  if (order['success']) {
                    for (var menu in listKeranjang) {
                      apiService.addDetailOrder(
                          lastId: order['last_id'].toString(),
                          idMenu: menu!.id_menu,
                          harga: (int.parse(menu.qty) * int.parse(menu.harga)).toString(),
                          qty: menu.qty);
                    }
                    apiService.deleteKeranjangByUser(idUser: user.id_user);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Home())
                      );
                    
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

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget item() {
    return listKeranjang.isEmpty
      ? const Center(
          child: Text('Keranjang Kosong'),
        )
      : ListView.builder(
      itemCount: listKeranjang.length,
      itemBuilder: (context, index) {
        _qtyControllerList.add(TextEditingController());
        _qtyControllerList[index].text = listKeranjang[index]!.qty.toString();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Slidable(
            endActionPane: ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                backgroundColor: Colors.red,
                onPressed: (_) async {
                  final deleteKeranjang = await ApiService().deleteKeranjang(
                      idUser: user.id_user,
                      idMenu: listKeranjang[index]!.id_menu);
                  if (deleteKeranjang['success']) {
                    setState(() {
                      listKeranjang = [];
                      _fetchKeranjang();
                    });
                  }
                },
                icon: CupertinoIcons.delete,
              ),
            ]),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailItem(
                              idMenu: listKeranjang[index]!.id_menu.toString(),
                            )));
              },
              child: SizedBox(
                height: 120,
                // width: 80,
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
                        ApiService.imageMenuUrl + listKeranjang[index]!.photo,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                listKeranjang[index]!.menu,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(fontSize: 24),
                              ),
                              Text(
                                  CurrencyFormat.convertToIdr(
                                      int.parse(listKeranjang[index]!.harga), 0),
                                  style: const TextStyle(
                                      fontSize: 24, color: Color(0x99FFC107))),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          int currentValue = int.parse(
                                              _qtyControllerList[index].text);
                                          currentValue--;
                                          if (currentValue >= 1) {
                                            final updateQty = await ApiService()
                                                .updateQtyKeranjang(
                                                    idMenu:
                                                        listKeranjang[index]!
                                                            .id_menu,
                                                    idUser: user.id_user,
                                                    qty: currentValue.toString());
                                            if (updateQty['success']) {
                                              setState(() {
                                                _fetchKeranjang();
                                                _qtyControllerList[index].text =
                                                    currentValue.toString();
                                              });
                                            }
                                          }
                                        },
                                        child:
                                            const Icon(CupertinoIcons.minus)),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        controller: _qtyControllerList[index],
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          int currentValue = int.parse(
                                              _qtyControllerList[index].text);
                                          currentValue++;
                                          if (currentValue <=
                                              int.parse(listKeranjang[index]!.stok)) {
                                            final updateQty = await ApiService()
                                                .updateQtyKeranjang(
                                                    idMenu:
                                                        listKeranjang[index]!
                                                            .id_menu,
                                                    idUser: user.id_user,
                                                    qty: currentValue.toString());
                                            if (updateQty['success']) {
                                              setState(() {
                                                _fetchKeranjang();
                                                _qtyControllerList[index].text =
                                                    currentValue.toString();
                                              });
                                            }
                                          }
                                        },
                                        child: const Icon(CupertinoIcons.plus))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4,)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
