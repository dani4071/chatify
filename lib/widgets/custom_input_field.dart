import 'package:flutter/material.dart';

class customTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  // final String regEx;
  final String hintText;
  final bool obscureText;


  customTextFormField({
    required this.onSaved,
    // required this.regEx,
    required this.hintText,
    required this.obscureText,
});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.white,
      //// remeber to add a regEx to prevent the user from typing jagones
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54)
      ),
    );
  }


}