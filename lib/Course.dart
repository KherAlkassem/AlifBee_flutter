import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alifbee/levels.dart';
import 'package:alifbee/targets.dart';
import 'package:alifbee/loader.dart';

class CourseModel {
  final int id;
  final String slug;
  final String language;
  final String icon;
  final int isNew;
  final String title;
  final String description;
  final int order;
  final int levelCount;

  CourseModel({
    required this.id,
    required this.slug,
    required this.language,
    required this.icon,
    required this.isNew,
    required this.title,
    required this.description,
    required this.order,
    required this.levelCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      // Use the null-coalescing operator (??) to provide a default value if null
      id: json['id'] as int,
      slug: json['slug'] as String,
      language: json['language'] as String,
      icon: json['icon'] as String,
      isNew: json['is_new'] ?? 0, // Provide a default of 0 if 'is_new' is null
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] ?? 0, // Provide a default of 0 if 'order' is null
      levelCount: json['level_count'] ??
          0, // Provide a default of 0 if 'level_count' is null
    );
  }
}

class CourseModelAPI {
  Future<List<CourseModel>> getCourseModel() async {
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

      // Access the 'body' map first
      final Map<String, dynamic> responseBody = jsonResponse['body'];

      // Now, get the 'syllabus' list from inside the 'body' map
      final List<dynamic> coursesList = responseBody['courses'];

      // Now you can safely map over the list
      final data = coursesList.map((e) => CourseModel.fromJson(e)).toList();
      print("===================");
      print(data[0].title);

      print("===================");
      return data;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception(
          'Failed to load courses with status: ${response.statusCode}');
    }
  }
}

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final CourseModelAPI _apiService = CourseModelAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syllabus'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CourseModel>>(
        future: _apiService.getCourseModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final courses = snapshot.data!;
            // This is the core part: ListView.builder
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LevelsScreen())),
                  title: Text(course.title),
                  // Check for null or other types before using properties
                  subtitle: Text(course.description),
                  leading: course.icon.isNotEmpty
                      ? Image.network(course.icon)
                      : const Icon(Icons.school),
                );
              },
            );
          } else {
            return const Center(child: Text('No courses found.'));
          }
        },
      ),
    );
  }
}
