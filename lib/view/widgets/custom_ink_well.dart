import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const CustomInkWell({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: Center(
        child: InkWell(
          onTap: onTap,
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AllowedColors.red),
          ),
        ),
      ),
    );
  }
}
