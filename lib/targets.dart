import 'package:alifbee/lessons.dart';
import 'package:alifbee/levels.dart';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alifbee/Course.dart';

class TargetModel {
  final int id;
  final String title;
  final String type;
  final String slug;
  final int order;
  final String icon;
  final int unlocked;
  final int isBot;
  final String oneSignalData1;
  final String oneSignalData2;
  final int lessonId;
  final int levelId;
  final int questionsCount;
  final int correctAnswers;
  final int incorrectAnswers;
  final int lapsTime;
  final int status;

  TargetModel({
    required this.id,
    required this.title,
    required this.type,
    required this.slug,
    required this.order,
    required this.icon,
    required this.unlocked,
    required this.isBot,
    required this.oneSignalData1,
    required this.oneSignalData2,
    required this.lessonId,
    required this.levelId,
    required this.questionsCount,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.lapsTime,
    required this.status,
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) {
    return TargetModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      icon: json['icon'] as String? ?? '',
      unlocked: json['unlocked'] as int? ?? 0,
      isBot:
          json['isBot'] as int? ?? 0, // Use 'isBot' to match your example JSON
      oneSignalData1: json['oneSignalData1'] as String? ?? '',
      oneSignalData2: json['oneSignalData2'] as String? ?? '',
      lessonId: json['lessonId'] as int? ?? 0,
      levelId: json['levelId'] as int? ?? 0,
      questionsCount: json['questionsCount'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      incorrectAnswers: json['incorrectAnswers'] as int? ?? 0,
      lapsTime: json['lapsTime'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
    );
  }
}

class TargetModelAPI {
  Future<List<TargetModel>> getTargetsModel(int lessonId, int levelId) async {
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

      final List<dynamic> targetsJson = responseBody['targets'] ?? [];
      final targets = targetsJson
          .map((e) => TargetModel.fromJson(e))
          .toList()
          .cast<TargetModel>();
      print('Total targets fetched: ${targets.length}');
      final currentLessonTargets = targets
          .where((target) =>
              target.lessonId == lessonId && target.levelId == levelId)
          .toList();
      print(
          'Targets for lessonId $lessonId and levelId $levelId: ${currentLessonTargets.length}');
      // Debugging: Print the title of the first target
      if (targets.isNotEmpty) {
        print('First target title: ${targets[0].title}');
      } else {
        print('No targets found in the response.');
      }
      return currentLessonTargets;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load targets');
    }
  }
}

class TargetsScreen extends StatefulWidget {
  final int levelId;
  final int lessonId;

  const TargetsScreen(
      {super.key, required this.levelId, required this.lessonId});

  @override
  State<TargetsScreen> createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sections'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<TargetModel>>(
          future:
              TargetModelAPI().getTargetsModel(widget.lessonId, widget.levelId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No targets found.'));
            } else {
              final currentLessonTargets = snapshot.data!;
              return ListView.builder(
                itemCount: currentLessonTargets.length,
                itemBuilder: (context, index) {
                  final target = currentLessonTargets[index];
                  return ListTile(
                      subtitle: Text(target.title,
                          style: const TextStyle(fontSize: 20)),
                      title: Text(
                        target.type,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ));
                },
              );
            }
          },
        ));
  }
}
