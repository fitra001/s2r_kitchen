import 'dart:convert';

class User {
  String? id_user;
  String? nama;
  String? email;
  String? no_telp;
  String? foto;
  String? role_id;

  User({this.id_user, this.nama, this.email, this.no_telp, this.foto, this.role_id});
  
  factory User.fromJson(Map<String, dynamic> map){
    return User(id_user: map['id_user'], nama: map['nama'], email: map['email'], no_telp: map['no_telp'], foto: map['foto'], role_id: map['role_id']);
  }

  Map<String, dynamic> toJson(){
    return {'id_user': id_user, 'nama': nama, 'email': email, 'no_telp': no_telp, 'foto': foto, 'role_id': role_id};
  }

}

User userSharedFromJson(String jsonData){
  final data = json.decode(jsonData);
  return User.fromJson(data);
}

User userFromJson(Map<String, dynamic> jsonData){
  return User.fromJson(jsonData);
}

String userToJson(User data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}