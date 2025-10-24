import 'package:flutter/material.dart';
import 'package:datetime_loop/datetime_loop.dart';

void main() {
  runApp(const PauseResumeExampleApp());
}

class PauseResumeExampleApp extends StatelessWidget {
  const PauseResumeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DateTimeLoop Pause/Resume Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PauseResumeExample(),
    );
  }
}

class PauseResumeExample extends StatefulWidget {
  const PauseResumeExample({super.key});

  @override
  State<PauseResumeExample> createState() => _PauseResumeExampleState();
}

class _PauseResumeExampleState extends State<PauseResumeExample> {
  // Create a shared controller to demonstrate pause/resume functionality
  final DateTimeLoopController _controller = DateTimeLoopController(
    timeUnit: TimeUnit.seconds,
    triggerOnStart: true,
  );

  bool _isPaused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePauseResume() {
    setState(() {
      if (_isPaused) {
        _controller.resume(triggerImmediate: true);
        _isPaused = false;
      } else {
        _controller.pause();
        _isPaused = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pause/Resume DateTimeLoop'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the shared controller in DateTimeLoopBuilder
            DateTimeLoopBuilder(
              controller: _controller,
              triggerOnStateChange: true,
              builder: (context, dateTime, child) {
                return Text(
                  'Current Time: ${dateTime.toString().split('.').first}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _togglePauseResume,
              child: Text(_isPaused ? 'Resume' : 'Pause'),
            ),
          ],
        ),
      ),
    );
  }
}
