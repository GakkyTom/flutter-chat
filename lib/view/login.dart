import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_chat/main.dart';
import 'package:flutter_chat/view/chat.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String email = ref.watch(emailProvider);
    String password = ref.watch(passwordProvider);
    String infoText = ref.watch(infoTextProvider);

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
                  ref.read(emailProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 8),
              // Password
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Password (over 6 charactor)"),
                obscureText: true,
                onChanged: (String value) {
                  ref.read(passwordProvider.notifier).state = value;
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
                            email: email, password: password);

                    ref.read(userProvider.notifier).state = result.user;

                    await Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const ChatPage();
                    }));
                  } catch (e) {
                    ref.read(infoTextProvider.notifier).state =
                        "Fail to register: ${e.toString()}";
                  }
                },
                child: const Text('Register User'),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const ChatPage();
                      }));
                    } catch (e) {
                      ref.read(infoTextProvider.notifier).state =
                          "Failed to Login";
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
