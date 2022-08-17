import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/HomeUser/detail_pesanan/detail_pesanan.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/material.dart';

class RiwayatPesanan extends StatefulWidget {
  const RiwayatPesanan({Key? key}) : super(key: key);

  @override
  State<RiwayatPesanan> createState() => _RiwayatPesananState();
}

class _RiwayatPesananState extends State<RiwayatPesanan> {
  bool isLoading = true;
  List<dynamic> data = <dynamic>[];
  List detailPesanan = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchOrder();
  }

  _fetchOrder() async {
    User? user = await MySharedPref().getModel();
    final order =
        await ApiService().getRiwayatOrder(user!.id_user.toString());
    var riwayatOrder = order['data'];

    List detail = [];
    for (var item in riwayatOrder) {
      final detailOrder = await _getDetail(item['id']);
      detail.add(detailOrder);
    }
    if(mounted){
      setState(() {
        data = riwayatOrder;
        detailPesanan = detail;
        isLoading = false;
      });
    }
  }

  Future<dynamic> _getDetail(String idTransaksi) async {
    final data = await ApiService().getDetailOrder(idTransaksi: idTransaksi);
    return data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: data.isEmpty
                ? const Center(
                    child: Text('Data Kosong'),
                  )
                : ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPesanan(idTransaksi: data[index]['id'] ))),
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
                              Image.network(
                                ApiService.imageMenuUrl +
                                  detailPesanan[index][0]['photo'],
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
                                        detailPesanan[index][0]['menu'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      Text(CurrencyFormat.convertToIdr(int.parse(detailPesanan[index][0]['harga']), 0),
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
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Lihat Selengkapnya',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              data[index]['status'],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Text(
                                  'Total Pesanan',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                    CurrencyFormat.convertToIdr(
                                        int.parse(data[index]['total']), 0),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        color: Color(0x99FFC107))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
  }
}
