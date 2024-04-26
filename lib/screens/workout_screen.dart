// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/screens/view_workouts_screen.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:intl/intl.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  TextEditingController exerciseController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final WorkoutDataService workoutDataService = WorkoutDataService();

  final Map<String, dynamic> workoutData = {};

  var fire = FirebaseFirestore.instance;
  void clearFields() {
    exerciseController.clear();
    weightController.clear();
    repsController.clear();
    notesController.clear();
  }

  List<dynamic> docIDs = [];

  Future setWorkoutData() async {
    if (exerciseController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        repsController.text.isNotEmpty) {
      DateTime lastWorkoutTime;
      DateTime finalTimeStamp = DateTime.now();
      bool isSameWorkout = false;

      await workoutDataService.getDocId(docIDs, "log");
      await getWorkoutData();
      if (docIDs.isNotEmpty) {
        lastWorkoutTime = DateTime.parse(
            workoutData[docIDs.last.toString()]['dates']['lastWorkoutTime']);
        if (DateTime.now().difference(lastWorkoutTime).inHours < 2) {
          finalTimeStamp = DateTime.parse(docIDs.last);
          isSameWorkout = true;
        }
      }
      await fire
          .collection(FirebaseAuth.instance.currentUser!.email!)
          .doc('log')
          .collection('workouts')
          .doc(finalTimeStamp.toString())
          .set({
        exerciseController.text: {
          "reps": FieldValue.arrayUnion([double.parse(repsController.text)]),
          "weight":
              FieldValue.arrayUnion([double.parse(weightController.text)]),
          if (notesController.text.isNotEmpty) "notes": notesController.text,
        },
        "dates": {
          if (isSameWorkout != true) "dateTime": DateTime.now().toString(),
          "lastWorkoutTime": DateTime.now().toString(),
        }
      }, SetOptions(merge: true));
      clearFields();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Not all fields are filled out!"),
            );
          });
    }
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {});
  }

  Future getWorkoutData() async {
    await fire
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc('log')
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: width,
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w400)),
                      SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            child: MyTextField(
                                controller: exerciseController,
                                hintText: "Exercise",
                                prefixIcon: Icon(Icons.fitness_center)))
                      ]),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: MyTextField(
                                  controller: weightController,
                                  hintText: "Weight",
                                  prefixIcon: Icon(Icons.fitness_center))),
                          SizedBox(width: 10),
                          Expanded(
                              child: MyTextField(
                                  controller: repsController,
                                  hintText: "Reps",
                                  prefixIcon: Icon(Icons.fitness_center))),
                        ],
                      ),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.all(5),
                                        title: Text("Notes"),
                                        content: TextField(
                                            controller: notesController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText: "Notes")),
                                        actions: [
                                          Row(
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Close")),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                "Notes (optional)",
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: MyElevatedButton(
                                  onPressed: setWorkoutData, text: "Add"))
                        ],
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: workoutDataService.getDocId(docIDs, "log"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: docIDs.length,
                            itemBuilder: (context, index) {
                              return MyElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewWorkoutsScreen(
                                          workoutName: docIDs[index],
                                          database: "log",
                                        ),
                                      ),
                                    );
                                  },
                                  text: DateFormat('HH:mm dd/MM/yy')
                                      .format(DateTime.parse(docIDs[index])));
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ),
          )),
    )));
  }
}
