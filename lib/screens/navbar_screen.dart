// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/account_screen.dart';
import 'package:fitness_app/screens/create_screen.dart';
import 'package:fitness_app/screens/support_screen.dart';
import 'package:fitness_app/screens/log_screen.dart';
import 'package:fitness_app/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// https://www.youtube.com/watch?v=2UG4rdsCZKU
// used to help create the bottom navigation bar

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  PageController pageController = PageController(initialPage: 0);

  int myIndex = 0;
  List<Widget> myPages = [
    WorkoutScreen(),
    CreateScreen(),
    LogScreen(),
    SupportPage(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        // index: myIndex,
        controller: pageController,
        children: myPages,
        onPageChanged: (value) {
          setState(() {
            myIndex = value;
          });
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(201, 56, 11, 1),
          onTap: (value) {
            pageController.animateToPage(value,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          currentIndex: myIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center), label: 'Workout'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
            BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Log'),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_support), label: 'Support'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: 'Account'),
          ]),
    );
  }
}
