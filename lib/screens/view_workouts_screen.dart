import 'package:fitness_app/components/workout_data_container.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewWorkoutsScreen extends StatelessWidget {
  final String workoutName;
  final String database;
  ViewWorkoutsScreen(
      {super.key, required this.workoutName, required this.database});

  final Map<String, dynamic> workoutData = {};
  final WorkoutDataService workoutDataService = WorkoutDataService();

  @override
  Widget build(BuildContext context) {
    String title;
    String notesTitle;
    if (database == 'log') {
      title = DateFormat('HH:mm dd/MM/yy').format(DateTime.parse(workoutName));
    } else {
      title = workoutName;
    }
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            title,
          )),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            FutureBuilder(
              future: workoutDataService.getWorkoutData(database, workoutData),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (database == 'create') {
                    notesTitle = title;
                    title = DateFormat('HH:mm dd/MM/yy').format(DateTime.parse(
                        workoutData[workoutName]['dateTime'].toString()));
                  } else {
                    notesTitle = workoutName;
                  }
                  if (workoutData.containsKey(workoutName)) {
                    var workout = workoutData[workoutName];
                    workout.removeWhere(
                        (key, value) => key == 'dates' || key == 'dateTime');
                  }
                  return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(title),
                        const SizedBox(height: 10),
                        for (int i = 0;
                            i < workoutData[workoutName].length;
                            i++)
                          MyWorkoutData(
                            exercise:
                                workoutData[workoutName].keys.elementAt(i),
                            reps: workoutData[workoutName]
                                    [workoutData[workoutName].keys.elementAt(i)]
                                ['reps'],
                            weight: workoutData[workoutName]
                                    [workoutData[workoutName].keys.elementAt(i)]
                                ['weight'],
                            notes: workoutData[workoutName][
                                    workoutData[workoutName]
                                        .keys
                                        .elementAt(i)]['notes'] ??
                                '',
                            db: database,
                            title: notesTitle,
                          ),
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
