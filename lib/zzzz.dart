import "dart:convert" as convert;
import 'package:http/http.dart' as http;

/// Model class for a Course (mapped from API response)
class UserModel {
  final int userId;
  final int id;
  final String title;
  final String newTitle;
  UserModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.newTitle,
  });

  /// Factory constructor to build a CourseModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"] ?? 0,
      id: json["name"] ?? 0,
      title: json["title"] ?? "",
      newTitle: json["body"] ?? "",
    );
  }
}

class CoursesAPI {
  Future<List<UserModel>> getCourses() async {
    const url = "https://jsonplaceholder.typicode.com/posts";

    try {
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final List jsonResponse = convert.jsonDecode(response.body);
        final data = jsonResponse.map((e) => UserModel.fromJson(e)).toList();
        // Debugging: Print the title of the first course

        print(data[0].title); // Debugging: Print the title of the first course
        return data;
      } else {
        throw Exception("Error fetching courses: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception in getCourses: $e");
      throw Exception("Failed to load courses: $e");
    }
  }
}
