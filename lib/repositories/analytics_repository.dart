import 'package:devity_console/services/analytics_service.dart';

/// Analytics Repository
class AnalyticsRepository {
  final AnalyticsService _analyticsService;

  /// Constructor
  AnalyticsRepository({
    AnalyticsService? analyticsService,
  }) : _analyticsService = analyticsService ?? AnalyticsService();

  /// Enable or disable analytics tracking
  void setEnabled(bool enabled) {
    _analyticsService.setEnabled(enabled);
  }

  /// Track a screen view
  Future<void> trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackScreenView(
      screenName: screenName,
      parameters: parameters,
    );
  }

  /// Track a button click
  Future<void> trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackButtonClick(
      buttonName: buttonName,
      screenName: screenName,
      parameters: parameters,
    );
  }

  /// Track a form submission
  Future<void> trackFormSubmit({
    required String formName,
    bool success = true,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackFormSubmit(
      formName: formName,
      success: success,
      parameters: parameters,
    );
  }

  /// Track an error
  Future<void> trackError({
    required String errorMessage,
    String? errorCode,
    String? stackTrace,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackError(
      errorMessage: errorMessage,
      errorCode: errorCode,
      stackTrace: stackTrace,
      parameters: parameters,
    );
  }

  /// Track a search event
  Future<void> trackSearch({
    required String searchTerm,
    String? category,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackSearch(
      searchTerm: searchTerm,
      category: category,
      parameters: parameters,
    );
  }

  /// Track a purchase event
  Future<void> trackPurchase({
    required String itemId,
    required double amount,
    String? currency,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackPurchase(
      itemId: itemId,
      amount: amount,
      currency: currency,
      parameters: parameters,
    );
  }

  /// Track a custom event
  Future<void> trackCustomEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    await _analyticsService.trackCustomEvent(
      eventName: eventName,
      parameters: parameters,
    );
  }

  /// Set user properties
  Future<void> setUserProperties({
    required String userId,
    required Map<String, dynamic> properties,
  }) async {
    await _analyticsService.setUserProperties(
      userId: userId,
      properties: properties,
    );
  }

  /// Clear user properties
  Future<void> clearUserProperties() async {
    await _analyticsService.clearUserProperties();
  }

  /// Track user authentication
  Future<void> trackUserAuthentication({
    required String userId,
    required bool isLogin,
    String? method,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackCustomEvent(
      eventName: isLogin ? 'user_login' : 'user_logout',
      parameters: {
        'user_id': userId,
        if (method != null) 'method': method,
        ...?parameters,
      },
    );
  }

  /// Track user profile update
  Future<void> trackUserProfileUpdate({
    required String userId,
    required List<String> updatedFields,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackCustomEvent(
      eventName: 'user_profile_update',
      parameters: {
        'user_id': userId,
        'updated_fields': updatedFields,
        ...?parameters,
      },
    );
  }

  /// Track feature usage
  Future<void> trackFeatureUsage({
    required String featureName,
    required String action,
    Map<String, dynamic>? parameters,
  }) async {
    await _analyticsService.trackCustomEvent(
      eventName: 'feature_usage',
      parameters: {
        'feature_name': featureName,
        'action': action,
        ...?parameters,
      },
    );
  }
}
