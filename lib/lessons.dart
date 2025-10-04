import 'dart:convert' as convert;
import 'package:alifbee/targets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alifbee/levels.dart';
import 'package:alifbee/Course.dart';

class LessonModel {
  final int id;
  final String title;
  final String icon;
  final String deactivateIcon;
  final int order;
  final String slug;
  final int estimate;
  final bool isRevise;
  final List reviseLessonsIds;
  final int levelId;
  final int version;
  final int status;

  LessonModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.deactivateIcon,
    required this.order,
    required this.slug,
    required this.estimate,
    required this.isRevise,
    required this.reviseLessonsIds,
    required this.levelId,
    required this.version,
    required this.status,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      icon: json['icon'] as String,
      // Use the null-aware operator '??' to provide a default value
      deactivateIcon: json['deactivateIcon'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      estimate: json['estimate'] as int? ?? 0,
      isRevise: json['isRevise'] as bool? ?? false,
      // 'revise_lessons_ids' might be null, so provide an empty list as a fallback
      reviseLessonsIds: json['reviseLessonsIds'] as List? ?? [],
      levelId: json['levelId'] as int? ?? 0,
      version: json['version'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
    );
  }
}

class LessonModelAPI {
  Future<List<LessonModel>> getLessonsModel(int levelId) async {
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
      print('Response status: ${response.statusCode}');
      final Map<String, dynamic> jsonResponse =
          convert.jsonDecode(response.body);
      final Map<String, dynamic> responseBody = jsonResponse['body'] ?? [];
      final List<dynamic> lessonsJson = responseBody['lessons'] ?? [];
      final lessons = lessonsJson
          .map((e) => LessonModel.fromJson(e))
          .toList()
          .cast<LessonModel>();
      print('Total lessons: ${lessons.length}');
      final currentLevelLessons =
          lessons.where((lesson) => lesson.levelId == levelId).toList();
      print('Lessons found for level $levelId: ${currentLevelLessons.length}');

      // Debugging: Print the title of the first lesson
      if (currentLevelLessons.isNotEmpty) {
        print('First lesson title: ${currentLevelLessons[0].title}');
      } else {
        print('No lessons found for the current level.');
      }
      return currentLevelLessons;
    } else {
      throw Exception('Failed to load lessons : ${response.statusCode}');
    }
  }
}

class LessonsScreen extends StatefulWidget {
  final int levelId;
  const LessonsScreen({super.key, required this.levelId});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final LessonModelAPI api = LessonModelAPI();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<LessonModel>>(
      future: api.getLessonsModel(widget.levelId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No lessons found.'));
        } else {
          final currentLevelLessons = snapshot.data!;
          return ListView.builder(
            itemCount: currentLevelLessons.length,
            itemBuilder: (context, index) {
              final lesson = currentLevelLessons[index];
              return ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TargetsScreen(
                              lessonId: lesson.id,
                              levelId: widget.levelId,
                            ))),
                subtitle:
                    Text(lesson.title, style: const TextStyle(fontSize: 20)),
                // Check for null or other types before using properties
                title: Text('Lesson ${lesson.order.toString()}',
                    style: const TextStyle(fontSize: 12)),
              );
            },
          );
        }
      },
    ));
  }
}
