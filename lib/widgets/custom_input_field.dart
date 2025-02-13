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
          hintStyle: TextStyle(color: Colors.white54)),
    );
  }
}

class customTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  customTextField({
    required this.onEditingComplete,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(30, 29, 37, 1.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(
            icon,
            color: Colors.white54,
          )),
    );
  }
}
