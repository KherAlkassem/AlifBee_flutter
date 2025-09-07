import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                icon: const Icon(Icons.cancel), onPressed: () {},
                // onPressed: () {
                //   Navigator.pop(context);
                // }
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your credentials",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Username or Email',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: FocusNode(),
                        obscureText: true,
                        decoration: InputDecoration(
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
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.underline),
              )),
          SizedBox(
            height: 180,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () {},
                  child: Text("Log in"),
                  style: FilledButton.styleFrom(backgroundColor: Colors.amber)),
            ),
          ),
          SafeArea(
              child: SizedBox(
            height: 20,
          ))
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
