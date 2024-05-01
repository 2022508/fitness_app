import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/chart.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:developer';

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
  var fire = FirebaseFirestore.instance;

  Future getWorkoutData(String exercise) async {
    workoutData.clear();
    spotsWeight.clear();
    await fire
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc('log')
        .collection('workouts')
        .get()
        .then((querySnapshot) {
      List<dynamic> exerciseWeight = [];
      for (var result in querySnapshot.docs) {
        workoutData.addAll({result.id: result.data()});
      }
      workoutData.forEach((key, value) {
        double averageWeight = 0;
        if (value.containsKey(exercise)) {
          exerciseWeight = value[exercise]['weight'];
          for (var element in exerciseWeight) {
            averageWeight += element;
          }
          averageWeight = averageWeight / exerciseWeight.length;
          averageWeight = double.parse(averageWeight.toStringAsFixed(0));
          spotsWeight.add(FlSpot(
              DateTime.parse(value['dates']['dateTime'])
                  .millisecondsSinceEpoch
                  .toDouble(),
              averageWeight));
        }
      });
    });
  }

  Future<void> voiceSearch() async {
    FocusManager.instance.primaryFocus?.unfocus();
    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) => print('onError: $errorNotification'),
    );
    if (available) {
      speech.listen(
        onResult: (result) {
          exerciseController.text = result.recognizedWords;
          setState(() {
            exercise = exerciseController.text.toLowerCase();
          });
        },
        listenFor: const Duration(seconds: 5),
      );
    } else {
      print('The user has denied the use of speech recognition.');
    }
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
                const SizedBox(height: 20),
                // Container(
                // width: width * 0.7,
                // color: Colors.grey[200],
                // child: Row(
                // children: [
                // Expanded(
                // child:
                TextField(
                  controller: exerciseController,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (s) {
                    setState(() {
                      exercise = exerciseController.text.toLowerCase();
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search exercises',
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          exercise = exerciseController.text.toLowerCase();
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        voiceSearch();
                      },
                      icon: const Icon(
                        Icons.mic,
                        size: 30,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //     MyTextField(
                //   hintText: "Exercise",
                //   controller: exerciseController,
                //   prefixIcon: const Icon(Icons.fitness_center),
                //   suffixIcon: IconButton(
                //     icon: const Icon(Icons.search),
                //     onPressed: () {
                //       FocusManager.instance.primaryFocus?.unfocus();
                //       setState(() {
                //         exercise = exerciseController.text.toLowerCase();
                //       });
                //     },
                //   ),
                //   onSubmitted: (s) {
                //     FocusManager.instance.primaryFocus?.unfocus();
                //     setState(() {
                //       exercise = exerciseController.text.toLowerCase();
                //     });
                //   },
                // )
                // ),
                // ],
                // ),
                // ),
                SizedBox(
                    width: double.infinity,
                    height: width + 100,
                    child: FutureBuilder(
                        future: getWorkoutData(exercise),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (spotsWeight.isNotEmpty) {
                              return MyLineChart(
                                title: exercise,
                                spotsWeight: spotsWeight,
                              );
                            }
                            return const Center(child: Text('No data found'));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
              ],
            ),
          )),
    )));
  }
}
