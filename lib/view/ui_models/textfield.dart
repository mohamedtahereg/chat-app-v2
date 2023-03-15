import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    super.key,
    @required this.textFieldIcon,
    required this.fieldName,
    required this.onSaved,
    this.obsecure = false,
    required this.txtFormFieldKey,
    this.txtFieldValidater,
  });
  Key txtFormFieldKey;
  bool? obsecure;
  Function(String?)? onSaved;
  Icon? textFieldIcon;
  String? fieldName;
  String? Function(String?)? txtFieldValidater;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        key: key,
        obscureText: obsecure!,
        onChanged: onSaved,
        validator: txtFieldValidater,
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
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 25, right: 15),
              child: textFieldIcon),
          prefixIconColor: const Color(0xff6c63ff),
        ),
      ),
    );
  }
}
