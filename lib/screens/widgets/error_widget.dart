import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String error;

  const ErrorStateWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, color: Colors.red.withOpacity(0.7), size: 48),
        const SizedBox(height: 16),
        Text(
          'Something went wrong',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          error,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
