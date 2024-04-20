// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/components/workouts_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/gradient1.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          // child: SingleChildScrollView(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Container(
          //       width: width,
          //       margin: const EdgeInsets.all(30),
          //       color: Colors.grey[200],
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text(
          //               'Recent workouts',
          //               style: TextStyle(
          //                 fontSize: 35,
          //                 fontWeight: FontWeight.w400,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: MyWorkoutsButton(text: "08/04/2024"),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        )));
  }
}
