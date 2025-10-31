import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:datetime_loop/src/datetime_loop_builder.dart';
import 'package:datetime_loop/src/utils/time_unit.dart';

Duration _calculateInitialWait(TimeUnit unit, DateTime dt) {
  switch (unit) {
    case TimeUnit.milliseconds:
      return const Duration(milliseconds: 1);
    case TimeUnit.seconds:
      return Duration(milliseconds: 1000 - dt.millisecond);
    case TimeUnit.minutes:
      return _calculateInitialWait(TimeUnit.seconds, dt) +
          Duration(seconds: 59 - dt.second);
    case TimeUnit.hours:
      return _calculateInitialWait(TimeUnit.minutes, dt) +
          Duration(minutes: 59 - dt.minute);
    case TimeUnit.days:
      return _calculateInitialWait(TimeUnit.hours, dt) +
          Duration(hours: 23 - dt.hour);
  }
}

Duration _fullPeriod(TimeUnit unit) {
  switch (unit) {
    case TimeUnit.milliseconds:
      return const Duration(milliseconds: 1);
    case TimeUnit.seconds:
      return const Duration(seconds: 1);
    case TimeUnit.minutes:
      return const Duration(minutes: 1);
    case TimeUnit.hours:
      return const Duration(hours: 1);
    case TimeUnit.days:
      return const Duration(days: 1);
  }
}

Future<void> _testBuilderRebuilds({
  required TimeUnit unit,
  required bool triggerOnStateChange,
  required WidgetTester tester,
}) async {

  final initialTime = DateTime(2025, 10, 25, 12, 34, 56, 789);

  DateTime now = initialTime;
  DateTime getMockedNow() => now;

  int buildCount = 0;

  Widget countingBuilder(BuildContext context, DateTime dt, Widget? child) {
    buildCount++;
    return Text(dt.toIso8601String());
  }

  await tester.pumpWidget(
    MaterialApp(
      home: DateTimeLoopBuilder(
        timeUnit: unit,
        triggerOnStateChange: triggerOnStateChange,
        builder: countingBuilder,
        getNow: getMockedNow,
      ),
    ),
  );

  expect(find.text(initialTime.toIso8601String()), findsOneWidget);
  expect(buildCount, 1);

  await tester.pump();

  if (triggerOnStateChange) {
    expect(find.text(initialTime.toIso8601String()), findsOneWidget);
    expect(buildCount, 2);
  } else {
    expect(buildCount, 1);
  }

  final initialWait = _calculateInitialWait(unit, initialTime);

  now = initialTime.add(initialWait);

  await tester.pump(initialWait);

  final firstBoundary = initialTime.add(initialWait);
  expect(find.text(firstBoundary.toIso8601String()), findsOneWidget);
  expect(buildCount, triggerOnStateChange ? 3 : 2);

  final fullPeriodDuration = _fullPeriod(unit);

  now = firstBoundary.add(fullPeriodDuration);
  await tester.pump(fullPeriodDuration);

  final secondBoundary = firstBoundary.add(fullPeriodDuration);
  expect(find.text(secondBoundary.toIso8601String()), findsOneWidget);
  expect(buildCount, triggerOnStateChange ? 4 : 3);
}

void main() {
  testWidgets('rebuilds every millisecond with triggerOnStateChange true', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.milliseconds,
      triggerOnStateChange: true,
      tester: tester,
    );
  });

  testWidgets('rebuilds every millisecond with triggerOnStateChange false', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.milliseconds,
      triggerOnStateChange: false,
      tester: tester,
    );
  });

  testWidgets('rebuilds every second with triggerOnStateChange true', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.seconds,
      triggerOnStateChange: true,
      tester: tester,
    );
  });

  testWidgets('rebuilds every second with triggerOnStateChange false', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.seconds,
      triggerOnStateChange: false,
      tester: tester,
    );
  });

  testWidgets('rebuilds every minute with triggerOnStateChange true', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.minutes,
      triggerOnStateChange: true,
      tester: tester,
    );
  });

  testWidgets('rebuilds every minute with triggerOnStateChange false', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.minutes,
      triggerOnStateChange: false,
      tester: tester,
    );
  });

  testWidgets('rebuilds every hour with triggerOnStateChange true', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.hours,
      triggerOnStateChange: true,
      tester: tester,
    );
  });

  testWidgets('rebuilds every hour with triggerOnStateChange false', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.hours,
      triggerOnStateChange: false,
      tester: tester,
    );
  });

  testWidgets('rebuilds every day with triggerOnStateChange true', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.days,
      triggerOnStateChange: true,
      tester: tester,
    );
  });

  testWidgets('rebuilds every day with triggerOnStateChange false', (tester) async {
    await _testBuilderRebuilds(
      unit: TimeUnit.days,
      triggerOnStateChange: false,
      tester: tester,
    );
  });
}
