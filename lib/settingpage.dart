import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:alifbee/levels.dart';

class Levels extends StatefulWidget {
  const Levels({super.key});

  @override
  State<Levels> createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  int _currentIndex = 0;

  Widget betweenLessons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 0, 303, 8),
      child: Container(
        height: 40,
        width: 10,
        color: const Color(0xffC9C2CB),
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
              color: const Color(0xffbcb5be),
              height: 8,
              width: 2,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 1),
          child: Row(
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: Image.asset(
                  'lib/assets/$img.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(num, style: const TextStyle(fontSize: 12)),
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        if (!lastLesson)
          const Padding(
            padding: EdgeInsets.only(left: 49.0, top: 5),
            child: SizedBox(
              height: 8,
              width: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xffbcb5be)),
              ),
            ),
          )
      ],
    );
  }

  Widget createLevel(String data1, String data2) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
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
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(data2, style: const TextStyle(fontSize: 13))
                  ],
                ),
                const Icon(Icons.keyboard_arrow_down_rounded)
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
              children: [
                const Image(image: AssetImage('lib/assets/Ellipse 113.png')),
                const SizedBox(width: 5),
                const Text('Courses', style: TextStyle(color: Colors.black)),
                const Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
            Row(
              children: const [
                Text('10'),
                SizedBox(width: 5),
                Image(image: AssetImage('lib/assets/honey 1.png'))
              ],
            )
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF3E254A),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "",
          ),
        ],
      ),
    );
  }
}
