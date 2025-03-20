import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class CustomLoadingButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const CustomLoadingButton(
      {super.key,
      required this.color,
      required this.label,
      this.onPressed,
      required this.loading});

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
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AllowedColors.white,
                ),
              )
            : Text(
                label,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: AllowedColors.white),
              ),
      ),
    );
  }
}
