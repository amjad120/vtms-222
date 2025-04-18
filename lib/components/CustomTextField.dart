import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText, required this.mycontroller, required this.validator});
  final String hintText;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      validator: validator ,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: hintText,
          filled: true,
          fillColor: Color.fromARGB(255, 235, 232, 232),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 235, 232, 232),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 235, 232, 232),
            ),
          )),
    );
  }
}
