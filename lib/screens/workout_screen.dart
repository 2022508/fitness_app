// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/workouts_button.dart';
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: MyElevatedButton(text: "Add")),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: MyWorkoutsButton(text: "08/04/2024")),
              ],
            ),
          )),
    )));
  }
}
