import 'package:datetime_loop/src/datetime_provider.dart';
import 'package:flutter/material.dart';
import 'package:datetime_loop/src/utils/time_unit.dart';

typedef DateTimeLoopWidgetBuilder = Widget Function(
    BuildContext context, DateTime value, Widget? child);

class DateTimeLoopBuilder extends StatefulWidget {
  /// The time unit for updates (required).
  final TimeUnit timeUnit;

  /// A function to build the widget based on the current datetime (required).
  final DateTimeLoopWidgetBuilder builder;

  /// An optional child widget to be passed to the builder.
  final Widget? child;

  /// Whether to trigger an initial build immediately upon widget creation or state change,
  /// even if the elapsed time based on [timeUnit] hasn't passed yet.
  /// If set to `false`, the initial build will happen at the first change in system time
  /// that aligns with the specified [timeUnit]. (default: `true`).
  final bool triggerOnStateChange;

  /// [DateTimeLoopBuilder] is a Widget that listens to the system's datetime and triggers
  /// a rebuild of its child widget based on the specified time unit.
  /// This allows you to create dynamic UI elements that update at regular intervals.
  const DateTimeLoopBuilder(
      {super.key,
      required this.timeUnit,
      this.triggerOnStateChange = true,
      required this.builder,
      this.child});

  @override
  State<DateTimeLoopBuilder> createState() => _DateTimeLoopBuilderState();
}

class _DateTimeLoopBuilderState extends State<DateTimeLoopBuilder>
    with DateTimeProvider {
  final initialDateTime = DateTime.now();

  final GlobalKey<_DateTimeLoopBuilderState> _streamKey =
      GlobalKey<_DateTimeLoopBuilderState>();

  Widget? _lastPushedWidget;

  DateTime? _lastPushedDateTime;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
        key: _streamKey,
        initialData: initialDateTime,
        stream: dateTimeController.stream,
        builder: (context, datetimeSnapshot) {
          final DateTime dateTime = datetimeSnapshot.data!;
          if (_lastPushedWidget == null || dateTime != _lastPushedDateTime) {
            _lastPushedDateTime = dateTime;
            _lastPushedWidget =
                widget.builder(context, _lastPushedDateTime!, widget.child);
          }
          return _lastPushedWidget!;
        });
  }
}
