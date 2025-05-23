import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.purple[400],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}