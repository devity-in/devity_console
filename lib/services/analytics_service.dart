import 'package:devity_console/services/authenticated_api_service.dart';
import 'package:flutter/material.dart';

/// Analytics event types
enum AnalyticsEventType {
  screenView,
  buttonClick,
  formSubmit,
  error,
  search,
  purchase,
  custom,
}

/// Analytics Service
class AnalyticsService {
  final AuthenticatedApiService _apiService;
  bool _isEnabled = true;

  /// Constructor
  AnalyticsService({
    AuthenticatedApiService? apiService,
  }) : _apiService = apiService ?? AuthenticatedApiService();

  /// Enable or disable analytics tracking
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Track a screen view
  Future<void> trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) async {
    await _trackEvent(
      eventType: AnalyticsEventType.screenView,
      eventName: 'screen_view',
      parameters: {
        'screen_name': screenName,
        ...?parameters,
      },
    );
  }

  /// Track a button click
  Future<void> trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? parameters,
  }) async {
    await _trackEvent(
      eventType: AnalyticsEventType.buttonClick,
      eventName: 'button_click',
      parameters: {
        'button_name': buttonName,
        if (screenName != null) 'screen_name': screenName,
        ...?parameters,
      },
    );
  }

  /// Track a form submission
  Future<void> trackFormSubmit({
    required String formName,
    bool success = true,
    Map<String, dynamic>? parameters,
  }) async {
    await _trackEvent(
      eventType: AnalyticsEventType.formSubmit,
      eventName: 'form_submit',
      parameters: {
        'form_name': formName,
        'success': success,
        ...?parameters,
      },
    );
  }

  /// Track an error
  Future<void> trackError({
    required String errorMessage,
    String? errorCode,
    String? stackTrace,
    Map<String, dynamic>? parameters,
  }) async {
    await _trackEvent(
      eventType: AnalyticsEventType.error,
      eventName: 'error',
      parameters: {
        'error_message': errorMessage,
        if (errorCode != null) 'error_code': errorCode,
        if (stackTrace != null) 'stack_trace': stackTrace,
        ...?parameters,
      },
    );
  }

  /// Track a search event
  Future<void> trackSearch({
    required String searchTerm,
    String? category,
    Map<String, dynamic>? parameters,
  }) async {
    await _trackEvent(
      eventType: AnalyticsEventType.search,
      eventName: 'search',
      parameters: {
        'search_term': searchTerm,
        if (category != null) 'category': category,
        ...?parameters,
      },
    );
  }

  /// Track a purchase event
  Future<void> trackPurchase({
    required String itemId,
    required double amount,
    String? currency,
    Map<String, dynamic>? parameters,
  }) async {
    await _trackEvent(
      eventType: AnalyticsEventType.purchase,
      eventName: 'purchase',
      parameters: {
        'item_id': itemId,
        'amount': amount,
        if (currency != null) 'currency': currency,
        ...?parameters,
      },
    );
  }

  /// Track a custom event
  Future<void> trackCustomEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    await _trackEvent(
      eventType: AnalyticsEventType.custom,
      eventName: eventName,
      parameters: parameters,
    );
  }

  /// Internal method to track events
  Future<void> _trackEvent({
    required AnalyticsEventType eventType,
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    if (!_isEnabled) return;

    try {
      final eventData = {
        'event_type': eventType.name,
        'event_name': eventName,
        'parameters': parameters,
        'timestamp': DateTime.now().toIso8601String(),
        'platform': 'flutter',
      };

      await _apiService.post(
        '/analytics/track',
        data: eventData,
      );
    } catch (e) {
      debugPrint('Analytics tracking error: $e');
      // Don't rethrow to prevent breaking the app flow
    }
  }

  /// Set user properties
  Future<void> setUserProperties({
    required String userId,
    required Map<String, dynamic> properties,
  }) async {
    if (!_isEnabled) return;

    try {
      await _apiService.post(
        '/analytics/user-properties',
        data: {
          'user_id': userId,
          'properties': properties,
        },
      );
    } catch (e) {
      debugPrint('Set user properties error: $e');
    }
  }

  /// Clear user properties
  Future<void> clearUserProperties() async {
    if (!_isEnabled) return;

    try {
      await _apiService.post('/analytics/clear-user-properties');
    } catch (e) {
      debugPrint('Clear user properties error: $e');
    }
  }
}
