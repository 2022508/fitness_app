// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyWorkoutData extends StatelessWidget {
  final String exercise;
  final List<double> reps;
  final List<double> weight;

  const MyWorkoutData(
      {super.key,
      required this.exercise,
      required this.reps,
      required this.weight});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final double paddingWidth = width * 0.02;
    TextStyle exerciseTextStyle =
        TextStyle(fontSize: 25, fontWeight: FontWeight.w500);
    TextStyle dataTextStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w400, height: 1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(paddingWidth),
      child: Row(
        children: [
          Container(
              width: width * 0.53,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.black.withOpacity(0.7),
                  width: width * 0.01,
                ),
              ),
              child: Text(exercise, style: exerciseTextStyle)),
          SizedBox(width: width * 0.03),
          Container(
            width: width * 0.34,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black.withOpacity(0.7),
                width: width * 0.01,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: paddingWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < reps.length; i++)
                    Row(
                      children: [
                        Text("${reps[i].toStringAsFixed(0)} reps, ",
                            style: dataTextStyle),
                        Text("${weight[i].toStringAsFixed(0)} kg",
                            style: dataTextStyle)
                      ],
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
