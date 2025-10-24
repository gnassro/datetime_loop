import 'dart:async';

import 'package:datetime_loop/src/utils/time_unit.dart';

/// A controller that emits [DateTime] updates at intervals specified by a [TimeUnit].
///
/// The [DateTimeLoopController] provides a stream of [DateTime] objects that can be
/// listened to by multiple subscribers. The stream emits updates based on the system's
/// current time, with the frequency determined by the [timeUnit] parameter.
///
/// **Key Features:**
/// - Emits [DateTime] updates at intervals specified by [timeUnit].
/// - Optionally emits an initial [DateTime] when the first listener subscribes.
/// - Uses a broadcast stream to support multiple listeners.
/// - Automatically starts emitting updates when the first listener subscribes and
///   stops when the last listener unsubscribes.
/// - Supports manual pausing and resuming of updates for resource management (e.g., when the app is backgrounded).
///
/// **Example Usage:**
/// ```dart
/// final controller = DateTimeLoopController(timeUnit: TimeUnit.seconds);
/// controller.dateTimeStream.listen((dateTime) {
///   print('Current time: $dateTime');
/// });
/// // Pause updates
/// controller.pause();
/// // Resume updates with an immediate trigger
/// controller.resume(triggerImmediate: true);
/// // Dispose of the controller when no longer needed
/// controller.dispose();
/// ```
///
/// **Important:** Call [dispose] when the controller is no longer needed to prevent
/// memory leaks.
class DateTimeLoopController {
  /// The internal stream controller that manages the broadcast stream of [DateTime] updates.
  /// This should not be accessed directly.
  final StreamController<DateTime> _streamController;

  /// The time unit that determines the interval at which [DateTime] updates are emitted.
  /// For example, [TimeUnit.seconds] emits updates every second.
  final TimeUnit timeUnit;

  /// Whether to emit an initial [DateTime] when the first listener subscribes.
  /// If `true`, the stream emits the current [DateTime] immediately upon subscription.
  /// If `false`, the first emission occurs at the next interval boundary. Defaults to `true`.
  final bool triggerOnStart;

  /// The internal timer that drives the datetime loop.
  /// This timer is responsible for scheduling and executing the periodic updates.
  /// It is canceled and recreated when the controller is disposed or the time unit changes.
  Timer? _timer;

  /// Whether the controller is manually paused.
  bool _isPaused = false;

  /// The broadcast stream that emits [DateTime] updates at intervals specified by [timeUnit].
  /// Multiple listeners can subscribe to this stream.
  Stream<DateTime> get dateTimeStream => _streamController.stream;

  /// Creates a [DateTimeLoopController] with the specified [timeUnit] and [triggerOnStart].
  ///
  /// **Parameters:**
  /// - [timeUnit]: The interval at which [DateTime] updates are emitted.
  /// - [triggerOnStart]: Whether to emit an initial [DateTime] when the first listener subscribes.
  DateTimeLoopController({
    required this.timeUnit,
    this.triggerOnStart = true,
  }) : _streamController = StreamController<DateTime>.broadcast() {
    _initialize();
  }

  void _initialize() {
    if (triggerOnStart) {
      // Defer the initial event to allow listeners to subscribe.
      Future.microtask(() {
        if (!_streamController.isClosed) {
          _streamController.add(DateTime.now());
        }
      });
    }
    _scheduleNextTick();
  }

  /// Emits the current [DateTime] immediately to the stream.
  void triggerNow() {
    if (!_streamController.isClosed) {
      _streamController.add(DateTime.now());
    }
  }

  /// Schedules the next tick of the datetime loop.
  /// This method cancels any existing timer and creates a new one with a duration
  /// calculated by `_getDuration2wait`. When the timer fires, it emits the
  /// current `DateTime` and schedules the next tick.
  void _scheduleNextTick() {
    _timer?.cancel();
    final now = DateTime.now();
    final duration = _getDuration2wait(timeUnit, now);

    _timer = Timer(duration, () {
      if (_streamController.isClosed || _isPaused) {
        return;
      }
      _streamController.add(DateTime.now());
      _scheduleNextTick(); // Schedule the next tick
    });
  }

  /// Calculates the duration to wait before emitting the next [DateTime] based on the [timeUnit].
  ///
  /// **Examples:**
  /// - For [TimeUnit.seconds], it calculates the time until the next second.
  /// - For [TimeUnit.minutes], it calculates the time until the next minute.
  ///
  /// This method uses recursion for larger time units, building the duration from smaller units.
  Duration _getDuration2wait(TimeUnit timeUnit, DateTime dateTime) {
    switch (timeUnit) {
      case TimeUnit.milliseconds:
        return const Duration(milliseconds: 1);
      case TimeUnit.seconds:
        return Duration(milliseconds: 1000 - dateTime.millisecond);
      case TimeUnit.minutes:
        return _getDuration2wait(TimeUnit.seconds, dateTime) +
            Duration(seconds: 59 - dateTime.second);
      case TimeUnit.hours:
        return _getDuration2wait(TimeUnit.minutes, dateTime) +
            Duration(minutes: 59 - dateTime.minute);
      case TimeUnit.days:
        return _getDuration2wait(TimeUnit.hours, dateTime) +
            Duration(hours: 23 - dateTime.hour);
    }
  }

  /// Pauses the emission of [DateTime] updates, canceling the internal timer.
  /// This is useful for saving resources when updates are not needed, such as when the app is backgrounded.
  void pause() {
    _isPaused = true;
    _timer?.cancel();
  }

  /// Resumes the emission of [DateTime] updates if there are active listeners.
  /// Optionally triggers an immediate update.
  ///
  /// **Parameters:**
  /// - [triggerImmediate]: Whether to emit the current [DateTime] immediately upon resuming. Defaults to `true`.
  void resume({bool triggerImmediate = true}) {
    if (!_isPaused || _streamController.isClosed) return;
    _isPaused = false;
    if (_streamController.hasListener) {
      if (triggerImmediate) {
        triggerNow();
      }
      _scheduleNextTick();
    }
  }

  /// Closes the stream controller, cancels the timer, and stops emitting [DateTime] updates.
  ///
  /// Call this method when the controller is no longer needed to prevent memory leaks.
  void dispose() {
    _timer?.cancel();
    if (!_streamController.isClosed) {
      _streamController.close();
    }
  }
}
