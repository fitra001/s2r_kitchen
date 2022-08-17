import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/page/Admin/admin.dart';
import 'package:s2r_kitchen/page/HomeUser/home/home.dart';
import 'package:s2r_kitchen/page/HomeUser/home_page/home_page.dart';
import 'package:s2r_kitchen/page/login/login.dart';
import 'package:s2r_kitchen/page/register/register.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({ Key? key }) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    final isLogin = await MySharedPref().getLogin();
    final user = await MySharedPref().getModel();
    var duration = const Duration(seconds : 2);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_){
          return isLogin ? 
          (user!.role_id == "3") ? const Home()
          :   const Admin() : const MainHome();
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bgsplash.png",),
          fit: BoxFit.fitHeight
          )
        ),  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          
          children: [
            Image.asset("assets/images/loader.gif", width: 100,),
            const SizedBox(height: 100,)
          ],
          
        ),

      ),
    );
        
  }
}


class MainHome extends StatelessWidget {
  const MainHome({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bgsplash.png",),
          fit: BoxFit.fitHeight
          )
        ),  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          
          children:  [
            const Text("Selamat Datang", 
              style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: 'Satisfy'
                ),
            ),
            const SizedBox(height: 16,),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextButton(
                style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: const Color(0xEE000000),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color(0xFFFFC107),
                            width: 1,
                            style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // shape: StadiumBorder()
                      ),
                onPressed: () {
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const Login())
                  );
                }, 
                child: const Text(
                  "MASUK", 
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                )
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextButton(
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
                ),
                onPressed: () {
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const Register())
                  );
                }, 
                child: const Text(
                  "DAFTAR", 
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                  ),
                )
              ),
            ),
            const SizedBox(height: 90,),
          ],
        ),
      );
  }
}