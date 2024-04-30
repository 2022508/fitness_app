// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';

class MyWorkoutData extends StatelessWidget {
  final String exercise;
  final String notes;
  final List<dynamic> reps;
  final List<dynamic> weight;
  final String? db;
  final String? title;

  const MyWorkoutData(
      {super.key,
      required this.exercise,
      required this.notes,
      required this.reps,
      required this.weight,
      this.db,
      this.title});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final double paddingWidth = width * 0.02;
    TextStyle exerciseTextStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
    TextStyle dataTextStyle =
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1);
    final WorkoutDataService workoutDataService = WorkoutDataService();
    TextEditingController notesController = TextEditingController(text: notes);

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
                              title: Column(
                                children: [
                                  Text("Notes"),
                                  TextField(
                                    controller: notesController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            notesController.text = notes;
                                          },
                                          child: Text("Close")),
                                      TextButton(
                                          onPressed: () {
                                            workoutDataService.updateNotes(
                                                db!,
                                                title!,
                                                exercise,
                                                notesController.text);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Save")),
                                    ],
                                  ),
                                ],
                              ),
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
