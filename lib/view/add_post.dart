import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_chat/model/user.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context);
    final User user = userModel.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message:'),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:
                  MainAxisSize.min, // to contents in center vertically
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'post message'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onChanged: (String value) {
                    setState(() {
                      messageText = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Post'),
                      onPressed: () async {
                        final date = DateTime.now().toLocal().toIso8601String();
                        final email = user.email;

                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc() // auto-generate for document ID
                            .set({
                          'text': messageText,
                          'email': email,
                          'date': date
                        });

                        // back to chat screen
                        Navigator.of(context).pop();
                      },
                    ))
              ],
            )),
      ),
    );
  }
}
