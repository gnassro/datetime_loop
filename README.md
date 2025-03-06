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

Use the `DateTimeLoopBuilder` widget in your Flutter app to rebuild UI elements based on system time updates:

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

New in version `1.3.0`! Use the `DateTimeLoopController` to listen to datetime updates programmatically via a stream:

```dart
final controller = DateTimeLoopController(timeUnit: TimeUnit.minutes);
controller.dateTimeStream.listen((dateTime) {
print('Current time: $dateTime');
});

// Don’t forget to dispose of the controller when done
controller.dispose();
```

You can check more examples of using this widget [here](https://github.com/gnassro/datetime_loop/tree/master/example/lib)

## Issues and Feedback

Please file any issues or feedback [here](https://github.com/gnassro/datetime_loop/issues).