// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:developer';

// https://pub.dev/packages/speech_to_text
// package and its documentation used for voice search

// https://www.youtube.com/watch?v=ZHdg2kfKmjI
// used for live search

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  TextEditingController controller = TextEditingController();

  Future<void> voiceSearch() async {
    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize(
      onStatus: (status) => log('onStatus: $status'),
      onError: (errorNotification) => log('onError: $errorNotification'),
    );
    if (available) {
      speech.listen(
        onResult: (result) {
          controller.text = result.recognizedWords;
        },
        listenFor: Duration(seconds: 5),
      );
    } else {
      log('The user has denied the use of speech recognition.');
    }
  }

  var fire = FirebaseFirestore.instance;

  Map<String, dynamic> exercisesList = {};
  Map<String, dynamic> exercisesListHolder = {};

  Future getInfo() async {
    await fire.collection('support').get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        exercisesList.addAll({result.id: result.data()});
      }
    });
    setState(() {
      exercisesListHolder = exercisesList;
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void searchExercise(String query) {
    final suggestions = exercisesListHolder.entries.where((exercise) {
      final title = exercise.key.toLowerCase();
      final searchLower = query.toLowerCase();
      return title.contains(searchLower);
    }).toList();
    setState(() {
      exercisesList = Map.fromEntries(suggestions);
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (s) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: searchExercise,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search exercises',
                      prefixIcon: IconButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        icon: Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          voiceSearch();
                        },
                        icon: Icon(
                          Icons.mic,
                          size: 30,
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    color: Colors.grey[200],
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: exercisesList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              exercisesList.keys.elementAt(index).toString()),
                          subtitle: TextButton(
                              onPressed: () {
                                _launchUrl(Uri.parse(exercisesList.values
                                    .elementAt(index)['link']));
                              },
                              child: Text(exercisesList.values
                                  .elementAt(index)['link']
                                  .toString())),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
