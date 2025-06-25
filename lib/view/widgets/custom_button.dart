import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;
  final String label;
  final double? size;

  const CustomButton(
      {super.key, required this.color, this.onPressed, required this.label, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 300,
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
          textAlign: TextAlign.center,
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: AllowedColors.white),
        ),
      ),
    );
  }
}
