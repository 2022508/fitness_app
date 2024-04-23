// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/screens/view_workouts_screen.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextStyle exerciseTextStyle =
      TextStyle(fontSize: 35, fontWeight: FontWeight.w400);
  TextStyle dataTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w300);

  TextEditingController nameController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  final WorkoutDataService workoutDataService =
      WorkoutDataService(exercise: 'Bench Press', reps: 10, weight: 100);

  Map<String, dynamic> workoutData = {};

  var fire = FirebaseFirestore.instance;

  List<dynamic> docIDs = [];

  Future getDocId() async {
    await fire.collection('create').get().then((querySnapshot) {
      docIDs.clear();
      for (var result in querySnapshot.docs) {
        docIDs.add(result.id);
      }
    });
  }

  Future setWorkoutData() async {
    await fire.collection('create').doc(nameController.text).set({
      exerciseController.text: {
        "reps": FieldValue.arrayUnion([double.parse(repsController.text)]),
        "weight": FieldValue.arrayUnion([double.parse(weightController.text)])
      },
      "dateTime": Timestamp.now()
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
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
                            Row(children: [
                              Expanded(
                                  child: MyTextField(
                                      controller: nameController,
                                      hintText: "Workout name",
                                      prefixIcon: Icon(Icons.fitness_center)))
                            ]),
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
                                        prefixIcon:
                                            Icon(Icons.fitness_center))),
                                SizedBox(width: 10),
                                Expanded(
                                    child: MyTextField(
                                        controller: repsController,
                                        hintText: "Reps",
                                        prefixIcon:
                                            Icon(Icons.fitness_center))),
                              ],
                            ),
                            SizedBox(height: 5),
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
                      // MyWorkoutData(),
                      SizedBox(height: 10),
                      // MyWorkoutData(),

                      FutureBuilder(
                          future: getDocId(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
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
                                                workoutName:
                                                    docIDs[index].toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        text: docIDs[index].toString());
                                  });
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ])))));
  }
}
