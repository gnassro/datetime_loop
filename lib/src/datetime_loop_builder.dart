import 'package:datetime_loop/src/date_time_loop_controller.dart';
import 'package:flutter/material.dart';
import 'package:datetime_loop/src/utils/time_unit.dart';

typedef DateTimeLoopWidgetBuilder = Widget Function(
    BuildContext context, DateTime value, Widget? child);

class DateTimeLoopBuilder extends StatefulWidget {
  /// The time unit for updates. Required if [controller] is not provided.
  final TimeUnit? timeUnit;

  /// An optional custom controller to use for datetime updates. If provided,
  /// [timeUnit] and [triggerOnStateChange] (for creation) are ignored, but
  /// [triggerOnStateChange] still controls immediate triggers on widget state changes.
  /// This allows users to manage the controller externally, e.g., for pause/resume functionality.
  final DateTimeLoopController? controller;

  /// A function to provide the current [DateTime]. Defaults to [DateTime.now].
  /// This can be overridden for testing or simulation purposes to mock the system time.
  /// If provided, it is used for the initial data and passed to the internal controller if created.
  final DateTime Function()? getNow;

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
  const DateTimeLoopBuilder({
    super.key,
    this.timeUnit,
    this.controller,
    this.getNow,
    this.triggerOnStateChange = true,
    required this.builder,
    this.child,
  }) : assert(controller != null || timeUnit != null,
            'Either controller or timeUnit must be provided.');

  @override
  State<DateTimeLoopBuilder> createState() => _DateTimeLoopBuilderState();
}

class _DateTimeLoopBuilderState extends State<DateTimeLoopBuilder> {
  late final DateTime initialDateTime;

  late DateTimeLoopController _controller;

  late bool _ownsController;

  Widget? _lastPushedWidget;

  DateTime? _lastPushedDateTime;

  @override
  void initState() {
    super.initState();
    initialDateTime = widget.getNow?.call() ?? DateTime.now();
    _updateController();
  }

  void _updateController() {
    _controller = widget.controller ??
        DateTimeLoopController(
          timeUnit: widget.timeUnit!,
          triggerOnStart: widget.triggerOnStateChange,
          getNow: widget.getNow ?? DateTime.now,
        );
    _ownsController = widget.controller == null;
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DateTimeLoopBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.timeUnit != widget.timeUnit ||
        oldWidget.triggerOnStateChange != widget.triggerOnStateChange ||
        oldWidget.getNow != widget.getNow) {
      if (_ownsController) {
        _controller.dispose();
      }
      _updateController();
    }

    /// Workaround for Flutter issue #64916[](https://github.com/flutter/flutter/issues/64916).
    /// Triggers an immediate rebuild when `triggerOnStateChange` is true to ensure the builder
    /// is called on widget initialization and parent rebuilds, addressing a limitation where
    /// `StreamBuilder` may not reflect state changes promptly.
    if (widget.triggerOnStateChange) {
      _controller.triggerNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      initialData: initialDateTime,
      stream: _controller.dateTimeStream,
      builder: (context, datetimeSnapshot) {
        final DateTime dateTime = datetimeSnapshot.data!;
        if (_lastPushedWidget == null || dateTime != _lastPushedDateTime) {
          _lastPushedDateTime = dateTime;
          _lastPushedWidget =
              widget.builder(context, _lastPushedDateTime!, widget.child);
        }
        return _lastPushedWidget!;
      },
    );
  }
}
