import 'package:shake_quote_app/models/qoute_model.dart';

class ShakeState {
  final int shakeCount;
  final Quote? currentQuote;
  final bool isLoading;
  final String? error;

  const ShakeState({
    this.shakeCount = 0,
    this.currentQuote,
    this.isLoading = false,
    this.error,
  });

  ShakeState copyWith({
    int? shakeCount,
    Quote? currentQuote,
    bool? isLoading,
    String? error,
  }) {
    return ShakeState(
      shakeCount: shakeCount ?? this.shakeCount,
      currentQuote: currentQuote ?? this.currentQuote,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}