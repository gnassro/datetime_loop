import 'dart:async';

import 'package:datetime_loop/src/utils/time_unit.dart';
import 'package:flutter/material.dart';

import 'datetime_loop_builder.dart';

@protected
mixin DateTimeProvider on State<DateTimeLoopBuilder> {

  DateTime dateTime2show = DateTime.now();

  StreamController<DateTime> dateTimeController = StreamController<DateTime>();

  @override
  void initState() {
    super.initState();
    dateTimeController = StreamController<DateTime>();
    _initDateTimeStream();
  }

  @override
  void dispose() {
    dateTimeController.close();
    super.dispose();
  }


  void _initDateTimeStream() async {
    while (await Future<bool>.delayed(_getDuration2wait(widget.timeUnit), () => true)) {
      if (dateTimeController.isClosed) {
        break;
      }
      dateTime2show = DateTime.now();
      dateTimeController.add(DateTime.now());
    }
  }

  Duration _getDuration2wait (TimeUnit timeUnit) {
    switch (timeUnit) {
      case TimeUnit.seconds:
        return Duration(microseconds: 999 - dateTime2show.microsecond, milliseconds: 999 - dateTime2show.millisecond);
      case TimeUnit.minutes:
        return _getDuration2wait(TimeUnit.seconds) + Duration(seconds: 59 - dateTime2show.second);
      case TimeUnit.hours:
        return _getDuration2wait(TimeUnit.minutes) + Duration(minutes: 59 - dateTime2show.minute);
      case TimeUnit.days:
        return _getDuration2wait(TimeUnit.hours) + Duration(hours: 23 - dateTime2show.hour);
    }
  }
}