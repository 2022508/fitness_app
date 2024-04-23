// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/account_screen.dart';
import 'package:fitness_app/screens/create_screen.dart';
import 'package:fitness_app/screens/homepage_screen.dart';
import 'package:fitness_app/screens/log_screen.dart';
import 'package:fitness_app/screens/workout_screen.dart';
import 'package:flutter/material.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  int myIndex = 0;
  List<Widget> myPages = [
    HomePage(),
    CreateScreen(),
    WorkoutScreen(),
    LogScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IndexedStack(
        index: myIndex,
        children: myPages,
      )),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(201, 56, 11, 1),
          // backgroundColor: Color.fromRGBO(170, 91, 67, 1),
          onTap: (value) {
            if (value == 5) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LaunchScreen()),
              // );
              signOut();
            } else {
              setState(() {
                myIndex = value;
              });
            }
          },
          currentIndex: myIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center), label: 'Workout'),
            BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Log'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: 'Account'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
          ]),
    );
  }
}
