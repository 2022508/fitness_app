import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/screens/view_workouts_screen.dart';
import 'package:fitness_app/screens/workouts_list_screen.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  TextEditingController exerciseController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final WorkoutDataService workoutDataService = WorkoutDataService();

  final Map<String, dynamic> workoutData = {};

  void clearFields() {
    exerciseController.clear();
    weightController.clear();
    repsController.clear();
    notesController.clear();
  }

  List<dynamic> docIDs = [];

  Future setWorkoutData() async {
    if (exerciseController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        repsController.text.isNotEmpty) {
      workoutDataService.setWorkoutDataLog(
          exerciseController.text.toLowerCase(),
          weightController.text,
          repsController.text,
          notesController.text,
          docIDs,
          workoutData);
      clearFields();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Not all fields are filled out!"),
            );
          });
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.all(15),
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Workout',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w400)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            child: MyTextField(
                                controller: exerciseController,
                                hintText: "Exercise",
                                prefixIcon: const Icon(Icons.fitness_center)))
                      ]),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: MyTextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: weightController,
                                  hintText: "Weight",
                                  prefixIcon:
                                      const Icon(Icons.fitness_center))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: MyTextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: repsController,
                                  hintText: "Reps",
                                  prefixIcon:
                                      const Icon(Icons.fitness_center))),
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        contentPadding: const EdgeInsets.all(5),
                                        title: const Text("Notes"),
                                        content: TextField(
                                            controller: notesController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText: "Notes")),
                                        actions: [
                                          Row(
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Close")),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                "Notes (optional)",
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: MyElevatedButton(
                                  onPressed: setWorkoutData, text: "Add"))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Expanded(child: Divider(height: 10)),
                    Padding(
                      padding: EdgeInsets.only(left: 7, right: 7),
                      child: Text(
                        "Recent workouts",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Expanded(child: Divider(height: 10)),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: workoutDataService.getDocId(docIDs, "log"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        docIDs = docIDs.reversed.toList();
                        int length = docIDs.length;
                        if (docIDs.length > 3) {
                          length = 3;
                        } else {
                          length = docIDs.length;
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: length,
                            itemBuilder: (context, index) {
                              return MyElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            ViewWorkoutsScreen(
                                          workoutName: docIDs[index],
                                          database: "log",
                                        ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  text: DateFormat('HH:mm dd/MM/yy')
                                      .format(DateTime.parse(docIDs[index])));
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                Row(
                  children: [
                    const Expanded(child: Divider(height: 10)),
                    Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: TextButton(
                        child: const Text("View more",
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => WorkoutListScreen(
                                  db: "log", header: "Workouts Completed"),
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0, 1);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .animate(CurvedAnimation(
                                        parent: animation, curve: curve));

                                return SlideTransition(
                                  position: tween,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const Expanded(child: Divider(height: 10)),
                  ],
                ),
              ],
            ),
          )),
    )));
  }
}
