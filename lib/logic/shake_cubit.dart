import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_quote_app/logic/sake_state.dart';
import 'package:shake_quote_app/services/communication_service.dart';
import 'package:shake_quote_app/services/looger.dart';
import 'package:shake_quote_app/services/quote_service.dart';


class ShakeCubit extends Cubit<ShakeState> {
  final QuoteService _quoteService;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  ShakeCubit({QuoteService? quoteService})
    : _quoteService = quoteService ?? QuoteService(),
      super(const ShakeState()) {
    AppLogger.info('🎲 ShakeCubit initialized');
  }

  void startListening() {
    AppLogger.info('👂 Starting shake detection listener...');

    _subscription =
        ShakeDetectorStream.shakeEvents(
          shakeThresholdG: 2.7,
          minIntervalMs: 800,
        ).listen(
          (event) {
            final count = event['count'] as int? ?? state.shakeCount;
            final gForce = event['gForce'] as double?;

            AppLogger.info(
              '📳 SHAKE DETECTED! Count: $count, gForce: ${gForce?.toStringAsFixed(2)}',
            );

            emit(state.copyWith(shakeCount: count));
            fetchNewQuote();
          },
          onError: (e) {
            AppLogger.error('❌ Shake detection error', e);
            emit(state.copyWith(error: e.toString()));
          },
          cancelOnError: false,
        );
  }

  Future<void> fetchNewQuote() async {
    AppLogger.info('⏳ Loading new quote...');
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final quote = await _quoteService.fetchRandomQuote();

      AppLogger.info('✅ Quote loaded successfully');
      emit(state.copyWith(currentQuote: quote, isLoading: false));
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to fetch quote', e, stackTrace);
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  @override
  Future<void> close() {
    AppLogger.warning('🔌 Closing ShakeCubit, cancelling subscriptions');
    _subscription?.cancel();
    _quoteService.cancelRequests();
    return super.close();
  }
}
