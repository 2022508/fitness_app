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
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection(db)
        .get()
        .then((querySnapshot) {
      docIDs.clear();
      for (var result in querySnapshot.docs) {
        docIDs.add(result.id);
      }
    });
    return docIDs;
  }

  Future setWorkoutDataLog(String exercise, String weight, String reps,
      String notes, List docIDs, Map<String, dynamic> workoutData) async {
    DateTime lastWorkoutTime;
    DateTime finalTimeStamp = DateTime.now();
    bool isSameWorkout = false;

    await getDocId(docIDs, "log");
    await getWorkoutData("log", workoutData);
    if (docIDs.isNotEmpty) {
      lastWorkoutTime = DateTime.parse(
          workoutData[docIDs.last.toString()]['dates']['lastWorkoutTime']);
      if (DateTime.now().difference(lastWorkoutTime).inHours < 2) {
        finalTimeStamp = DateTime.parse(docIDs.last);
        isSameWorkout = true;
      }
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection('log')
        .doc(finalTimeStamp.toString())
        .set({
      exercise: {
        "reps": FieldValue.arrayUnion([double.parse(reps)]),
        "weight": FieldValue.arrayUnion([double.parse(weight)]),
        if (notes.isNotEmpty) "notes": notes,
      },
      "dates": {
        if (isSameWorkout != true) "dateTime": DateTime.now().toString(),
        "lastWorkoutTime": DateTime.now().toString(),
      }
    }, SetOptions(merge: true));
  }

  Future setWorkoutDataCreate(String name, String exercise, String weight,
      String reps, String notes, List docIDs) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection('create')
        .doc(name)
        .set({
      exercise: {
        "reps": FieldValue.arrayUnion([double.parse(reps)]),
        "weight": FieldValue.arrayUnion([double.parse(weight)]),
        if (notes.isNotEmpty) "notes": notes
      },
      "dateTime": DateTime.now().toString()
    }, SetOptions(merge: true));
  }

  Future getWorkoutData(String db, Map<String, dynamic> workoutData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection(db)
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        workoutData.addAll({result.id: result.data()});
      }
    });
  }

  Future updateNotes(
      String db, String title, String exercise, String notes) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection(db)
        .doc(title)
        .set({
      exercise: {
        "notes": notes,
      },
    }, SetOptions(merge: true));
  }

  Future deleteWorkoutDataLog(String email) async {
    CollectionReference collectionWorkouts = FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection("log");
    QuerySnapshot snapshotWorkouts = await collectionWorkouts.get();
    for (QueryDocumentSnapshot doc in snapshotWorkouts.docs) {
      doc.reference.delete();
    }
  }

  Future deleteWorkoutDataCreate(String email) async {
    CollectionReference collectionLog = FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection("create");
    QuerySnapshot snapshotLog = await collectionLog.get();
    for (QueryDocumentSnapshot doc in snapshotLog.docs) {
      doc.reference.delete();
    }
  }

  Future deleteUserData(String email) async {
    FirebaseFirestore.instance.collection("users").doc(email).delete();
  }
}
