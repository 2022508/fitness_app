// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyWorkoutData extends StatelessWidget {
  final String exercise;
  final String notes;
  final List<dynamic> reps;
  final List<dynamic> weight;

  const MyWorkoutData(
      {super.key,
      required this.exercise,
      required this.notes,
      required this.reps,
      required this.weight});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final double paddingWidth = width * 0.02;
    TextStyle exerciseTextStyle =
        TextStyle(fontSize: 25, fontWeight: FontWeight.w500);
    TextStyle dataTextStyle =
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(paddingWidth),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
              width: width * 0.47,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Text(exercise, style: exerciseTextStyle),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(notes),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.notes,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ],
              )),
          SizedBox(width: width * 0.03),
          Container(
            width: width * 0.34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
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
