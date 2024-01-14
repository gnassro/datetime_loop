import 'package:datetime_loop/src/datetime_provider.dart';
import 'package:flutter/material.dart';
import 'package:datetime_loop/src/utils/time_unit.dart';

typedef DateTimeLoopWidgetBuilder = Widget Function(BuildContext context, DateTime value, Widget? child);


class DateTimeLoopBuilder extends StatefulWidget {

  final TimeUnit timeUnit;

  final DateTimeLoopWidgetBuilder builder;

  final Widget? child;


  const DateTimeLoopBuilder({
    super.key,
    required this.timeUnit,
    required this.builder,
    this.child
  });

  @override
  State<DateTimeLoopBuilder> createState() => _DateTimeLoopBuilderState();
}

class _DateTimeLoopBuilderState extends State<DateTimeLoopBuilder> with DateTimeProvider {

  late final initialDateTime = dateTime2show;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      initialData: initialDateTime,
        stream: dateTimeController.stream,
        builder: (context, datetimeSnapshot) {
        final DateTime dateTime = datetimeSnapshot.data ?? initialDateTime;
          return widget.builder(context, dateTime, widget.child);
        }
    );
  }
}
