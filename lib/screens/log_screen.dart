import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/chart.dart';
import 'package:fitness_app/components/search_bar.dart';
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
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection("log")
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
      onStatus: (status) => log('onStatus: $status'),
      onError: (errorNotification) => log('onError: $errorNotification'),
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
      log('The user has denied the use of speech recognition.');
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
                MySearchBar(
                    controller: exerciseController,
                    onSubmitted: (s) {
                      setState(() {
                        exercise = exerciseController.text.toLowerCase();
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onPressed: () {
                      setState(() {
                        exercise = exerciseController.text.toLowerCase();
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onPressedVoice: () {
                      voiceSearch();
                    }),
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
