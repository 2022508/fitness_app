// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/screens/view_workouts_screen.dart';
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
  TextEditingController notesController = TextEditingController();

  Map<String, dynamic> workoutData = {};

  var fire = FirebaseFirestore.instance;

  List<dynamic> docIDs = [];

  Future getDocId() async {
    await fire
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc('create')
        .collection('workouts')
        .get()
        .then((querySnapshot) {
      docIDs.clear();
      for (var result in querySnapshot.docs) {
        docIDs.add(result.id);
      }
    });
  }

  Future setWorkoutData() async {
    if (nameController.text.isNotEmpty &&
        exerciseController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        repsController.text.isNotEmpty) {
      await fire
          .collection(FirebaseAuth.instance.currentUser!.email!)
          .doc('create')
          .collection('workouts')
          .doc(nameController.text)
          .set({
        exerciseController.text: {
          "reps": FieldValue.arrayUnion([double.parse(repsController.text)]),
          "weight":
              FieldValue.arrayUnion([double.parse(weightController.text)]),
          if (notesController.text.isNotEmpty) "notes": notesController.text
        },
        "dateTime": DateTime.now().toString()
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
                    ])))));
  }
}
