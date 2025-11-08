import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_quote_app/logic/sake_state.dart';
import 'package:shake_quote_app/logic/shake_cubit.dart';
import 'package:shake_quote_app/screens/widgets/empty_state_widget.dart';
import 'package:shake_quote_app/screens/widgets/error_widget.dart';
import 'package:shake_quote_app/screens/widgets/pulsing_loading_widget.dart';
import 'package:shake_quote_app/screens/widgets/quote_display_widget.dart';

class ShakeHomePage extends StatelessWidget {
  const ShakeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1929), Color(0xFF1a2332), Color(0xFF0A1929)],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<ShakeCubit, ShakeState>(
            builder: (context, state) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      animatedQuoteContent(context, state),

                      const Spacer(flex: 2),

                      _buildBottomSection(state),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget animatedQuoteContent(BuildContext context, ShakeState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildQuoteContent(context, state),
    );
  }

  Widget _buildQuoteContent(BuildContext context, ShakeState state) {
    if (state.isLoading) {
      return const PulsingLoadingWidget(key: ValueKey('loading'));
    }

    if (state.error != null) {
      return ErrorStateWidget(key: const ValueKey('error'), error: state.error!);
    }

    if (state.currentQuote == null) {
      return const EmptyStateWidget(key: ValueKey('empty'));
    }

    return QuoteDisplayWidget(
      key: ValueKey(state.currentQuote!.text),
      quote: state.currentQuote!,
    );
  }

  Widget _buildBottomSection(ShakeState state) {
    return Column(
      children: [
        const SizedBox(height: 24),
        AnimatedOpacity(
          opacity: state.isLoading ? 0.3 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            state.isLoading
                ? 'Fetching wisdom...'
                : 'Shake to discover a new quote',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
