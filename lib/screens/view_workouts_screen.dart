// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/workout_data_container.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

class ViewWorkoutsScreen extends StatelessWidget {
  final String workoutName;
  final String database;
  ViewWorkoutsScreen(
      {super.key, required this.workoutName, required this.database});

  final fire = FirebaseFirestore.instance;
  final Map<String, dynamic> workoutData = {};

  Future getWorkoutData() async {
    await fire
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc(database)
        .collection('workouts')
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        workoutData.addAll({result.id: result.data()});
      }
    });
    log(workoutData.toString());
  }

  @override
  Widget build(BuildContext context) {
    String date;
    String title;
    if (database == 'log') {
      title = DateFormat('hh:mm dd/MM/yy').format(DateTime.parse(workoutName));
    } else {
      title = workoutName;
    }
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            title,
          )),
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
                          DateFormat('hh:mm dd/MM/yy').format(DateTime.parse(
                              workoutData[workoutName].values.elementAt(0))),
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
                              notes: workoutData[workoutName][
                                      workoutData[workoutName]
                                          .keys
                                          .elementAt(i)]['notes'] ??
                                  ''),
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
