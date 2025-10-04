import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:alifbee/login.dart';
import 'package:alifbee/Course.dart';

// Secure storage instance to retrieve the authentication token
const storage = FlutterSecureStorage();

// 1. Updated Data Model Class
// This class now reflects the new, higher-level course structure.
class Level {
  final int id;
  final String slug;
  final String title;
  final String description;
  final int order;

  Level({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.order,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      description: json['description'],
      order: json['order'],
    );
  }
}

// 2. Levelsnew Screen Widget
class Levelsnew extends StatefulWidget {
  const Levelsnew({super.key});

  @override
  State<Levelsnew> createState() => _LevelsnewState();
}

class Syllabus {
  final List levels;
  final List courses;
  final List lessons;
  final List targets;

  Syllabus(
      {required this.levels,
      required this.courses,
      required this.lessons,
      required this.targets});
}



class _LevelsnewState extends State<Levelsnew> {
  // State variables to manage the data fetching process
  bool _isLoading = true;
  List<Level> _levelsnew = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Start fetching levelsnew when the screen is initialized
    _fetchLevelsnew();
  }

  Future<void> _fetchLevelsnew() async {
    final String? token = await storage.read(key: 'jwt_token');

    // DEBUGGING: Print the token to check if it's being retrieved
    print('Token from storage: $token');

    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Authentication token not found. Please log in again.';
      });
      return;
    }

    // The API URL provided by the user
    final Uri apiUrl = Uri.parse(
        'https://dev02.arabeeworld.com/api/v5/syllabus/get_syllabus?environment=prod');

    try {
      final response = await http.get(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token  $token',
        },
      );

      // DEBUGGING: Print the status and body of the API response
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> levelsnewJson = responseData['body'];

        setState(() {
          _levelsnew =
              levelsnewJson.map((json) => Level.fromJson(json)).toList();
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        print(
            'Unauthorized: Token may be invalid or expired. errrrrooooorrrrrrr');
        // If the token is unauthorized, redirect to the login page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load levelsnew: ${response.statusCode}\n\n'
              'Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syllabus'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _levelsnew.length,
                    itemBuilder: (context, index) {
                      final level = _levelsnew[index];
                      return LevelTile(level: level);
                    },
                  ),
                ),
    );
  }
}

// 3. Custom Widget for each Level in the list.
class LevelTile extends StatelessWidget {
  final Level level;

  const LevelTile({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      // Use InkWell to make the entire card tappable and give it a ripple effect.
      child: InkWell(
        onTap: () {
          // Add your navigation logic here
          print('Tapped on level: ${level.title}');
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xfff0eef0),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        level.title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          level.description,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
