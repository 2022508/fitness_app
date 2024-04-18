// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:fitness_app/components/workouts_button.dart';
import 'package:flutter/material.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
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
                    // alignment: Alignment.center,
                    width: width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text("Line",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black))),
                          Text(
                            "/",
                            style: TextStyle(fontSize: 30),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text("Bar",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black))),
                        ])),
                SizedBox(height: 20),
                Container(
                  width: width * 0.7,
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.fitness_center),
                                hintText: "Exercise")),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width,
                  child: Image.asset('assets/images/barChart.png'),
                ),
                Container(
                  width: width,
                  margin: const EdgeInsets.all(30),
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Recent workouts',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyWorkoutsButton(text: "08/04/2024"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    )));
  }
}
