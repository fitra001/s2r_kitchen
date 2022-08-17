import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/page/Admin/kelola_user/kelola_user.dart';
import 'package:s2r_kitchen/page/login/login.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UbahUser extends StatefulWidget {
  const UbahUser({ Key? key , required this.user}) : super(key: key);
  final User? user;

  @override
  _UbahUser createState() => _UbahUser();
}

class _UbahUser extends State<UbahUser> {
  String? _valRole;
  bool isLoading = false;
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  List<dynamic> role = [];

  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUserRole();

    _valRole = widget.user?.role_id;
    _namaController.text = widget.user!.nama.toString();
    _noTelpController.text = widget.user!.no_telp.toString();
    _emailController.text = widget.user!.email.toString();
    // _passController.text = widget.user!.
  }

  _getUserRole() async{
    final getUserRole = await ApiService().getUserRole();
    setState(() {
      role = getUserRole['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon : const Icon(
            CupertinoIcons.chevron_left_circle, 
            color: Color(0xFFFFC107),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
          iconSize: 30,
        ),
        title: const Text('Ubah User', style: TextStyle(color: Colors.black),),  
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff000000),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff000000))),
                height: 120,
                width: 120,
                child: Image.asset(
                  'assets/images/bgsplash.png',
                ),
              )),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _namaController,
                style: const TextStyle(fontFamily: 'sans serif'),
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(CupertinoIcons.person),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _noTelpController,
                style: const TextStyle(fontFamily: 'sans serif'),
                decoration: const InputDecoration(
                  labelText: 'No Telpon',
                  prefixIcon: Icon(CupertinoIcons.phone),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(fontFamily: 'sans serif'),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(CupertinoIcons.mail),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _passController,
                style: const TextStyle(fontFamily: 'sans serif'),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(CupertinoIcons.lock),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  suffixIcon: InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isHidden ?
                      CupertinoIcons.eye_fill :
                      CupertinoIcons.eye_slash
                      )
                  )
                ),
                obscureText: _isHidden,
              ),
              const SizedBox(height: 16,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: const Color(0x99FFC107)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  value: _valRole,
                  items: role.map((e) {
                    return DropdownMenuItem(
                      child: Text(e['role']),
                      value: e['id_role'],
                    );
                  }).toList(), 
                  onChanged: (val) {
                    setState(() {
                      _valRole = val.toString();
                    });
                  }
                ),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                child: isLoading ? const Center(child: CircularProgressIndicator(),) : TextButton(
                  style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color(0x44FFC107),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Color(0xFF000000),
                              width: 1,
                              style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // shape: StadiumBorder()
                        ),
                  onPressed: () async{  
                    setState(() {
                      isLoading = true;
                    });     
      
                    Map<String, String> data = {
                      'id_user': widget.user!.id_user.toString(),
                      'nama': _namaController.text,
                      'no_telp': _noTelpController.text,
                      'email': _emailController.text,
                      'role_id': _valRole.toString(),
                      'password' : _passController.text
                    };

                    final res = await ApiService().ubahUser(data);
                    if (res['success']) {
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const KelolaUser())
                      );
                      Fluttertoast.showToast(
                        msg: res[
                            'message']);
                    }else{
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(
                        msg: res[
                            'message']);
                    }
                      
                  }, 
                  child: const Text(
                    "Simpan", 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}