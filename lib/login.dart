import 'dart:convert';
import 'package:alifbee/Course.dart';
// import 'package:alifbee/LevelsNew.dart';
import 'package:alifbee/levels.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:alifbee/loader.dart';

const storage = FlutterSecureStorage();

Future<String> _getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor!;
    }
  } catch (e) {
    print('Failed to get device info: $e');
  }
  return "unknown_device";
}

Future<String> loginUser(
    String email, String password, BuildContext context) async {
  final String deviceId = await _getDeviceInfo();

  // Use a fallback to ensure the platform is always a valid value.
  final String platform =
      Platform.isAndroid ? "android" : (Platform.isIOS ? "ios" : "unknown");

  final Uri apiUrl =
      Uri.parse('https://dev02.arabeeworld.com/api/v2/auth/signin');

  try {
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'deviceId': deviceId,
        'platform': platform,
      }),
    );

    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    // Check if the response is JSON before trying to decode
    final String contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('application/json')) {
      return 'Unexpected API response format. Received HTML, expected JSON.\n\n'
          'Status: ${response.statusCode}\n\n'
          'Response Body:\n${response.body}';
    }

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      final String token = responseData['body']['token'];
      final String refreshToken = responseData['body']['refreshToken'];

      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'refresh_token', value: refreshToken);

      final SyllabusAPI syllabusAPI = SyllabusAPI();
      final Syllabus syllabusData = await syllabusAPI.getFullSyllabus();

      // Navigate only on successful login
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            // builder: (context) => const Levelsnew(),
            // builder: (context) => const CoursesScreen(),
            builder: (context) => const CoursesScreen(),
          ),
        );
      }
      return 'Login successful!';
    } else {
      return responseData['error'] ??
          'Login failed. Please check your credentials.';
    }
  } catch (e) {
    return 'An error occurred: $e';
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Log in',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  )),
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your credentials",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                TextField(
                  controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Username or Email',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _passwordcontroller,
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.remove_red_eye),
                          border: UnderlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                  color: Colors.black, decoration: TextDecoration.underline),
            ),
          ),
          const Spacer(),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        final String email = _emailcontroller.text;
                        final String password = _passwordcontroller.text;
                        final String result =
                            await loginUser(email, password, context);
                        if (result != 'Login successful!') {
                          setState(() {
                            _isLoading = false;
                            _errorMessage = result;
                          });
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Log in"),
                style: FilledButton.styleFrom(
                  backgroundColor: _isLoading ? Colors.grey : Colors.amber,
                ),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
