import 'dart:math';
import 'package:dio/dio.dart';
import 'package:shake_quote_app/models/qoute_model.dart';
import 'package:shake_quote_app/services/looger.dart';

class QuoteService {
  final Dio _dio;
  final Random _random = Random();
  static const _baseUrl = 'https://favqs.com/api';
  static const _apiKey = 'YOUR_API_KEY_HERE';

  QuoteService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 3),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Token token="$_apiKey"',
              },
            ),
          ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.info('🌐 REQUEST: ${options.method} ${options.uri}');
          AppLogger.debug('Headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info(
            '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
          );
          AppLogger.debug('Data: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.error(
            '❌ ERROR: ${error.requestOptions.method} ${error.requestOptions.uri}',
            error,
          );
          return handler.next(error);
        },
      ),
    );
  }

  Future<Quote> fetchRandomQuote() async {
    try {
      AppLogger.info('📖 Fetching random quote...');

      // Generate random page number (1-10 for variety)
      final randomPage = _random.nextInt(10) + 1;

      final response = await _dio.get(
        '/quotes',
        queryParameters: {'page': randomPage},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Extract quotes array
        final quotesList = data['quotes'] as List<dynamic>;

        if (quotesList.isEmpty) {
          throw Exception('No quotes available');
        }

        // Pick a random quote from the list
        final randomIndex = _random.nextInt(quotesList.length);
        final quoteData = quotesList[randomIndex] as Map<String, dynamic>;

        final quote = Quote.fromJson(quoteData);

        AppLogger.info('✨ Quote fetched: "${quote.text}" - ${quote.author}');
        return quote;
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } on DioException catch (e) {
      AppLogger.error('🚨 DioException occurred', e);

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Check your internet.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server took too long to respond.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Invalid API key.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Try again later.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('💥 Unexpected error in fetchRandomQuote', e, stackTrace);
      throw Exception('Unexpected error: $e');
    }
  }

  void cancelRequests() {
    AppLogger.warning('🛑 Cancelling all pending requests');
    _dio.close(force: true);
  }
}
