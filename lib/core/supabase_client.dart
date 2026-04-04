import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientManager {
  static late SupabaseClient _client;
  static bool _initialized = false;
  static bool _hasInternetConnection = true;
  static int _initAttempts = 0;
  static const int _maxInitRetries = 3;
  static const Duration _initTimeout = Duration(seconds: 10);

  static const String _supabaseUrl = 'https://xbbxhkemzrmdsyyclgya.supabase.co';
  static const String _supabaseAnonKey =
      'sb_publishable_fTjFumSU_n7cDxB8wrORpw_J9S10QP_';

  static Future<bool> _checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      _hasInternetConnection = connectivityResult != ConnectivityResult.none;
      debugPrint(
        'Network status: ${_hasInternetConnection ? "Connected" : "Disconnected"}',
      );
      return _hasInternetConnection;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // Check network connectivity first
      final hasConnection = await _checkConnectivity();
      if (!hasConnection) {
        debugPrint(
          'No internet connection. Supabase will retry when connection is available.',
        );
        _listenToConnectivityChanges();
        return;
      }

      debugPrint('Initializing Supabase...');

      // Try to initialize with timeout
      await _initializeWithRetry();
      _initialized = true;
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Supabase: $e');
      _initialized = false;
      _listenToConnectivityChanges();
    }
  }

  static Future<void> _initializeWithRetry() async {
    while (_initAttempts < _maxInitRetries) {
      try {
        _initAttempts++;
        debugPrint(
          'Supabase initialization attempt $_initAttempts/$_maxInitRetries',
        );

        await Supabase.initialize(
          url: _supabaseUrl,
          anonKey: _supabaseAnonKey,
        ).timeout(
          _initTimeout,
          onTimeout: () {
            throw TimeoutException(
              'Supabase initialization timed out after ${_initTimeout.inSeconds}s',
            );
          },
        );

        _client = Supabase.instance.client;
        _initAttempts = 0; // Reset on success
        return;
      } on TimeoutException catch (e) {
        debugPrint(
          'Initialization timeout (attempt $_initAttempts/$_maxInitRetries): $e',
        );
        if (_initAttempts < _maxInitRetries) {
          await Future.delayed(
            Duration(seconds: _initAttempts * 2),
          ); // Exponential backoff
        } else {
          rethrow;
        }
      } catch (e) {
        debugPrint(
          'Initialization error (attempt $_initAttempts/$_maxInitRetries): $e',
        );
        if (_initAttempts < _maxInitRetries) {
          await Future.delayed(
            Duration(seconds: _initAttempts * 2),
          ); // Exponential backoff
        } else {
          rethrow;
        }
      }
    }
  }

  static void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((result) async {
      final connected = result != ConnectivityResult.none;
      debugPrint(
        'Connectivity changed: ${connected ? "Connected" : "Disconnected"}',
      );
      _hasInternetConnection = connected;

      if (connected && !_initialized) {
        debugPrint('Internet restored. Retrying Supabase initialization...');
        try {
          await initialize();
        } catch (e) {
          debugPrint('Failed to initialize on reconnection: $e');
        }
      }
    });
  }

  static SupabaseClient get client {
    if (!_initialized) {
      throw Exception('Supabase not initialized. Check network connectivity.');
    }
    return _client;
  }

  static String get userId {
    if (!_initialized) return '';
    return _client.auth.currentUser?.id ?? '';
  }

  static bool get isAuthenticated {
    if (!_initialized) return false;
    return _client.auth.currentUser != null;
  }

  static bool get isInitialized => _initialized;
  static bool get isConnected => _hasInternetConnection;
}
