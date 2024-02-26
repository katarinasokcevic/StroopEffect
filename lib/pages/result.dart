import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'leaderboard.dart';

class ResultData {
  final String userId;
  final String timestamp;
  String? nickname;
  int? correctEnglish;
  double? timeEnglish;
  int? correctCroatian;
  double? timeCroatian;
  ResultData(this.userId, this.timestamp);
}

class ResultPage extends StatelessWidget {
  final double timeTaken;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool isEnglish;
  final bool bothLanguagesPlayed;
  final String timestamp;


  ResultPage(this.timeTaken, this.correctAnswers, this.incorrectAnswers,
      this.isEnglish, this.bothLanguagesPlayed, this.timestamp);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    uploadUserResults(
        userId, timeTaken, correctAnswers, incorrectAnswers, isEnglish, timestamp);
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
                  buildText('Language: ${isEnglish ? 'English' : 'Croatian'}', context),
                  buildText('Time taken: $timeTaken seconds', context),
                  buildText('Correct answers: $correctAnswers', context),
                  buildText('Incorrect answers: $incorrectAnswers', context),
                  SizedBox(height: 16),
                  if (bothLanguagesPlayed)
                    ElevatedButton(
                      onPressed: () {
                        _showNameInputDialog(context);
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
                                  isCroatian: isEnglish, isSecondRound: true, timestamp: timestamp)),
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

  void _showNameInputDialog(BuildContext context) {
    String name = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your name for the leaderboard'),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(hintText: "Name"),
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
                User? user = FirebaseAuth.instance.currentUser;
                String userId = user!.uid;
                var results = await currentResults(userId, timestamp);
                results.nickname = name;
                saveResult(results);

                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderboardPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Future<void> uploadUserResults(String userId, double timeTaken,
      int correctAnswers, int incorrectAnswers, bool isEnglish, String timestamp ) async {
    var resultData = await currentResults(userId,timestamp);
    if (isEnglish) {
      resultData.correctEnglish = correctAnswers;
      resultData.timeEnglish = timeTaken;
    } else {
      resultData.correctCroatian = correctAnswers;
      resultData.timeCroatian = timeTaken;
    }
    await saveResult(resultData);
  }

  Future<ResultData> currentResults(String userId, String timestamp) async {
    var db = FirebaseFirestore.instance;
    ResultData data = ResultData(userId, timestamp!);
    final docSnap = await db.collection("results").doc(timestamp).get(const GetOptions(source: Source.server));
    final res = docSnap.data();
    if (res == null) {
      return data;
    }

    if (res['timeCroatian'] != null) {
      data.timeCroatian = res['timeCroatian'];
      data.correctCroatian = res['correctCroatian'];
    }
    if (res['timeEnglish'] != null) {
      data.timeEnglish = res['timeEnglish'];
      data.correctEnglish = res['correctEnglish'];
    }
    return data;
  }

  Future<void> saveResult(ResultData data) async {
    var db = FirebaseFirestore.instance;
    var dbData = <String, dynamic>{
      'userId': data.userId,
      'timestamp': data.timestamp,
      'timeCroatian': data.timeCroatian,
      'timeEnglish': data.timeEnglish,
      'correctEnglish': data.correctEnglish,
      'correctCroatian': data.correctCroatian,
      'nickname': data.nickname,
    };
    await db.collection("results").doc(timestamp).set(dbData);
  }
}
