import 'dart:async';
import 'package:devity_console/models/analytics_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing analytics event queue
class AnalyticsQueueService {
  /// Constructor
  AnalyticsQueueService() {
    _init();
  }

  /// Shared preferences instance
  late SharedPreferences _prefs;

  /// Queue of events to be sent
  final List<AnalyticsEvent> _queue = [];

  /// Timer for processing queue
  Timer? _processTimer;

  /// Maximum batch size
  static const int maxBatchSize = 50;

  /// Maximum queue size
  static const int maxQueueSize = 1000;

  /// Processing interval
  static const Duration processingInterval = Duration(minutes: 5);

  /// Initialize the service
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadQueue();
    _startProcessingTimer();
  }

  /// Add an event to the queue
  Future<void> addEvent(AnalyticsEvent event) async {
    if (_queue.length >= maxQueueSize) {
      // Remove oldest events if queue is full
      _queue.removeRange(0, _queue.length - maxQueueSize + 1);
    }
    _queue.add(event);
    await _saveQueue();
  }

  /// Get a batch of events to process
  List<AnalyticsEvent> getBatch() {
    final batchSize =
        _queue.length > maxBatchSize ? maxBatchSize : _queue.length;
    return _queue.sublist(0, batchSize);
  }

  /// Remove processed events from the queue
  Future<void> removeProcessedEvents(
      List<AnalyticsEvent> processedEvents) async {
    _queue.removeWhere((event) => processedEvents.contains(event));
    await _saveQueue();
  }

  /// Save queue to persistent storage
  Future<void> _saveQueue() async {
    final eventsJson = _queue.map((e) => e.encode()).toList();
    await _prefs.setStringList('analytics_queue', eventsJson);
  }

  /// Load queue from persistent storage
  Future<void> _loadQueue() async {
    final eventsJson = _prefs.getStringList('analytics_queue') ?? [];
    _queue.clear();
    _queue.addAll(
      eventsJson.map((json) => AnalyticsEvent.fromString(json)),
    );
  }

  /// Start the processing timer
  void _startProcessingTimer() {
    _processTimer?.cancel();
    _processTimer = Timer.periodic(processingInterval, (_) {
      _processQueue();
    });
  }

  /// Process the queue
  Future<void> _processQueue() async {
    if (_queue.isEmpty) return;

    final batch = getBatch();
    // Here you would typically send the batch to your analytics service
    // and handle the response
  }

  /// Clear the queue
  Future<void> clearQueue() async {
    _queue.clear();
    await _saveQueue();
  }

  /// Get the current queue size
  int get queueSize => _queue.length;

  /// Dispose the service
  void dispose() {
    _processTimer?.cancel();
  }
}
