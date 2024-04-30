// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/screens/view_workouts_screen.dart';
import 'package:fitness_app/screens/workouts_list_screen.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/69501224/flutterfire-update-array-instead-of-replacing-it
// used to set the data for the workouts into firebase

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
  TextEditingController notesController = TextEditingController();

  Map<String, dynamic> workoutData = {};

  var fire = FirebaseFirestore.instance;

  final WorkoutDataService workoutDataService = WorkoutDataService();

  List<dynamic> docIDs = [];

  Future setWorkoutData() async {
    if (nameController.text.isNotEmpty &&
        exerciseController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        repsController.text.isNotEmpty) {
      workoutDataService.setWorkoutDataCreate(
          nameController.text,
          exerciseController.text,
          weightController.text,
          repsController.text,
          notesController.text,
          docIDs);
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

  void clearFields() {
    nameController.clear();
    exerciseController.clear();
    weightController.clear();
    repsController.clear();
    notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 40),
                    child: Column(children: [
                      Container(
                        width: width,
                        // margin: const EdgeInsets.all(30),
                        padding: const EdgeInsets.all(15),
                        color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Create',
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
                                                          Navigator.pop(
                                                              context);
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
                            // SizedBox(height: 5),
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
                      SizedBox(height: 30),
                      // MyWorkoutData(),
                      Row(
                        children: [
                          Expanded(child: Divider(height: 10)),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7),
                            child: Text(
                              "Recently created",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Expanded(child: Divider(height: 10)),
                        ],
                      ),
                      SizedBox(height: 10),
                      FutureBuilder(
                          future: workoutDataService.getDocId(docIDs, "create"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              int length = docIDs.length;
                              if (docIDs.length > 3) {
                                length = 3;
                              } else {
                                length = docIDs.length;
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: length,
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
                                                database: "create",
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
                      Row(
                        children: [
                          Expanded(child: Divider(height: 10)),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7),
                            child: TextButton(
                              child: Text("View more",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutListScreen(
                                        db: "create",
                                        header: "Workouts Created"),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(child: Divider(height: 10)),
                        ],
                      ),
                    ])))));
  }
}
