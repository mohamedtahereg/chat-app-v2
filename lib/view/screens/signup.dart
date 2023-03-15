import 'dart:io';

import 'package:chat_app/view/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../sevices/auth.dart';
import '../ui_models/textfield.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? eemail, pass, username;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
/////////////////////////        كود ال بيركر    //////////////////////////
  bool isloading = false;
  File? image;
  final imagePiker = ImagePicker();

  uploadImageFromCamera() async {
    var pikedImage = await imagePiker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 100,
    );
    if (pikedImage != null) {
      setState(() {
        image = File(pikedImage.path);
      });
    } else {}
  }

  uploadImageFromPhotos() async {
    var pikedImage = await imagePiker.pickImage(source: ImageSource.gallery);
    if (pikedImage != null) {
      setState(() {
        image = File(pikedImage.path);
      });
    } else {}
  }

////////////////////////////    image picker     ////////////////////////////
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Form(
            key: formState,
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        image == null
                            ? const CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/512/25/25634.png"),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(image!),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  uploadImageFromPhotos();
                                },
                                icon: const Icon(Icons.photo)),
                            IconButton(
                                onPressed: () {
                                  uploadImageFromCamera();
                                },
                                icon: const Icon(Icons.camera_alt)),
                          ],
                        ),
                      ]),
                ),
                MyTextField(
                  textFieldIcon: const Icon(Icons.person_2_outlined),
                  txtFieldValidater: (val) {
                    if (val!.isEmpty) {
                      return "Please enter username";
                    }
                    if (val.length < 3) {
                      return "username cant be less than 3 letters";
                    }

                    return null;
                  },
                  txtFormFieldKey: const ValueKey("email"),
                  fieldName: "user name",
                  onSaved: (e1) {
                    username = e1;
                  },
                ),
                MyTextField(
                  textFieldIcon: const Icon(Icons.password),
                  txtFieldValidater: (val) {
                    if (val!.isEmpty) {
                      return "Please enter email address";
                    }
                    if (val.length < 3) {
                      return "cant be less than 3 letters";
                    }
                    if (!val.contains('@')) {
                      return "Your email dosent contain '@' sign";
                    }
                    return null;
                  },
                  txtFormFieldKey: const ValueKey("email"),
                  fieldName: "Email",
                  onSaved: (e1) {
                    eemail = e1;
                  },
                ),
                MyTextField(
                  txtFormFieldKey: const ValueKey("password"),
                  textFieldIcon: const Icon(Icons.password),
                  txtFieldValidater: (val) {
                    if (val!.isEmpty) {
                      return "Please enter password";
                    }
                    if (val.length < 3) {
                      return "password cant be less than 3 letters";
                    }

                    return null;
                  },
                  fieldName: "Password",
                  obsecure: true,
                  onSaved: (p0) {
                    pass = p0;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (formState.currentState!.validate()) {
                      setState(() {
                        //الكود دا بيخليك تقفل الكيبورد على طول
                        FocusScope.of(context).unfocus();
                        isloading = true;
                        if (image == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please pick image"),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          AuthMethod().signUp(
                            image: image!,
                            ctx: context,
                            username: username,
                            email: eemail!,
                            password: pass!,
                          );
                        }
                        isloading = false;
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xff6c63ff),
                    ),
                    height: 70,
                    child: isloading == true
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("if you have Account "),
                      InkWell(
                        onTap: () {
                          //

                          Get.off(() => SignIn());
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "  Click Here",
                            style: TextStyle(
                              color: Color(0xff6c63ff),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
