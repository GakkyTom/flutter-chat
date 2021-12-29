import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatelessWidget {
  const ChatPage(this.user, {Key? key}) : super(key: key);

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat page'),
      ),
      body: Center(
        child: Text('Login info: ${user.email}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // move to post screen
          // await Navigator.of(context).push(
          //  MaterialPageRoute(builder: (context) {
          //    return AddPostPage()();
          //  }))
        },
      ),
    );
  }
}
