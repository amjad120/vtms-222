import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
    final String title;
   final void Function()? onPressed;
  const CustomButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      
      onPressed: onPressed,
      child: Text(title ,style: TextStyle(color: Colors.white), ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.black,
      height: 50,
    );
  }
}
