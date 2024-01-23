import 'package:flutter/material.dart';
import 'package:guestbook/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: splash(),
      // home: home(),
      // routes: {
      //   'home': (context) => home(),
      // },
      // home: IndexPage(),
    );
  }
}
