import 'dart:convert';

class Keranjang {

  String id_menu;
  String id_kategori;
  String qty;
  String menu;
  String photo;
  String deskripsi;
  String stok;
  String harga;

  Keranjang({
    required this.id_menu,
    required this.id_kategori,
    required this.qty,
    required this.menu,
    required this.photo,
    required this.deskripsi,
    required this.stok,
    required this.harga
  });

  factory Keranjang.fromJson(Map<String, dynamic> map){
    return Keranjang(id_menu: map['id_menu'], id_kategori: map['id_kategori'], qty: map['qty'], menu: map['menu'], photo: map['photo'], deskripsi: map['deskripsi'], stok: map['stok'], harga: map['harga']);
  }

  Map<String, dynamic> toJson() {
    return {'id_menu': id_menu, 'id_kategori': id_kategori, 'qty': qty, 'menu': menu, 'photo': photo, 'deskripsi': deskripsi, 'stok': stok, 'harga': harga};
  }

  @override
  String toString() {
    return 'Keranjang{id_menu: $id_menu, id_kategori: $id_kategori, qty: $qty, menu: $menu, photo: $photo, deskripsi: $deskripsi, stok: $stok, harga: $harga}';
  }

}

List<Keranjang> keranjangFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Keranjang>.from(data['data'].map((json)=> Keranjang.fromJson(json)));
}

Keranjang singleKeranjangFromJson(String jsonData){
  final data = json.decode(jsonData);
  return Keranjang.fromJson(data['data']);
}

String keranjangToJson(Keranjang data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}