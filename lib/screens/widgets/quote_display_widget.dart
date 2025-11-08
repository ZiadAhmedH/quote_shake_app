import 'package:flutter/material.dart';
import 'package:shake_quote_app/models/qoute_model.dart';

class QuoteDisplayWidget extends StatelessWidget {
  final Quote quote;

  const QuoteDisplayWidget({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quote Text with Shimmer Effect
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.8),
                Colors.white,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            quote.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),

        // Animated Divider
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Container(
              height: 2,
              width: 60 * value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.3),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Author
        Text(
          '— ${quote.author}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
