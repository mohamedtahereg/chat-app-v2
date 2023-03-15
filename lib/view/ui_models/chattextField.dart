import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  ChatTextField({
    super.key,
    required this.textFieldIcon,
    required this.fieldName,
    required this.onSaved,
    this.obsecure = false,
    required this.click,
  });

  bool? obsecure;
  Function(String?)? onSaved;
  Icon? textFieldIcon;
  String? fieldName;
  void Function()? click;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obsecure!,
        onFieldSubmitted: onSaved,
        validator: (value) {
          if (value!.length > 100) {
            return "You cant writer more than 100 letter";
          }
          if (value.length < 3) {
            return "value cant be 2 letters";
          }
          return null;
        },
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
          label: Text(
            fieldName!,
            style: const TextStyle(fontSize: 17),
          ),
          labelStyle: const TextStyle(
            color: Color(0xff6c63ff),
          ),
          suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 25, right: 15),
              child: InkWell(onTap: click, child: textFieldIcon)),
          suffixIconColor: const Color(0xff6c63ff),
        ),
      ),
    );
  }
}
