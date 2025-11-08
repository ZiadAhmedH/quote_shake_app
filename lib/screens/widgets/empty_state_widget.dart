import 'package:flutter/material.dart';

class EmptyStateWidget extends StatefulWidget {
  const EmptyStateWidget({super.key});

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Icon(
                Icons.phone_android,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Shake your phone',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'to reveal your first quote',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
