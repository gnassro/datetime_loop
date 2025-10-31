import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:datetime_loop/src/date_time_loop_controller.dart';
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

void _testTimeUnitEmissions({
  required TimeUnit unit,
  required bool triggerOnStart,
  required FakeAsync async,
}) {
  final initialTime = DateTime(2025, 10, 25, 12, 34, 56, 789);

  DateTime getMockedNow() => initialTime.add(async.elapsed);

  final controller = DateTimeLoopController(
    timeUnit: unit,
    triggerOnStart: triggerOnStart,
    getNow: getMockedNow,
  );

  final emittedTimes = <DateTime>[];
  final subscription = controller.dateTimeStream.listen(emittedTimes.add);

  if (triggerOnStart) {
    async.flushMicrotasks();
    expect(emittedTimes, [initialTime]);
  } else {
    async.flushMicrotasks();
    expect(emittedTimes, isEmpty);
  }

  final initialWait = _calculateInitialWait(unit, initialTime);
  async.elapse(initialWait);
  final firstBoundary = initialTime.add(initialWait);
  expect(emittedTimes.last, firstBoundary);
  expect(emittedTimes.length, triggerOnStart ? 2 : 1);

  final fullPeriod = _fullPeriod(unit);
  async.elapse(fullPeriod);
  final secondBoundary = firstBoundary.add(fullPeriod);
  expect(emittedTimes.last, secondBoundary);
  expect(emittedTimes.length, triggerOnStart ? 3 : 2);

  subscription.cancel();
  controller.dispose();
}

void main() {
  test('emits DateTime updates every millisecond with triggerOnStart true', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.milliseconds,
        triggerOnStart: true,
        async: async,
      );
    });
  });

  test('emits DateTime updates every millisecond with triggerOnStart false',
      () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.milliseconds,
        triggerOnStart: false,
        async: async,
      );
    });
  });

  test('emits DateTime updates every second with triggerOnStart true', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.seconds,
        triggerOnStart: true,
        async: async,
      );
    });
  });

  test('emits DateTime updates every second with triggerOnStart false', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.seconds,
        triggerOnStart: false,
        async: async,
      );
    });
  });

  test('emits DateTime updates every minute with triggerOnStart true', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.minutes,
        triggerOnStart: true,
        async: async,
      );
    });
  });

  test('emits DateTime updates every minute with triggerOnStart false', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.minutes,
        triggerOnStart: false,
        async: async,
      );
    });
  });

  test('emits DateTime updates every hour with triggerOnStart true', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.hours,
        triggerOnStart: true,
        async: async,
      );
    });
  });

  test('emits DateTime updates every hour with triggerOnStart false', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.hours,
        triggerOnStart: false,
        async: async,
      );
    });
  });

  test('emits DateTime updates every day with triggerOnStart true', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.days,
        triggerOnStart: true,
        async: async,
      );
    });
  });

  test('emits DateTime updates every day with triggerOnStart false', () {
    fakeAsync((async) {
      _testTimeUnitEmissions(
        unit: TimeUnit.days,
        triggerOnStart: false,
        async: async,
      );
    });
  });
}
