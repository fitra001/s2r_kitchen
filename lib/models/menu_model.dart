import 'dart:convert';

class Menu {

  String id_menu;
  String id_kategori;
  String menu;
  String photo;
  String deskripsi;
  String stok;
  String harga;

  Menu({
    required this.id_menu,
    required this.id_kategori,
    required this.menu,
    required this.photo,
    required this.deskripsi,
    required this.stok,
    required this.harga
  });

  factory Menu.fromJson(Map<String, dynamic> map){
    return Menu(id_menu: map['id_menu'], id_kategori: map['id_kategori'], menu: map['menu'], photo: map['photo'], deskripsi: map['deskripsi'], stok: map['stok'], harga: map['harga']);
  }

  Map<String, dynamic> toJson() {
    return {'id_menu': id_menu, 'id_kategori': id_kategori, 'menu': menu, 'photo': photo, 'deskripsi': deskripsi, 'stok': stok, 'harga': harga};
  }

  @override
  String toString() {
    return 'Menu{id_menu: $id_menu, id_kategori: $id_kategori, menu: $menu, photo: $photo, deskripsi: $deskripsi, stok: $stok, harga: $harga}';
  }

}

List<Menu> menuFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Menu>.from(data['data'].map((json)=> Menu.fromJson(json)));
}

Menu singleMenuFromJson(String jsonData){
  final data = json.decode(jsonData);
  return Menu.fromJson(data['data']);
}

String menuToJson(Menu data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}