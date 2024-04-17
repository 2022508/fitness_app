// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyWorkoutData extends StatelessWidget {
  const MyWorkoutData({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final double paddingWidth = width * 0.02;
    TextStyle exerciseTextStyle =
        TextStyle(fontSize: 35, fontWeight: FontWeight.w400);
    TextStyle dataTextStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.w300);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(paddingWidth),
      child: Row(
        children: [
          Container(
              width: width * 0.67,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.black.withOpacity(0.7),
                  width: width * 0.01,
                ),
              ),
              child: Text('Bench Press', style: exerciseTextStyle)),
          SizedBox(width: width * 0.05),
          Container(
            width: width * 0.2,
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
                  Text("8 reps", style: dataTextStyle),
                  Text("60 kg", style: dataTextStyle)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
