import 'package:chat_app/sevices/auth.dart';
import 'package:chat_app/view/screens/home.dart';
import 'package:chat_app/view/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../ui_models/textfield.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? eemail, pass;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isloading = false;

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
                  child: SvgPicture.asset("assets/sign-up.svg"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 23),
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  txtFormFieldKey: ValueKey("email"),
                  txtFieldValidater: (val) {
                    if (val!.length < 3) {
                      return "cant be less than 3 letters";
                    }
                    if (val.isEmpty) {
                      return "Please enter email address";
                    }
                    if (!val.contains('@')) {
                      return "Your email dosent contain '@' sign";
                    }
                    return null;
                  },
                  textFieldIcon: const Icon(Icons.email_outlined),
                  fieldName: "Email",
                  onSaved: (e1) {
                    eemail = e1;
                  },
                ),
                MyTextField(
                  txtFormFieldKey: ValueKey("password"),
                  txtFieldValidater: (val) {
                    if (val!.length < 3) {
                      return "cant be less than 3 letters";
                    }
                    return null;
                  },
                  textFieldIcon: const Icon(Icons.password),
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
                    setState(() {
                      FocusScope.of(context).unfocus();
                      isloading = true;
                      AuthMethod().logIn(
                        ctx: context,
                        email: eemail!,
                        password: pass!,
                      );
                      isloading = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xff6c63ff),
                    ),
                    height: 70,
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
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
                      const Text("you dont have Account ?"),
                      InkWell(
                        onTap: () {
                          Get.off(() => SignUp());
                        },
                        child: const Text(
                          "  Register",
                          style: TextStyle(
                            color: Color(0xff6c63ff),
                            fontWeight: FontWeight.w700,
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
