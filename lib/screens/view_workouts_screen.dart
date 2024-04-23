// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/components/workout_data_container.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ViewWorkoutsScreen extends StatelessWidget {
  final String workoutName;
  ViewWorkoutsScreen({super.key, required this.workoutName});

  final fire = FirebaseFirestore.instance;
  final Map<String, dynamic> workoutData = {};

  Future getWorkoutData() async {
    await fire.collection('create').get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        workoutData.addAll({result.id: result.data() as Map<String, dynamic>});
      }
    });
    log(workoutData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            FutureBuilder(
              future: getWorkoutData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          workoutName,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        for (int i = 1;
                            i < workoutData[workoutName].length;
                            i++)
                          MyWorkoutData(
                            exercise:
                                workoutData[workoutName].keys.elementAt(i),
                            reps: workoutData[workoutName]
                                    [workoutData[workoutName].keys.elementAt(i)]
                                ['reps'],
                            weight: workoutData[workoutName]
                                    [workoutData[workoutName].keys.elementAt(i)]
                                ['weight'],
                          )
                      ],
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
