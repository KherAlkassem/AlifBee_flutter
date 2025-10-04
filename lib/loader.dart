import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alifbee/levels.dart';
import 'package:alifbee/Course.dart';
import 'dart:convert' as convert;
import 'package:alifbee/targets.dart';
import 'package:alifbee/lessons.dart';

class Syllabus {
  final List<CourseModel> courses;
  final List<LevelModel> levels;
  final List<LessonModel> lessons;
  final List<TargetModel> targets;

  Syllabus({
    required this.courses,
    required this.levels,
    required this.lessons,
    required this.targets,
  });
}

class SyllabusAPI {
  Future<Syllabus> getFullSyllabus() async {
    final response = await http.get(
      Uri.parse(
          'https://dev02.arabeeworld.com/api/v5/syllabus/get_syllabus?environment=prod'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization':
            'Token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtLnNhbGFoQGFsaWZiZWUuY29tIiwiZGV2aWNlSWQiOiIxMjM0NTY3ODkiLCJpYXQiOjE3NTgxODg0NDAsImV4cCI6MTc3Mzc0MDQ0MCwidXNlclRva2VuSWQiOjg5MX0.3lwElmpPdRP0NUYowaaI1nuMZ2U6ZItKrCMclhZuIyk',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> responseBody = jsonResponse['body'] ?? {};

      // Parse courses
      final List<CourseModel> courses = (jsonResponse['courses'] as List)
          .map((courseJson) =>
              CourseModel.fromJson(courseJson as Map<String, dynamic>))
          .toList();

      // Parse levels
      final List<LevelModel> levels = (jsonResponse['levels'] as List)
          .map((levelJson) =>
              LevelModel.fromJson(levelJson as Map<String, dynamic>))
          .toList();

      // Parse lessons
      final List<LessonModel> lessons = (jsonResponse['lessons'] as List)
          .map((lessonJson) =>
              LessonModel.fromJson(lessonJson as Map<String, dynamic>))
          .toList();

      // Parse targets
      final List<TargetModel> targets = (jsonResponse['targets'] as List)
          .map((targetJson) =>
              TargetModel.fromJson(targetJson as Map<String, dynamic>))
          .toList();

      return Syllabus(
        courses: courses,
        levels: levels,
        lessons: lessons,
        targets: targets,
      );
    } else {
      throw Exception('Failed to load syllabus :${response.statusCode} ');
    }
  }
}

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({super.key});

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}