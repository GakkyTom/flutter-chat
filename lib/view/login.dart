import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat/view/chat.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String newUserEmail = "";

  String newUserPassword = "";

  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Email
              TextFormField(
                decoration: const InputDecoration(labelText: "email address"),
                onChanged: (String value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              // Password
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Password (over 6 charactor)"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              // Register button
              ElevatedButton(
                onPressed: () async {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.createUserWithEmailAndPassword(
                            email: newUserEmail, password: newUserPassword);

                    final User user = result.user!;
                    setState(() {
                      infoText = "Success to register: ${user.email}";
                    });
                  } catch (e) {
                    setState(() {
                      infoText = "Fail to register: ${e.toString()}";
                    });
                  }
                },
                child: const Text('Register User'),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                          email: newUserEmail, password: newUserPassword);
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return ChatPage(result.user!);
                      }));
                    } catch (e) {
                      setState(() {
                        infoText = "Failed to Login";
                      });
                    }
                  },
                ),
              ),
              Text(infoText)
            ],
          ),
        ),
      ),
    );
  }
}
