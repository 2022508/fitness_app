// ignore_for_file: must_be_immutable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyLineChart extends StatefulWidget {
  late String title;
  final List<FlSpot> spotsWeight;

  MyLineChart({
    super.key,
    required this.title,
    required this.spotsWeight,
  });

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int lastIndex = widget.spotsWeight.length - 1;
    if (widget.title == '') widget.title = 'bench press';
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const SizedBox(height: 20),
        Text("${widget.title} (kg)", style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 20),
        SizedBox(
            width: double.infinity,
            height: width - 100,
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.grey[300],
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.spotsWeight,
                    color: Colors.blue,
                    barWidth: 2,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles:
                          SideTitles(reservedSize: 30, showTitles: true)),
                  rightTitles: AxisTitles(sideTitles: SideTitles()),
                  topTitles: AxisTitles(sideTitles: SideTitles()),
                  bottomTitles: AxisTitles(sideTitles: SideTitles()),
                ),
                gridData: const FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.6,
                  ),
                ),
              ),
            )),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: width / 15),
            Text(DateFormat('dd/MM/yy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.spotsWeight[0].x.toInt()))),
            const Spacer(),
            Text(DateFormat('dd/MM/yy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.spotsWeight[lastIndex].x.toInt()))),
          ],
        ),
        const SizedBox(height: 5),
      ]),
    );
  }
}
