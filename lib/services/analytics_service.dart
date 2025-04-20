import 'dart:async';
import 'package:devity_console/config/environment.dart';
import 'package:devity_console/models/analytics_event.dart';
import 'package:devity_console/services/analytics_queue_service.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';
import 'package:dio/dio.dart';

/// Analytics Service
class AnalyticsService {
  /// Constructor
  AnalyticsService({
    NetworkService? networkService,
    ErrorHandlerService? errorHandler,
  })  : _networkService = networkService ??
            NetworkService(errorHandler: ErrorHandlerService()),
        _errorHandler = errorHandler ?? ErrorHandlerService();

  /// Network service instance
  final NetworkService _networkService;

  /// Error handler service
  final ErrorHandlerService _errorHandler;

  /// Queue service instance
  late AnalyticsQueueService _queueService;

  /// Whether analytics is enabled
  bool _enabled = Environment.isAnalyticsEnabled;

  /// Initialize the service
  void initialize() {
    _queueService = AnalyticsQueueService();
  }


  /// Send an event
  Future<void> sendEvent(AnalyticsEvent event) async {
    if (!_enabled) return;
    await _queueService.addEvent(event);
    await _processQueue();
  }

  /// Process the queue
  Future<void> _processQueue() async {
    final batch = _queueService.getBatch();
    if (batch.isEmpty) return;

    final successfulEvents = <AnalyticsEvent>[];
    final failedEvents = <AnalyticsEvent>[];

    for (final event in batch) {
      try {
        final response = await _networkService.request(
          Environment.analyticsEndpoint,
          method: 'POST',
          data: event.toJson(),
          headers: {'Content-Type': 'application/json'},
          useCache: false,
        );

        if (response.statusCode == 200) {
          successfulEvents.add(event);
        } else {
          failedEvents.add(event);
        }
      } catch (e) {
        _errorHandler.handleError(e);
        failedEvents.add(event);
      }
    }

    // Remove successful events
    await _queueService.removeProcessedEvents(successfulEvents);

    // Retry failed events
    for (final event in failedEvents) {
      if (event.canRetry) {
        event.incrementRetryCount();
        await _queueService.addEvent(event);
      }
    }
  }

  /// Clear the queue
  Future<void> clearQueue() async {
    await _queueService.clearQueue();
  }

  /// Get the current queue size
  int get queueSize => _queueService.queueSize;

  /// Dispose the service
  void dispose() {
    _networkService.dispose();
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
    await _queueService.addEvent(AnalyticsEvent(
      eventType: eventType,
      eventName: eventName,
      parameters: parameters,
    ));
    await _processQueue();
  }

  /// Set user properties
  Future<void> setUserProperties({
    required String userId,
    required Map<String, dynamic> properties,
  }) async {
    await _queueService.addEvent(AnalyticsEvent(
      eventType: AnalyticsEventType.custom,
      eventName: 'set_user_properties',
      parameters: {
        'user_id': userId,
        'properties': properties,
      },
    ));
    await _processQueue();
  }

  /// Clear user properties
  Future<void> clearUserProperties() async {
    await _queueService.addEvent(AnalyticsEvent(
      eventType: AnalyticsEventType.custom,
      eventName: 'clear_user_properties',
      parameters: {},
    ));
    await _processQueue();
  }
}
