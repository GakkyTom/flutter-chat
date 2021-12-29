import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/view/login.dart';

class ChatPage extends StatelessWidget {
  const ChatPage(this.user, {Key? key}) : super(key: key);

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            },
          ),
        ],
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
