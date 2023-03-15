import 'package:chat_app/view/screens/signin.dart';
import 'package:chat_app/view/screens/signup.dart';
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
      // drawer: Drawer(
      //   // backgroundColor: appbarGreen,
      //   width: 280,
      //   child: Column(
      //     children: [
      //       const UserAccountsDrawerHeader(
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //             image: NetworkImage(
      //                 "https://cdn.pixabay.com/photo/2017/08/30/01/05/milky-way-2695569__480.jpg"),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         accountName: Text("Moahemd"),
      //         accountEmail: Text("MohTaher@gmail.com"),
      //         currentAccountPicture: CircleAvatar(
      //           radius: 55,
      //           backgroundImage: NetworkImage(
      //               "https://scontent.fcai19-1.fna.fbcdn.net/v/t39.30808-6/274165476_1969695713215018_4844269714640165981_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=2RQzwRt5cVkAX8X8jX6&_nc_ht=scontent.fcai19-1.fna&oh=00_AfAW8BdLpmdnysioFXErEDDp-zuY1Ye702JGg4Ib5Q7tcA&oe=6414152F"),
      //         ),
      //       ),
      //       ListTile(
      //         title: const Text("Home"),
      //         leading: const Icon(Icons.home),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: const Text("My Products"),
      //         leading: const Icon(Icons.shopping_bag),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: const Text("About"),
      //         leading: const Icon(Icons.help_center),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: const Text("log out"),
      //         leading: const Icon(Icons.exit_to_app),
      //         onTap: () {},
      //       ),
      //       Expanded(
      //         child: Container(),
      //       ),
      //       const Padding(
      //         padding: EdgeInsets.all(14.0),
      //         child: Text(
      //           "Develped By Mohamed Taher © 2023",
      //           style:
      //               TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
