import 'dart:math';
import 'package:alifbee/Course.dart';
import 'package:alifbee/lessons.dart';
import 'package:alifbee/levels.dart';
import 'package:alifbee/zzzz.dart';
import 'package:flutter/material.dart';
import 'package:alifbee/settingpage.dart';
import 'package:alifbee/login.dart';
import 'package:alifbee/loader.dart';

void main() {
  runApp(const MyApp());
  // CourseModelAPI().getCourseModel().catchError((error) {
  //   print('Error occurred: $error');
  // });

  // CoursesAPI().getCourses().catchError((error) {
  //   print('Error occurred: $error');
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      // home: LevelsScreen(),
      home: Login(),
      // home: LevelsScreen(),
      // home: LessonsScreen(levelId: 3,),
      // home: CoursesScreen(),
    );
  }
}
