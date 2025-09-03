import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:alifbee/levels.dart';

class Levels extends StatelessWidget {
  Levels({super.key});
  Widget betweenLessons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 0, 303, 8),
      child: Container(
        height: 40,
        width: 10,
        color: Color(0xffC9C2CB),
      ),
    );
  }

  Widget createLesson(
      String img, String num, String name, bool firstLesson, bool lastLesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!firstLesson)
          Padding(
            padding: const EdgeInsets.only(left: 49.0),
            child: Container(
              color: Color(0xffbcb5be),
              height: 8,
              width: 2,
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 1),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                child: Image.asset(
                  'lib/assets/$img.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(num, style: TextStyle(fontSize: 12)),
                    Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        if (!lastLesson)
          Padding(
            padding: const EdgeInsets.only(left: 49.0, top: 5),
            child: Container(
              color: Color(0xffbcb5be),
              height: 8,
              width: 2,
            ),
          )
      ],
    );
  }

  Widget createLevel(String data1, String data2) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xfff0eef0),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data1,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(data2,
                        style: TextStyle(
                          fontSize: 13,
                        ))
                  ],
                ),
                Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(image: AssetImage('lib/assets/Ellipse 113.png')),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Courses',
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('10'),
                  SizedBox(
                    width: 5,
                  ),
                  Image(image: AssetImage('lib/assets/honey 1.png'))
                ],
              )
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            createLevel('Lesson1', 'Description 1'),
            createLesson('P1', 'Lesson1', 'LessonName1', true, false),
            createLesson('P1', 'Lesson2', 'LessonName2', false, false),
            createLesson('P1', 'Lesson3', 'LessonName3', false, true),
            createLevel('Lesson2', 'description 2'),
            createLesson('P2', 'Lesson4', 'LessonName4', true, false),
            createLesson('P2', 'Lesson5', 'LessonName5', false, false),
            createLesson('P2', 'Lesson6', 'LessonName6', false, true),
          ],
        ));
    // here add navigation bar
  }
}
