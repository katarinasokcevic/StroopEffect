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
  final ResultData resultData;


  ResultPage(this.timeTaken, this.correctAnswers, this.incorrectAnswers,
      this.isEnglish, this.bothLanguagesPlayed, this.resultData);

  @override
  Widget build(BuildContext context) {
    uploadUserResults(
        resultData, timeTaken, correctAnswers, isEnglish);
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
                  Text('Language: ${isEnglish ? 'English' : 'Croatian'}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('Time taken: $timeTaken seconds',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('Correct answers: $correctAnswers',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('Incorrect answers: $incorrectAnswers',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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
                                  isCroatian: isEnglish, isSecondRound: true, resultData: resultData)),
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
                resultData.nickname = name;
                saveResult();

                //Navigator.of(context).pop();
                if (context.mounted) { // Check if the widget is still mounted
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaderboardPage(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadUserResults(ResultData resultData, double timeTaken,
      int correctAnswers, bool isEnglish) async {
    if (isEnglish) {
      resultData.correctEnglish = correctAnswers;
      resultData.timeEnglish = timeTaken;
    } else {
      resultData.correctCroatian = correctAnswers;
      resultData.timeCroatian = timeTaken;
    }
  }


  Future<void> saveResult() async {
    var db = FirebaseFirestore.instance;
    var dbData = <String, dynamic>{
      'userId': resultData.userId,
      'timestamp': resultData.timestamp,
      'timeCroatian': resultData.timeCroatian,
      'timeEnglish': resultData.timeEnglish,
      'correctEnglish': resultData.correctEnglish,
      'correctCroatian': resultData.correctCroatian,
      'nickname': resultData.nickname,
    };
    await db.collection("results").doc(resultData.timestamp).set(dbData);
  }
}
