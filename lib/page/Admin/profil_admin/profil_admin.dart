import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/kelola_user/kelola_user.dart';
import 'package:s2r_kitchen/page/HomeUser/profil/ubah_profil/ubah_profil.dart';
import 'package:s2r_kitchen/splashscreen_view.dart';
import 'package:flutter/material.dart';

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({Key? key}) : super(key: key);

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

class _ProfilAdminState extends State<ProfilAdmin> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = User();
    _login();
  }

  _login() async {
    final getUser = await MySharedPref().getModel();
    if (getUser != null) {
      setState(() {
        user = getUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text(
                'Nama',
                style: TextStyle(fontSize: 18),
              ),
              Text(user!.nama.toString(), style: const TextStyle(fontSize: 24)),
              Container(
                decoration: const BoxDecoration(color: Colors.grey),
                height: 2,
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Email',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                user!.email.toString(),
                style: const TextStyle(fontSize: 24),
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.grey),
                height: 2,
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'No Telp',
                style: TextStyle(fontSize: 18),
              ),
              Text("+"+user!.no_telp.toString(),
                  style: const TextStyle(fontSize: 24)),
              Container(
                decoration: const BoxDecoration(color: Colors.grey),
                height: 2,
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.grey),
                // height: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => UbahProfil(user: user!),)
                    );
                  } ,
                  child: const Text(
                    'Ubah Akun',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 2,
              // ),
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(16),
              //   decoration: const BoxDecoration(color: Colors.grey),
              //   // height: 2,
              //   child: const Text(
              //     'Ubah Kata Sandi',
              //     style: TextStyle(fontSize: 18),
              //   ),
              // ),
              const SizedBox(
                height: 24,
              ),
              (user?.role_id != "1") ? const SizedBox() :GestureDetector(
                onTap: ()=>{
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const KelolaUser(),)
                  )
                } ,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.blueGrey),
                  // height: 2,
                  child: const Text(
                    'Kelola User',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.redAccent),
                  // height: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          MySharedPref().clearAllData();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SplashScreenPage()));
                        },
                        child: Text('Logout')),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
