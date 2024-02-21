import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'game.dart';
import 'leaderboard.dart';

class ResultPage extends StatelessWidget {
  final double timeTaken;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool isEnglish;
  final bool bothLanguagesPlayed;
  static String? timestamp;

  ResultPage(this.timeTaken, this.correctAnswers, this.incorrectAnswers,
      this.isEnglish, this.bothLanguagesPlayed);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    uploadUserResults(
        userId, timeTaken, correctAnswers, incorrectAnswers, isEnglish);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Language: ${isEnglish ? 'English' : 'Croatian'}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Time taken: $timeTaken seconds',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Correct answers: $correctAnswers',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Incorrect answers: $incorrectAnswers',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 16),
                  if (bothLanguagesPlayed)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String name = '';
                            return AlertDialog(
                              title:
                                  const Text('Enter your name for leaderboard'),
                              content: TextField(
                                onChanged: (value) {
                                  name = value;
                                },
                                decoration:
                                    const InputDecoration(hintText: "Name"),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Submit'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(25),
                                  ),
                                  onPressed: () async {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    String userId = user!.uid;
                                    List<String> languages = [
                                      'croatian',
                                      'english'
                                    ];

                                    for (var language in languages) {
                                      Reference refResults =
                                          FirebaseStorage.instance.ref(
                                              '$userId/${language}_results_$timestamp.txt');
                                      Uint8List? data =
                                          await refResults.getData();
                                      String results =
                                          utf8.decode(data as List<int>);
                                      results += 'Name: $name';
                                      await refResults.putString(results);
                                    }

                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LeaderboardPage()),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(25),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GamePage(
                                  isCroatian: isEnglish, isSecondRound: true)),
                        );
                      },
                      child: Text('Continue to the second language'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(25),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadUserResults(String userId, double timeTaken,
      int correctAnswers, int incorrectAnswers, bool language) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference userFolderRef = storage.ref(userId);

    String data = 'Time taken: $timeTaken seconds\n'
        'Correct answers: $correctAnswers\n';

    timestamp ??= DateFormat('ddHHmmss').format(DateTime.now());

    if (language) {
      Reference resultFileRef =
          userFolderRef.child('english_results_$timestamp.txt');
      await resultFileRef.putString(data);
    } else {
      Reference resultFileRef =
          userFolderRef.child('croatian_results_$timestamp.txt');
      await resultFileRef.putString(data);
    }
  }
}
