import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutDataService {
  late String? workoutName;
  late String? exercise;
  late double? reps;
  late double? weight;

  WorkoutDataService({this.exercise, this.reps, this.weight});

  Future<List<dynamic>> getDocId(List docIDs, String db) async {
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc(db)
        .collection('workouts')
        .get()
        .then((querySnapshot) {
      docIDs.clear();
      for (var result in querySnapshot.docs) {
        docIDs.add(result.id);
      }
    });
    return docIDs;
  }
}
