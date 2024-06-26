// ignore_for_file: must_be_immutable

import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/screens/view_workouts_screen.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutListScreen extends StatelessWidget {
  final String db;
  final String header;
  WorkoutListScreen({super.key, required this.db, required this.header});

  final WorkoutDataService workoutDataService = WorkoutDataService();
  List<dynamic> docIDs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(header),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Center(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: workoutDataService.getDocId(docIDs, db),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            docIDs = docIDs.reversed.toList();
                            String text;
                            return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: docIDs.length,
                                itemBuilder: (context, index) {
                                  if (db == 'log') {
                                    text = DateFormat('HH:mm dd/MM/yy')
                                        .format(DateTime.parse(docIDs[index]));
                                  } else {
                                    text = docIDs[index].toString();
                                  }
                                  return MyElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                ViewWorkoutsScreen(
                                              workoutName: docIDs[index],
                                              database: db,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      text: text);
                                });
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
