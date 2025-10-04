import 'dart:convert' as convert;
import 'package:alifbee/lessons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LevelModel {
  final int id;
  final String slug;
  final String title;
  final String description;
  final int order;

  LevelModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.order,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] ?? 0,
      slug: json['slug'],
      title: json['title'],
      description: json['description'],
      order: json['order'] ?? 0,
    );
  }
}

class LevelsAPI {
  Future<List<LevelModel>> getLevels() async {
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

      final List<dynamic> levelsJson = responseBody['levels'] ?? [];
      final levels = levelsJson
          .map((e) => LevelModel.fromJson(e))
          .toList()
          .cast<LevelModel>();
      // Debugging: Print the title of the first level
      if (levels.isNotEmpty) {
        print('First level title: ${levels[0].title}');
      } else {
        print('No levels found in the response.');
      }
      return levels;
    } else {
      throw Exception('Failed to load levels: ${response.statusCode}');
    }
  }
}

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final LevelsAPI _apiService = LevelsAPI();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syllabus'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<LevelModel>>(
        future: _apiService.getLevels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final levels = snapshot.data!;
            // This is the core part: ListView.builder
            return ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LessonsScreen(levelId: level.id))),
                  title: Text(level.title),
                  // Check for null or other types before using properties
                  // subtitle: Text(level.description),
                );
              },
            );
          } else {
            return const Center(child: Text('No levels found.'));
          }
        },
      ),
    );
  }
}
