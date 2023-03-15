import 'dart:io';
import 'package:chat_app/view/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/screens/home.dart';

class AuthMethod {
  void signUp(
      {required String email,
      required File image,
      required String password,
      required BuildContext ctx,
      @required String? username}) async {
    String message = "";
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(userCredential.user!.uid);
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        "username": username,
        "password": password,
        "image_url": url,
      });
      Get.off(() => SignIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (image == null) {}
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        // backgroundColor: Theme.of(ctx).colorScheme.error,
        backgroundColor: Colors.black,
      ));
    } catch (e) {
      print(e);
    }
  }

  void logIn({
    required String email,
    required String password,
    required BuildContext ctx,
  }) async {
    String message = "";
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.off(() => Home());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        // backgroundColor: Theme.of(ctx).colorScheme.error,
        backgroundColor: Colors.black,
      ));
    }
  }
}
