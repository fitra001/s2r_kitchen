import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/kategori_model.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/HomeUser/list_item/list_item.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

class DaftarKategori extends StatefulWidget {
  const DaftarKategori({ Key? key }) : super(key: key);

  @override
  State<DaftarKategori> createState() => _DaftarKategoriState();
}

class _DaftarKategoriState extends State<DaftarKategori> {
  User? user;
  bool isLoading = true;
  List<Kategori> kategori = [];
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
    _fetchKategori();
  }

  _fetchUser() async {
    final getUser = await MySharedPref().getModel();
    if (getUser != null) {
      user = getUser;
    }
  }

  _fetchKategori() async{
    final getKategori = await apiService.getAllKategori();

    if (mounted) {
      setState(() {
        kategori = getKategori!;
        isLoading = false;
      });
    }

  }

  // _searchList(String text) async {
  //   final getSearch = await apiService.getMenuByNama(text);
  //   if (mounted) {
  //     setState(() {
  //       // kategori = getSearch!;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading 
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
        kategori.isEmpty
        ? const Center(
            child: Text('Kategori Tidak Ada'),
          )
        : Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: kategori.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Slidable(
                  // endActionPane: user!.role_id != "1" ? null :ActionPane(motion: const ScrollMotion(), children: [
                  //   SlidableAction(
                  //     backgroundColor: Colors.red,
                  //     onPressed: (_) async {
                  //       // final deleteKeranjang = await ApiService().deleteKeranjang(
                  //       //     idUser: user.id_user,
                  //       //     idMenu: listKeranjang[index]!.id_menu);
                  //       // if (deleteKeranjang['success']) {
                  //       //   setState(() {
                  //       //     _fetchKeranjang();
                  //       //   });
                  //       // }
                  //     },
                  //     icon: CupertinoIcons.delete,
                  //   ),
                  // ]),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListItem(
                                title: kategori[index].kategori,
                                future: apiService
                                    .getMenuByIdKategori(
                                        '${kategori[index].id_kategori}'))));
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
                          SvgPicture.network(
                            ApiService.imageKategoriUrl + kategori[index].icon,
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
                                    kategori[index].kategori,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  // Text(
                                  //     CurrencyFormat.convertToIdr(menu[index].harga, 0),
                                  //     style: const TextStyle(
                                  //         fontFamily: 'Satisfy',
                                  //         fontSize: 24,
                                  //         color: Color(0x99FFC107))),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}