import 'dart:async';

import 'package:datetime_loop/src/utils/time_unit.dart';
import 'package:flutter/material.dart';

import 'datetime_loop_builder.dart';

@protected
mixin DateTimeProvider on State<DateTimeLoopBuilder> {
  StreamController<DateTime> dateTimeController = StreamController<DateTime>();

  late UniqueKey _uniqueKey;

  @override
  void initState() {
    super.initState();
    _processDateTimeStream();
  }

  @override
  void didUpdateWidget(covariant DateTimeLoopBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _processDateTimeStream();
  }

  @override
  void dispose() {
    dateTimeController.close();
    super.dispose();
  }

  void _processDateTimeStream() async {
    var dateTime = DateTime.now();
    if (widget.triggerOnStateChange) {
      dateTimeController.add(dateTime);
    }
    _uniqueKey = UniqueKey();
    final saveCurrentUniqueKey = _uniqueKey;
    while (await Future<bool>.delayed(
        _getDuration2wait(widget.timeUnit, dateTime),
        () => _uniqueKey == saveCurrentUniqueKey)) {
      if (dateTimeController.isClosed) {
        break;
      }
      final timeNow = DateTime.now();
      dateTimeController.add(timeNow);
      dateTime = timeNow;
    }
  }

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
}
