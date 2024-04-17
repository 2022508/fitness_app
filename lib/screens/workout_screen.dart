// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/workout_data_container.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<WorkoutDataService> workoutData = [
      WorkoutDataService(exercise: "Bench Press", reps: 1, weight: 60),
      WorkoutDataService(exercise: "Bench Press", reps: 2, weight: 60),
      WorkoutDataService(exercise: "Bench Press", reps: 3, weight: 55),
      WorkoutDataService(exercise: "Leg Press", reps: 4, weight: 80),
      WorkoutDataService(exercise: "Leg Press", reps: 5, weight: 80),
      WorkoutDataService(exercise: "Leg Press", reps: 6, weight: 80),
      WorkoutDataService(exercise: "Squats", reps: 7, weight: 40),
      WorkoutDataService(exercise: "Squats", reps: 8, weight: 40),
      WorkoutDataService(exercise: "Squats", reps: 9, weight: 40),
    ];
    //https://stackoverflow.com/questions/55579906/how-to-count-items-occurence-in-a-list

    Map<String, List<double>> map2 = {};
    List<double> reps = [];
    List<double> weight = [];
    bool isReps = true;
    for (var element in workoutData) {
      if (!map2.containsKey(element.exercise)) {
        map2[element.exercise] = [element.reps, element.weight];
      } else {
        map2[element.exercise]?.add(element.reps);
        map2[element.exercise]?.add(element.weight);
      }
    }
    try {
      for (var element in map2.entries) {
        for (var data in element.value) {
          if (isReps) {
            reps.add(data);
            isReps = false;
          } else {
            weight.add(data);
            isReps = true;
          }
        }
      }
    } catch (e) {
      print(e);
    }

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
                      Text(
                        'Enter',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // Divider(
                      //   height: 2,
                      // ),
                      // SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: "0",
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: "0",
                            child: Text("Bench Press"),
                          ),
                          DropdownMenuItem<String>(
                            value: "1",
                            child: Text("Leg Press"),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                      // unsure which form to go with for the exercise name
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fitness_center),
                                    hintText: "Exercise")),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fitness_center),
                                    hintText: "Weight")),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.repeat),
                                    hintText: "Reps")),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Entering past workouts?",
                              )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: MyElevatedButton(text: "Add")),
                        ],
                      ),
                    ],
                  ),
                ),
                for (int i = 0; i < map2.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MyWorkoutData(
                      exercise: map2.keys.elementAt(i),
                      reps: map2[map2.keys.elementAt(i)]!
                          .where((element) =>
                              map2[map2.keys.elementAt(i)]!.indexOf(element) %
                                  2 ==
                              0)
                          .toList(),
                      weight: map2[map2.keys.elementAt(i)]!
                          .where((element) =>
                              map2[map2.keys.elementAt(i)]!.indexOf(element) %
                                  2 !=
                              0)
                          .toList(),
                    ),
                  ),
              ],
            ),
          )),
    )));
  }
}
