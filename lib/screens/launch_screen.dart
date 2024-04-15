import 'package:fitness_app/components/elevated_button.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Column(
            children: [
              SizedBox(height: 200),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Fitness App', style: TextStyle(fontSize: 30)),
              ),
              SizedBox(height: 300),
              Row(
                children: [
                  Expanded(child: MyElevatedButton(text: "Log in")),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: MyElevatedButton(text: "Sign up")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
