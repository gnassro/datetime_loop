# datetime_loop

A Flutter package that provides a widget to listen to the system's datetime and trigger a rebuild based on the specified time unit.

## Usage

Import the package in your Dart code:

```dart
import 'package:datetime_loop/datetime_loop.dart';
```

Use the **DateTimeLoopBuilder** widget in your Flutter app:

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
## Issues and Feedback

Please file any issues or feedback [here](https://github.com/gnassro/datetime_loop/issues).