import 'dart:io';

import 'package:s2r_kitchen/models/kategori_model.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class TambahReservasi extends StatefulWidget {
  const TambahReservasi({ Key? key}) : super(key: key);
  @override
  State<TambahReservasi> createState() => _EditReservasiState();
}

class _EditReservasiState extends State<TambahReservasi> {
  bool loading = false;
  String? _valKategori;
  final _reservasiNamaController = TextEditingController();
  final _reservasiDeskripsiController = TextEditingController();
  final _reservasiStokController = TextEditingController();
  final _reservasiHargaController = TextEditingController();
  List<Kategori>? _dataKategori = [];
  final ImagePicker _imagePicker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _getKategori();
  }

  // _getKategori() async {
  //   final kategori = await ApiService().getAllKategori();
  //   setState(() {
  //     _dataKategori = kategori;
  //   });
    
  // }

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
          'Tambah Reservasi', 
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
                  : Container(
                    height:200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.camera),
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _reservasiNamaController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    // prefixIcon: Icon(CupertinoIcons.search,
                    //     color: Color(0x99FFC107)),
                    labelText: 'Reservasi',
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
                child: TextFormField(
                  maxLines: 8,
                  controller: _reservasiDeskripsiController,
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
                  controller: _reservasiHargaController,
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
                        'reservasi' :_reservasiNamaController.text,
                        'deskripsi' : _reservasiDeskripsiController.text,
                        'harga' : _reservasiHargaController.text,
                      };

                      final res = await ApiService().tambahReservasi(data, image);
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