import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/models/menu_model.dart';
import 'package:s2r_kitchen/page/HomeUser/detail_item/detail_item.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TotalPenjualan extends StatefulWidget {
  const TotalPenjualan({ 
    Key? key, 
    required this.title,
    required this.future
  }) : super(key: key);

  final String? title;
  final Future future;


  @override
  _TotalPenjualanState createState() => _TotalPenjualanState();
}

class _TotalPenjualanState extends State<TotalPenjualan> {

  late ApiService apiService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    apiService = ApiService();
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
        title: Text(
          widget.title!, 
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List menu = snapshot.data as List;
            return menu.isEmpty ? const Center(child: Text('Tidak Ada Data Ditemukan'),) : ListView.builder(
                  shrinkWrap: true,
                  itemCount: menu.length,
                  itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: InkWell(
                      onTap: () { 
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => DetailItem(
                            idMenu: menu[index]['id_menu'].toString(),
                          ))
                        );
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
                            (menu[index]['photo'].isEmpty) ?
                              Image.asset(
                                'assets/images/bgsplash.png',
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                              ApiService.imageMenuUrl + menu[index]['photo'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(menu[index]['menu'], overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 24),),
                                    Text(CurrencyFormat.convertToIdr(int.parse(menu[index]['harga']), 0), style: const TextStyle(fontFamily: 'Satisfy', fontSize: 24, color: Color(0x99FFC107))),
                                    Text('Terjual : ' + menu[index]['terjual'],overflow: TextOverflow.ellipsis,maxLines: 2,style:const TextStyle(fontSize: 24),),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}