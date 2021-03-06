import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_chat/view/login.dart';
import 'package:flutter_chat/view/add_post.dart';

class ChatPage extends StatelessWidget {
  const ChatPage(this.user, {Key? key}) : super(key: key);

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat page'),
        actions: [
          // Logout button
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text('Login info: ${user.email}'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // get post message list (asynchronous process)
              // sort by post date
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  // show all posts
                  return ListView(
                    children: documents.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document['text']),
                          subtitle: Text(document['email']),
                          // user can delete their own posts
                          trailing: document['email'] == user.email
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(document.id)
                                        .delete();
                                  },
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                }
                return const Center(
                  child: Text('Loading...'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // move to post screen
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return AddPostPage(user);
          }));
        },
      ),
    );
  }
}
