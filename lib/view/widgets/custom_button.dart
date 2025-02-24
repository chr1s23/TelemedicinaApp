import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;
  final String label;

  const CustomButton(
      {super.key, required this.color, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
