import 'dart:math' as math;
import 'package:datetime_loop/datetime_loop.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {

  final TimeUnit timeUnit;

  const ExamplePage({
    super.key,
    required this.timeUnit
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: DateTimeLoopBuilder(
            timeUnit: timeUnit,
            builder: (context, dateTime, child) {
              return Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                  ),
                  Text('${dateTime.hour}:${dateTime.minute}:${dateTime.second}'),
                  child!
                ],
              );
            },
          child: Container(
            width: 200,
            height: 200,
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
            child: const Center(
              child: Text('Widget will not be affected by the change of the DateTimeLoopBuilder state'),
            ),
          ),
        ),
      ),
    );
  }
}
