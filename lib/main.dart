import 'package:s2r_kitchen/splashscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MaterialApp(
      title: 'S2R Kitchen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xffFFC107),
        fontFamily: 'sans serif mono'
        
      ),
      // home: const SplashScreenPage(),
      home: const SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}