import 'dart:math';

import 'package:flutter/material.dart';
import 'package:alifbee/settingpage.dart';
import 'package:alifbee/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      // home: Levels(),
      home: Login(),
    );
  }
}
