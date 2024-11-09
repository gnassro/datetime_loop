import 'dart:math' as math;

import 'package:datetime_loop/datetime_loop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const ClockExample());
}

class ClockExample extends StatefulWidget {

  const ClockExample({super.key});

  @override
  State<ClockExample> createState() => _ClockExampleState();
}

class _ClockExampleState extends State<ClockExample> {

  final Color _needleColor = const Color(0xFF355C7D);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DateTimeLoopBuilder(
            timeUnit: TimeUnit.seconds,
            builder: (context, dateTime, _) {
              final int seconds = dateTime.second;
              final int hours = int.parse(DateFormat('hh').format(dateTime));
              final int minutes = dateTime.minute;
              return SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                      startAngle: 270,
                      endAngle: 270,
                      maximum: 12,
                      showFirstLabel: false,
                      showLastLabel: true,
                      interval: 1,
                      radiusFactor: 0.8,
                      labelOffset: 0.1,
                      offsetUnit: GaugeSizeUnit.factor,
                      minorTicksPerInterval: 4,
                      tickOffset: 0.03,
                      minorTickStyle: const MinorTickStyle(
                          length: 0.06, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
                      majorTickStyle: const MajorTickStyle(
                          length: 0.1, lengthUnit: GaugeSizeUnit.factor),
                      axisLabelStyle: const GaugeTextStyle(fontSize: 12),
                      axisLineStyle: const AxisLineStyle(
                          thickness: 0.01, thicknessUnit: GaugeSizeUnit.factor),
                      pointers: <GaugePointer>[
                        NeedlePointer(
                            needleEndWidth: 2,
                            value: hours / 1 + minutes / 60,
                            needleColor: _needleColor,
                            knobStyle: const KnobStyle(knobRadius: 0)),
                        NeedlePointer(
                            needleLength: 0.85,
                            needleStartWidth: 0.5,
                            needleEndWidth: 1.5,
                            value: minutes / 5 + seconds / (60 * 5),
                            knobStyle: const KnobStyle(
                                color: Color(0xFF00A8B5), knobRadius: 0.05),
                            needleColor: _needleColor),
                        NeedlePointer(
                            needleLength: 0.9,
                            enableAnimation: false,
                            animationType: AnimationType.bounceOut,
                            animationDuration: 500,
                            needleStartWidth: 0.8,
                            needleEndWidth: 0.8,
                            value: (seconds / 5),
                            needleColor: const Color(0xFF00A8B5),
                            tailStyle: const TailStyle(
                                width: 0.8, length: 0.2, color: Color(0xFF00A8B5)),
                            knobStyle:
                            const KnobStyle(knobRadius: 0.03, color: Colors.white)),
                      ]),
                ],
              );
            }
        ),
      ),
    );
  }

}