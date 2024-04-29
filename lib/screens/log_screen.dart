// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/chart.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'dart:developer';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  TextEditingController exerciseController = TextEditingController();
  String exercise = 'bench press';
  final Map<String, dynamic> workoutData = {};
  List<FlSpot> spotsWeight = [];
  // List<FlSpot> spotsReps = [];
  var fire = FirebaseFirestore.instance;

  Future getWorkoutData(String exercise) async {
    workoutData.clear();
    spotsWeight.clear();

    // spotsReps.clear();
    await fire
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc('log')
        .collection('workouts')
        .get()
        .then((querySnapshot) {
      // double averageWeight = 0;
      // double date = 0;
      List<dynamic> exerciseWeight = [];
      for (var result in querySnapshot.docs) {
        workoutData.addAll({result.id: result.data()});
      }
      workoutData.forEach((key, value) {
        double averageWeight = 0;
        if (value.containsKey(exercise)) {
          // weight
          exerciseWeight = value[exercise]['weight'];
          for (var element in exerciseWeight) {
            averageWeight += element;
          }
          averageWeight = averageWeight / exerciseWeight.length;
          spotsWeight.add(FlSpot(
              DateTime.parse(value['dates']['dateTime'])
                  .millisecondsSinceEpoch
                  .toDouble(),
              averageWeight));
        }
      });
    });
    // log(workoutData.toString());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  width: width * 0.7,
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: TextField(
                      //       controller: exerciseController,
                      //       decoration: InputDecoration(
                      //           prefixIcon: Icon(Icons.fitness_center),
                      //           hintText: "Exercise")),
                      // ),
                      Expanded(
                          child: MyTextField(
                        hintText: "Exercise",
                        controller: exerciseController,
                        prefixIcon: Icon(Icons.fitness_center),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              exercise = exerciseController.text;
                            });
                          },
                        ),
                      )),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: width,
                //   child: Image.asset('assets/images/barChart.png'),
                // ),
                SizedBox(
                    width: double.infinity,
                    height: width + 100,
                    child: FutureBuilder(
                        future: getWorkoutData(exercise),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return MyLineChart(
                              title: exercise,
                              spotsWeight: spotsWeight,
                              // spotsReps: spotsReps
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        })),
              ],
            ),
          )),
    )));
  }
}
