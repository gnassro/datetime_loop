import 'dart:async';

import 'package:datetime_loop/src/utils/time_unit.dart';
import 'package:datetime_loop/src/utils/unique_key.dart';

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
///
/// **Example Usage:**
/// ```dart
/// final controller = DateTimeLoopController(timeUnit: TimeUnit.seconds);
/// controller.dateTimeStream.listen((dateTime) {
///   print('Current time: $dateTime');
/// });
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

  /// A unique key used to control the emission loop.
  /// This key ensures the loop stops when the controller is disposed or the stream is cancelled.
  late UniqueKey _uniqueKey;

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
    _processDateTimeStream();
  }

  /// Emits the current [DateTime] immediately to the stream.
  void triggerNow() {
    if (!_streamController.isClosed) {
      _streamController.add(DateTime.now());
    }
  }

  /// Starts the process of emitting [DateTime] updates based on the [timeUnit].
  ///
  /// This method runs an asynchronous loop that:
  /// 1. Emits the current [DateTime] if [triggerOnStart] is `true`.
  /// 2. Waits for the duration calculated by [_getDuration2wait].
  /// 3. Emits the current [DateTime] at each interval.
  ///
  /// The loop continues until the stream is closed or the controller is disposed.
  void _processDateTimeStream() async {
    var dateTime = DateTime.now();
    if (triggerOnStart) {
      _streamController.add(dateTime);
    }
    _uniqueKey = UniqueKey();
    final saveCurrentUniqueKey = _uniqueKey;
    while (await Future<bool>.delayed(_getDuration2wait(timeUnit, dateTime),
        () => _uniqueKey == saveCurrentUniqueKey)) {
      if (_streamController.isClosed) {
        break;
      }
      final timeNow = DateTime.now();
      _streamController.add(timeNow);
      dateTime = timeNow;
    }
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
        return Duration(milliseconds: 999 - dateTime.millisecond);
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

  /// Closes the stream controller and stops emitting [DateTime] updates.
  ///
  /// Call this method when the controller is no longer needed to prevent memory leaks.
  void dispose() async {
    await _streamController.close();
  }
}
