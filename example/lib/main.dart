import 'package:datetime_loop/datetime_loop.dart';
import 'package:example/page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExamplePage(timeUnit: TimeUnit.seconds,)),
                        );
                      },
                      child: const Text('Seconds'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExamplePage(timeUnit: TimeUnit.minutes,)),
                        );
                      },
                      child: const Text('Minutes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExamplePage(timeUnit: TimeUnit.hours,)),
                        );
                      },
                      child: const Text('Hours'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExamplePage(timeUnit: TimeUnit.days,)),
                        );
                      },
                      child: const Text('Days'),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

