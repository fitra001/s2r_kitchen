import 'dart:convert';

class Kategori {
  String id_kategori;
  String kategori;
  String icon;

  Kategori(
      {required this.id_kategori, required this.kategori, required this.icon});

  factory Kategori.fromJson(Map<String, dynamic> map) {
    return Kategori(
        id_kategori: map["id_kategori"],
        kategori: map["kategori"],
        icon: map["icon"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id_kategori, "kategori": kategori, "icon": icon};
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Kategori{id_kategori: $id_kategori, kategori: $kategori, icon: $icon}';
  }
}

List<Kategori> kategoriFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Kategori>.from(
      data['data'].map((json) => Kategori.fromJson(json)));
}

String kategoriToJson(Kategori data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
