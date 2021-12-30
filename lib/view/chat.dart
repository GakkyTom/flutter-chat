import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_chat/main.dart';
import 'package:flutter_chat/view/login.dart';
import 'package:flutter_chat/view/add_post.dart';

// Use ConsumerWidget to pass data through provider
class ChatPage extends ConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // this is user state
    // ref) https://zenn.dev/riscait/books/flutter-riverpod-practical-introduction/viewer/migrate-to-v1#stateprovider%E3%82%92%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%93%E3%81%A0%E6%99%82%E3%81%AE%E6%88%BB%E3%82%8A%E5%80%A4%E3%81%8Cstatenotifierprovider%E3%81%A8%E7%B5%B1%E4%B8%80%E3%81%95%E3%82%8C%E3%81%BE%E3%81%97%E3%81%9F%E3%80%82
    final user = ref.watch(userProvider)!;
    final AsyncValue<QuerySnapshot> asyncPostsQuery =
        ref.watch(postsQueryProvider);

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
            child: asyncPostsQuery.when(
              data: (QuerySnapshot query) {
                return ListView(
                  children: query.docs.map((document) {
                    return Card(
                      child: ListTile(
                        title: Text(document['text']),
                        subtitle: Text(document['email']),
                        trailing: document['email'] == user.email
                            ? IconButton(
                                icon: Icon(Icons.delete),
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
              },
              loading: () {
                return const Center(
                  child: Text('Loading...'),
                );
              },
              error: (e, stackTrace) {
                return Center(
                  child: Text(e.toString()),
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
            return const AddPostPage();
          }));
        },
      ),
    );
  }
}
