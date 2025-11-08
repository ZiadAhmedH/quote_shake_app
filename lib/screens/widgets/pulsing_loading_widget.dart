import 'package:flutter/material.dart';

class PulsingLoadingWidget extends StatefulWidget {
  const PulsingLoadingWidget({super.key});

  @override
  State<PulsingLoadingWidget> createState() => _PulsingLoadingWidgetState();
}

class _PulsingLoadingWidgetState extends State<PulsingLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
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
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Icon(
                  Icons.auto_awesome,
                  size: 60,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Loading...',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
        ),
      ],
    );
  }
}
