import 'package:fitness_app/services/auth_page.dart';
import 'package:fitness_app/services/notifications_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final permissionGranted = await NotificationServices.checkPermission();
  if (permissionGranted) {
    await NotificationServices.initialiseNotification();
    await NotificationServices.cancelNotification();
    await NotificationServices.displayNotification(
      title: 'Fitness App',
      body: "We haven't seen you in a while",
      scheduled: true,
      interval: 604800, // 1 week in seconds
    );
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAuth(),
    );
  }
}
