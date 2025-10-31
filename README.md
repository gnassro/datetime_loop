<div align="center"><a href="https://github.com/gnassro/datetime_loop/tree/master/example/lib/clock_example.dart" target="_blank"><img src="https://i.imgur.com/PHFHrV1.gif" alt="Clock Example" width=450 ></a></div>

<p align="center">
<a href="https://www.buymeacoffee.com/gnassro" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width=120 ></a><br>
  <a href="https://pub.dev/packages/datetime_loop"><img src="https://img.shields.io/pub/v/datetime_loop.svg" alt="Pub"></a>
  <a href="https://github.com/gnassro/datetime_loop/blob/master/LICENSE"><img src="https://img.shields.io/github/license/gnassro/datetime_loop" alt="BSD 3-Clause License"></a>
  <a href="https://github.com/gnassro/datetime_loop"><img src="https://img.shields.io/github/stars/gnassro/datetime_loop?style=social" alt="Pub"></a><br>
  <a href="https://pub.dev/packages/datetime_loop/score"><img src="https://img.shields.io/pub/likes/datetime_loop?logo=flutter" alt="Pub likes"></a>
  <a href="https://pub.dev/packages/datetime_loop/score"><img src="https://img.shields.io/pub/dm/datetime_loop?logo=flutter" alt="Download"></a>
  <a href="https://pub.dev/packages/datetime_loop/score"><img src="https://img.shields.io/pub/points/datetime_loop?logo=flutter" alt="Pub points"></a>
</p>

<p align="center">
A Flutter package that provides a widget to listen to the system's datetime and trigger a rebuild based on the specified time unit
</p>

<p align="center"> Support the project by giving the <a href="https://github.com/gnassro/datetime_loop">repo</a> a ⭐ and showing some ❤️!
</p>

## Usage

Import the package in your Dart code:

```dart
import 'package:datetime_loop/datetime_loop.dart';
```

### Using `DateTimeLoopBuilder`

Use the `DateTimeLoopBuilder` widget to rebuild UI elements based on system time updates. You can provide a `timeUnit` for simple setups or a custom `DateTimeLoopController` for advanced control (e.g., pause/resume):

```dart
DateTimeLoopBuilder(
  timeUnit: TimeUnit.seconds,
  builder: (context, dateTime, child) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        ),
        Text('$dateTime'),
      ],
    );
  }
)
```

### Using `DateTimeLoopController`

The `DateTimeLoopController` provides a stream of datetime updates and supports advanced features like pausing and resuming updates, useful for optimizing resource usage (e.g., when the app is backgrounded):

```dart
final controller = DateTimeLoopController(timeUnit: TimeUnit.minutes);
controller.dateTimeStream.listen((dateTime) {
  print('Current time: $dateTime');
});

// Pause updates to save resources
controller.pause();

// Resume updates with an immediate trigger
controller.resume(triggerImmediate: true);

// Use the controller with DateTimeLoopBuilder
DateTimeLoopBuilder(
  controller: controller,
  builder: (context, dateTime, child) {
  return Text('Time: ${dateTime.toString().split('.').first}');
  },
);

// Dispose of the controller when done
controller.dispose();
```

### Testing with `getNow`

Both `DateTimeLoopBuilder` and `DateTimeLoopController` support a `getNow` parameter that allows you to mock the system time. This is particularly useful for testing and simulating different time scenarios:

```dart
// Example: Testing with a mocked time
DateTime customTime = DateTime(2025, 10, 31, 12, 0, 0);

DateTimeLoopBuilder(
  timeUnit: TimeUnit.seconds,
  getNow: () => customTime,
  builder: (context, dateTime, child) {
    return Text('Mocked time: $dateTime');
  },
)

// Example: Using getNow with DateTimeLoopController
final controller = DateTimeLoopController(
  timeUnit: TimeUnit.minutes,
  getNow: () => customTime,
);
```

This feature enables:
- **Unit Testing**: Write deterministic tests by controlling the datetime value
- **Time Simulation**: Simulate different time scenarios without waiting for real time to pass
- **Debugging**: Test edge cases and time-dependent behavior

You can check more examples of using this widget [here](https://github.com/gnassro/datetime_loop/tree/master/example/lib)

## Issues and Feedback

Please file any issues or feedback [here](https://github.com/gnassro/datetime_loop/issues).