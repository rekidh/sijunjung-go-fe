import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;

  final bool isLoading;
  final Widget? child;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 60,
    this.isLoading = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF55B6E7), // SGO Blue
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF55B6E7).withOpacity(0.6),
          elevation: 10,
          shadowColor: const Color(0xFF55B6E7).withAlpha(100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : child ??
                Text(
                  text.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'SofiaPro',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1.2,
                  ),
                ),
      ),
    );
  }
}
