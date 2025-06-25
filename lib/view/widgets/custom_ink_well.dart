import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final bool underline;

  const CustomInkWell(
      {super.key, required this.label, this.onTap, required this.color, this.underline = false});

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
                color: color,
                decoration: underline ? TextDecoration.underline : null),
          ),
        ),
      ),
    );
  }
}
