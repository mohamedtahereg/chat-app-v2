import 'package:chat_app/view/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui_models/messageBubble.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference users = FirebaseFirestore.instance.collection('chat');
  final controller = TextEditingController();
  String messageI = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6c63ff),
        title: const Text("Chat"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              underline: Container(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("logout")
                    ],
                  ),
                  value: "logout",
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  FirebaseAuth.instance.signOut();
                  Get.offAll(() => SignIn());
                }
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chat")
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(15),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final user = FirebaseAuth.instance.currentUser!.uid;

                    return MessageBubble(
                      isMe: '${docs[index]['userId']}' == user,
                      userImage: "${docs[index]['user_image']}",
                      userName: '${docs[index]['username']}',
                      message: '${docs[index]['text']}',
                      key: ValueKey("sadadas"),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      if (value.isEmpty) {
                        return;
                      } else {
                        submitMethod();
                      }
                    },
                    onChanged: (value) {
                      messageI = value;
                    },
                    controller: controller,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                    cursorColor: const Color(0xff6c63ff),
                    decoration: InputDecoration(
                      focusColor: const Color(0xff6c63ff),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xff6c63ff),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xff6c63ff),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xff6c63ff),
                        ),
                      ),
                      label: const Text(
                        "Send a message",
                        style: TextStyle(fontSize: 17),
                      ),
                      labelStyle: const TextStyle(
                        color: Color(0xff6c63ff),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (messageI.isEmpty) {
                        return;
                      } else {
                        submitMethod();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xff6c63ff),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitMethod() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final userData =
        await FirebaseFirestore.instance.collection("users").doc(user).get();
    users.add({
      "text": messageI,
      "createdAt": Timestamp.now(),
      "username": userData['username'],
      "userId": user,
      "user_image": userData['image_url'],
    });
    FocusScope.of(context).unfocus();
    controller.clear();
    messageI = "";
  }
}
