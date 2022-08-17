import 'dart:convert';
import 'dart:typed_data';
import 'package:s2r_kitchen/models/kategori_model.dart';
import 'package:s2r_kitchen/models/keranjang_model.dart';
import 'package:s2r_kitchen/models/menu_model.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  static const String url = "https://s2rkitchen1.000webhostapp.com"; // Online
  // static const String url = "http://192.168.57.1/backend/s2r_kitchen_ci"; // Local Host / XAMPP
  static const String baseUrl = url + '/api';
  
  static const String imageKategoriUrl = url + '/images/kategori/';
  static const String imageMenuUrl = url + '/images/menu/';
  static const String imageProfilUrl = url + '/images/profil/';
  static const String imageReservasiUrl = url + '/images/reservasi/';

  Client client = Client();

  Future<dynamic> login({String? email, String? pass}) async {
    var data = {'email': email, 'password': pass};
    
    final response = await client.post(Uri.parse(baseUrl + '/auth'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));
  
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> register(
      {String? nama, String? noTelp, String? email, String? password}) async {
    var data = {
      'nama': nama,
      'no_telp': noTelp,
      'email': email,
      'password': password,
      'role_id': 3,
      'is_active': 1
    };

    final response = await client.post(Uri.parse(baseUrl + '/auth/register'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getkadaluarsa() async {
    final response = await client.get(
      Uri.parse(baseUrl + '/kadaluarsa')
    );
    return response;
  }

  Future<List<User>?> getAllUser() async {
    final response = await client.get(Uri.parse(baseUrl + '/user'));
    if (response.statusCode == 200) {
      Map<String, dynamic> res = json.decode(response.body);
      
      return List.from( res['data'].map((e)=>userFromJson(e)));
      // return userFromJson(res['data']);
    } else {
      return null;
    }
  }

  Future<List<User>?> getUserSearch(String text) async {
    final response = await client.get(Uri.parse(baseUrl + '/user/search/'+text));
    if (response.statusCode == 200) {
      Map<String, dynamic> res = json.decode(response.body);

      return List.from(res['data'].map((e) => userFromJson(e)));
      // return userFromJson(res['data']);
    } else {
      return null;
    }
  }

  Future<dynamic> getUserRole() async {
    final response =
        await client.get(Uri.parse(baseUrl + '/user/user_role'));
        
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> tambahUser(
      {String? nama, String? noTelp, String? email, String? password, String? role_id}) async {
    var data = {
      'nama': nama,
      'no_telp': noTelp,
      'email': email,
      'password': password,
      'role_id': role_id,
      'is_active': 1
    };

    final response = await client.post(Uri.parse(baseUrl + '/auth/register'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> ubahUser(dynamic data, [XFile? image]) async{
    MultipartRequest request =
        MultipartRequest("POST", Uri.parse(baseUrl + '/user/update'));
    request.headers.addAll({'Content-Type': 'multipart/form-data'});
    request.fields.addAll(data);
    if (image != null) {
      var photo;

      if (kIsWeb) {
        // photo = await MultipartFile.fromBytes('photo',);
      } else {
        photo = await MultipartFile.fromPath('foto', image.path);
        request.files.add(photo);
      }
    }

    StreamedResponse response = await request.send();
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> res = json.decode(responseString);
    return res;

    // final response = await client.post(Uri.parse(baseUrl + '/user/update'),
    //     headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    // Map<String, dynamic> res = json.decode(response.body);
    // return res;
  }

  Future<List<Kategori>?> getAllKategori() async {
    final response = await client.get(Uri.parse(baseUrl + '/kategori'));
    if (response.statusCode == 200) {
      return kategoriFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Menu>?> getAllMenu() async {
    final response = await client.get(Uri.parse(baseUrl + '/menu'));
    if (response.statusCode == 200) {
      return menuFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Menu>?> getMenuTerlaris() async {
    final response = await client.get(Uri.parse(baseUrl + '/menu/terlaris'));
    if (response.statusCode == 200) {
      return menuFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Menu>?> getMenuByIdKategori(String idKategori) async {
    final response =
        await client.get(Uri.parse(baseUrl + '/menu/kategori/' + idKategori));
    if (response.statusCode == 200) {
      return menuFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<Menu>?> getMenuByNama(String text) async {
    final response =
      await client.get(Uri.parse(baseUrl + '/menu/search/' + text));
    if (response.statusCode == 200) {
      return menuFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Menu?> getDetailMenuByIdMenu(String idMenu) async {
    getkadaluarsa();
    final response = await client.get(Uri.parse(baseUrl + '/menu/' + idMenu));
    if (response.statusCode == 200) {
      return singleMenuFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> deleteMenu(String idMenu) async {
    final response = await client.get(
      Uri.parse(baseUrl + '/menu/hapus/'+idMenu)
    );
    
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> updateMenu(dynamic menu, [XFile? image]) async {
    MultipartRequest request = MultipartRequest("POST", Uri.parse(baseUrl + '/menu/update'));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data'
    });
    request.fields.addAll(menu);
    if(image != null) {
      var photo;

      if (kIsWeb) {
        // photo = await MultipartFile.fromBytes('photo',);
      }else{
        photo = await MultipartFile.fromPath('photo', image.path);
        request.files.add(photo);
      }
    }
    StreamedResponse response = await request.send();
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> res = json.decode(responseString);
    return res;
  }

  Future<dynamic> tambahMenu(dynamic menu, [XFile? image]) async {
    
    MultipartRequest request =
        MultipartRequest("POST", Uri.parse(baseUrl + '/menu/tambah'));
    request.headers.addAll({'Content-Type': 'multipart/form-data'});
    request.fields.addAll(menu);
    if (image != null) {
      var photo;

      if (kIsWeb) {
        // photo = await MultipartFile.fromBytes('photo',);
      } else {
        photo = await MultipartFile.fromPath('photo', image.path);
        request.files.add(photo);
      }
    }

    StreamedResponse response = await request.send();
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> res = json.decode(responseString);
    return res;
  }

  Future<List<Keranjang>?> getKeranjang(String idUser) async {
    final response = await client.post(Uri.parse(baseUrl + '/keranjang'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_user': idUser}));
    if (response.statusCode == 200) {
      return keranjangFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> getJumlahKeranjang(String idUser) async {
    final response = await client.post(Uri.parse(baseUrl + '/keranjang/jumlah'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_user': idUser}));
    
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> addKeranjang({String? idUser, String? idMenu, String? qty}) async {
    var data = {'id_user': idUser, 'id_menu': idMenu, 'qty': qty};
    final response = await client.post(Uri.parse(baseUrl + '/keranjang/add'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));
  
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> updateQtyKeranjang(
      {String? idUser, String? idMenu, String? qty}) async {
    var data = {'id_user': idUser, 'id_menu': idMenu, 'qty': qty};
    final response = await client.post(
        Uri.parse(baseUrl + '/keranjang/update_qty'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> deleteKeranjang({String? idUser, String? idMenu}) async {
    var data = {'id_user': idUser, 'id_menu': idMenu};
    final response = await client.post(Uri.parse(baseUrl + '/keranjang/delete'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> deleteKeranjangByUser({required String? idUser}) async {
    var data = {'id_user': idUser};
    final response = await client.post(Uri.parse(baseUrl + '/keranjang/delete/user'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> addOrder({required String? idUser, required String total}) async {
    var data = {'id_user': idUser, 'total': total};
    final response = await client.post(Uri.parse(baseUrl + '/order/add'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> addDetailOrder({required String? lastId, required String? idMenu, required String? harga, required String? qty}) async {
    var data = {'id_transaksi': lastId, 'id_menu': idMenu, 'harga': harga, 'qty': qty};
    final response = await client.post(Uri.parse(baseUrl + '/order/add/detail'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getDetailOrder({required String? idTransaksi}) async {
    var data = {'id_transaksi': idTransaksi};
    final response = await client.post(Uri.parse(baseUrl + '/order/detail'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getRiwayatOrder(String idUser) async {
    final response = await client.post(Uri.parse(baseUrl + '/order/riwayat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_user': idUser}));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getPesananOrder(String idUser) async {
    getkadaluarsa();
    final response = await client.post(Uri.parse(baseUrl + '/order/pesanan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_user': idUser}));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getAllPesanan({String? nama}) async {
    String url = (nama != null) ? '/order/pesanan/' + nama : '/order/pesanan/';

    final response = await client.get(Uri.parse(baseUrl + url ),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getAllPesananSelesai() async {
    final response = await client.get(Uri.parse(baseUrl + '/order/selesai'),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getAllPesananSiap({String? nama}) async {
    String url = (nama != null) ? '/order/siap/' + nama : '/order/siap';

    final response = await client.get(Uri.parse(baseUrl + url),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getAllPesananProses({String? nama}) async {
    String url = (nama != null) ? '/order/proses/' + nama : '/order/proses';
    
    final response = await client.get(Uri.parse(baseUrl + url),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> updateStatusPesanan({status, idTransaksi, String? petugas} ) async {
    var data = {'status': status, 'id_transaksi': idTransaksi};
    if (petugas != null) {
      data['petugas'] = petugas;
    }
    final response = await client.post(Uri.parse(baseUrl + '/order/update_status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
      );

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getPendapatanPenjualan() async {
    final response = await client.get(
      Uri.parse(baseUrl + '/transaksi/pendapatan_penjualan')
    );
    
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getPendapatanBooking() async {
    final response = await client
        .get(Uri.parse(baseUrl + '/transaksi/pendapatan_booking'));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getTotalPenjualan() async {
    final response = await client
        .get(Uri.parse(baseUrl + '/transaksi/total_penjualan'));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getTransaksiPenjualan() async {
    final response =
        await client.get(Uri.parse(baseUrl + '/transaksi/transaksi_penjualan'));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getTransaksiBooking() async {
    final response =
        await client.get(Uri.parse(baseUrl + '/transaksi/transaksi_booking'));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getReservasi() async {
    final response =
        await client.get(Uri.parse(baseUrl + '/reservasi'));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> deleteReservasi(String idReservasi) async {
    final response =
        await client.get(Uri.parse(baseUrl + '/reservasi/hapus/' + idReservasi));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> tambahReservasi(dynamic menu, [XFile? image]) async {
    MultipartRequest request =
        MultipartRequest("POST", Uri.parse(baseUrl + '/reservasi/tambah'));
    request.headers.addAll({'Content-Type': 'multipart/form-data'});
    request.fields.addAll(menu);
    if (image != null) {
      var photo;

      if (kIsWeb) {
        // photo = await MultipartFile.fromBytes('photo',);
      } else {
        photo = await MultipartFile.fromPath('foto', image.path);
        request.files.add(photo);
      }
    }

    StreamedResponse response = await request.send();
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> res = json.decode(responseString);
    return res;
  }

  Future<dynamic> updateReservasi(dynamic reservasi, [XFile? image]) async {
    MultipartRequest request =
        MultipartRequest("POST", Uri.parse(baseUrl + '/reservasi/update'));
    request.headers.addAll({'Content-Type': 'multipart/form-data'});
    request.fields.addAll(reservasi);
    if (image != null) {
      var foto;

      if (kIsWeb) {
        // foto = await MultipartFile.fromBytes('foto',);
      } else {
        foto = await MultipartFile.fromPath('foto', image.path);
        request.files.add(foto);
      }
    }
    StreamedResponse response = await request.send();
    Uint8List responseData = await response.stream.toBytes();
    String responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> res = json.decode(responseString);
    return res;
  }

  Future<dynamic> getReservasiById(String idReservasi) async {
    final response = await client.get(Uri.parse(baseUrl + '/reservasi/'+ idReservasi));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getListPesananReservasiById(String idReservasi) async {
    final response =
        await client.get(Uri.parse(baseUrl + '/reservasi/list_pesanan/' + idReservasi));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getReservasiPesananById(String idUser) async {

    final response =
        await client.post(Uri.parse(baseUrl + '/reservasi/pesanan'),
        headers: {'Content-Type': 'application/json'}, 
        body: json.encode({'id_user': idUser}));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getReservasiRiwayatById(String idUser) async {
    final response = await client.post(
        Uri.parse(baseUrl + '/reservasi/riwayat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_user': idUser}));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getReservasiDetailPesananById(String id) async {
    final response = await client.post(
        Uri.parse(baseUrl + '/reservasi/detail'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> addOrderReservasi({required String? idReservasi, required String? idUser, required String total, required String tglReservasi }) async {
    var data = {
      'id_reservasi' : idReservasi,
      'id_user': idUser, 
      'total': total,
      'tgl_reservasi' :tglReservasi
    };
    final response = await client.post(Uri.parse(baseUrl + '/reservasi/transaksi'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getAllReservasiPesanan({String? nama}) async {
    String url = (nama != null) ? '/reservasi/pesanan/' + nama : '/reservasi/pesanan';
    final response = await client.get(Uri.parse(baseUrl + url),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getAllReservasiBelumLunas({String? nama}) async {
    String url = (nama != null) ? '/reservasi/belum_lunas/' + nama : '/reservasi/belum_lunas';
    final response = await client.get(Uri.parse(baseUrl + url),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getAllReservasiLunas({String? nama}) async {
    String url = (nama != null) ? '/reservasi/lunas/' + nama : '/reservasi/lunas';
    final response = await client.get(Uri.parse(baseUrl + url),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }
  
  Future<dynamic> getAllReservasiSelesai() async {
    final response = await client.get(Uri.parse(baseUrl + '/reservasi/selesai'),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> bayarReservasiPesanan(
      {idTransaksi, total, bayar, String? petugas}) async {
    var data = {'id': idTransaksi, 'total': total, 'bayar':bayar, 'petugas':petugas};
    // if (petugas != null) {
    //   data['petugas'] = petugas;
    // }
    final response = await client.post(
        Uri.parse(baseUrl + '/reservasi/bayar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> updateStatusPesananReservasi(
      {status, idTransaksi, total}) async {
    var data = {'status': status, 'id': idTransaksi, 'total' : total};
    final response = await client.post(
        Uri.parse(baseUrl + '/reservasi/update_pesanan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }
  
  Future<dynamic> filterSelesaiReservasi(
      {tglAwal, tglAkhir}) async {
    var data = {'tgl_awal': tglAwal, 'tgl_akhir': tglAkhir};
    final response = await client.post(
        Uri.parse(baseUrl + '/reservasi/tanggal'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> filterSelesaiTransaksi({tglAwal, tglAkhir}) async {
    var data = {'tgl_awal': tglAwal, 'tgl_akhir': tglAkhir};
    final response = await client.post(
        Uri.parse(baseUrl + '/order/tanggal'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data));

    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<dynamic> getTotalTerjualHari() async {
    final response = await client.get(Uri.parse(baseUrl + '/transaksi/terjual_hari'),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res['data'];
  }

  Future<dynamic> getTotalTerjualBulan() async {
    final response = await client.get(
        Uri.parse(baseUrl + '/transaksi/terjual_bulan'),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> res = json.decode(response.body);
    return res['data'];
  }
}
