import 'package:equatable/equatable.dart';
import 'dart:convert';

/// Analytics event types
enum AnalyticsEventType {
  /// Screen view event
  screenView,

  /// Button click event
  buttonClick,

  /// Form submit event
  formSubmit,

  /// Error event
  error,

  /// Search event
  search,

  /// Purchase event
  purchase,

  /// Custom event
  custom,

  /// User property event
  userProperty,
}

/// Analytics event model
class AnalyticsEvent {
  /// Constructor
  AnalyticsEvent({
    required this.eventType,
    required this.eventName,
    required this.parameters,
    this.retryCount = 0,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  /// Event type
  final AnalyticsEventType eventType;

  /// Event name
  final String eventName;

  /// Event parameters
  final Map<String, dynamic> parameters;

  /// Retry count
  int retryCount;

  /// Timestamp
  final int timestamp;

  /// Maximum number of retries
  static const int maxRetries = 3;

  /// Whether the event can be retried
  bool get canRetry => retryCount < maxRetries;

  /// Increment retry count
  void incrementRetryCount() {
    retryCount++;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'event_type': eventType.name,
      'event_name': eventName,
      'parameters': parameters,
      'timestamp': timestamp,
      'retry_count': retryCount,
    };
  }

  /// Create from JSON
  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      eventType: AnalyticsEventType.values.firstWhere(
        (e) => e.name == json['event_type'] as String,
        orElse: () => AnalyticsEventType.custom,
      ),
      eventName: json['event_name'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
      retryCount: json['retry_count'] as int? ?? 0,
      timestamp: json['timestamp'] as int?,
    );
  }

  /// Convert event to string
  String encode() => jsonEncode(toJson());

  /// Create event from string
  factory AnalyticsEvent.fromString(String jsonString) {
    return AnalyticsEvent.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
