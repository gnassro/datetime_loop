import 'dart:math' as math;
import 'package:datetime_loop/datetime_loop.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GroupButtonController _controller =
      GroupButtonController(selectedIndex: 0);

  final ValueNotifier<TimeUnit> _timeUnitNotifier =
      ValueNotifier(TimeUnit.seconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GroupButton<TimeUnit>(
                  controller: _controller,
                  buttons: TimeUnit.values,
                  onSelected: (timeUnit, index, isSelected) {
                    _timeUnitNotifier.value = timeUnit;
                  },
                  buttonTextBuilder: (__, timeUnit, context) {
                    return timeUnit.name;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                ValueListenableBuilder<TimeUnit>(
                    valueListenable: _timeUnitNotifier,
                    builder: (context, timeUnit, __) {
                      return ExampleComponent(timeUnit: timeUnit);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExampleComponent extends StatelessWidget {
  final TimeUnit timeUnit;

  const ExampleComponent({super.key, required this.timeUnit});

  @override
  Widget build(BuildContext context) {
    return DateTimeLoopBuilder(
      timeUnit: timeUnit,
      triggerOnStateChange: true,
      builder: (context, dateTime, child) {
        return Column(
          children: [
            Container(
              width: 200,
              height: 200,
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ),
            Text('${dateTime.hour}:${dateTime.minute}:${dateTime.second}'),
            child!
          ],
        );
      },
      child: Container(
        width: 200,
        height: 200,
        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        child: const Center(
          child: Text(
              'Widget will not be affected by the change of the DateTimeLoopBuilder state. (Color will changed only if the state of ExampleComponent is changed)'),
        ),
      ),
    );
  }
}
