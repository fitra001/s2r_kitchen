import 'dart:io';

import 'package:s2r_kitchen/models/kategori_model.dart';
import 'package:s2r_kitchen/models/menu_model.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({ Key? key, required this.menu }) : super(key: key);
  final Menu menu;
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  bool loading = false;
  late String _valKategori;
  final _menuNamaController = TextEditingController();
  final _menuDeskripsiController = TextEditingController();
  final _menuStokController = TextEditingController();
  final _menuHargaController = TextEditingController();
  List<Kategori>? _dataKategori = [];
  final ImagePicker _imagePicker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _valKategori = widget.menu.id_kategori;
    _menuNamaController.text = widget.menu.menu;
    _menuDeskripsiController.text = widget.menu.deskripsi;
    _menuStokController.text = widget.menu.stok;
    _menuHargaController.text = widget.menu.harga;

    _getKategori();
  }

  _getKategori() async {
    final kategori = await ApiService().getAllKategori();
    setState(() {
      _dataKategori = kategori;
    });
    
  }

  _imageFile(XFile image){
    if (kIsWeb) {
      return Image.network(
        image.path,
        height: 200,
        width: 200,
      );
    } else {
      return Image.file(
        File(image.path),
        height: 200,
        width: 200,
      );
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
          'Edit Menu', 
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: loading ? const Center(child: CircularProgressIndicator(),) : Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final XFile? _image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                  setState(() {
                    image = _image;
                  });
                },
                child: (image != null) ?
                  _imageFile(image!)
                  : Image.network(
                      ApiService.imageMenuUrl + widget.menu.photo, height: 200, width: 200
                  ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _menuNamaController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    // prefixIcon: Icon(CupertinoIcons.search,
                    //     color: Color(0x99FFC107)),
                    labelText: 'Menu',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: const Color(0x99FFC107)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  value: _valKategori,
                  hint: const Text('Kategori'),
                  items: _dataKategori?.map((e) {
                    return DropdownMenuItem(
                      child: Text(e.kategori),
                      value: e.id_kategori,
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _valKategori = '$val';
                    });
                  } ,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  maxLines: 8,
                  controller: _menuDeskripsiController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    // prefixIcon: Icon(CupertinoIcons.search,
                    //     color: Color(0x99FFC107)),
                    labelText: 'Deskripsi',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _menuStokController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    // prefixIcon: Icon(CupertinoIcons.search,
                    //     color: Color(0x99FFC107)),
                    labelText: 'Stok',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _menuHargaController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    // prefixIcon: Icon(CupertinoIcons.search,
                    //     color: Color(0x99FFC107)),
                    labelText: 'Harga',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x99FFC107)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                width: double.infinity,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xff404040),
                    ),
                    onPressed: () async{
                      setState(() {
                        loading = true;
                      });
                      var data = {
                        'id_menu' : widget.menu.id_menu,
                        'id_kategori' : _valKategori,
                        'menu' :_menuNamaController.text,
                        'deskripsi' : _menuDeskripsiController.text,
                        'harga' : _menuHargaController.text,
                        'stok' : _menuStokController.text
                      };
                      
                      final res = await ApiService().updateMenu(data, image);
                      print(res);
                      if (res['success'] == false) {
                        Fluttertoast.showToast(msg: res['message']);
                        setState(() {
                          loading = false;
                        });
                      } else {
                        Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const Admin()));
                        Fluttertoast.showToast(msg: res['message']);
                      }
                    },
                    child: const Text(
                      'Simpan',
                      style: TextStyle(color: Color(0xffFFC107)),
                    )),
              ),
              const SizedBox(height: 24,)
            ],
          ),
        ),
      )
    );
  }

}