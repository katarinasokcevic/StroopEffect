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
          title: const Text('Enter your name and lastname for the leaderboard'),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(hintText: "Name and lastname"),
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
                resultData.nickname = name;
                saveResult();

                if (context.mounted) {
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
    await saveFirstResult(resultData);
    await calculateAndSaveAverages();
  }

  Future<void> saveFirstResult(ResultData resultData) async {
    var db = FirebaseFirestore.instance;
    var userDocRef = db.collection('FirstResults').doc(resultData.userId);
    var userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      var dbData = <String, dynamic>{
        'timeCroatian': resultData.timeCroatian,
        'timeEnglish': resultData.timeEnglish,
        'correctEnglish': resultData.correctEnglish,
        'correctCroatian': resultData.correctCroatian,
      };

      await userDocRef.set(dbData);
    }
  }

  Future<void> calculateAndSaveAverages() async {
    var averages = await calculateAverages();
    await saveAveragesToFirestore(averages);
  }

  Future<Map<String, dynamic>> calculateAverages() async {
    var db = FirebaseFirestore.instance;
    var firstResultsQuery = await db.collection('FirstResults').get();

    double totalAverageTimeCroatian = 0;
    double totalAverageTimeEnglish = 0;
    int totalCorrectAnswersCroatian = 0;
    int totalCorrectAnswersEnglish = 0;
    int userCount = 0;

    for (var resultDoc in firstResultsQuery.docs) {
      var timeCroatian = resultDoc['timeCroatian'] as double?;
      var timeEnglish = resultDoc['timeEnglish'] as double?;
      var correctCroatian = resultDoc['correctCroatian'] as int?;
      var correctEnglish = resultDoc['correctEnglish'] as int?;

      if (timeCroatian != null && timeEnglish != null && correctCroatian != null && correctEnglish != null) {
        totalAverageTimeCroatian += timeCroatian;
        totalAverageTimeEnglish += timeEnglish;
        totalCorrectAnswersCroatian += correctCroatian;
        totalCorrectAnswersEnglish += correctEnglish;
        userCount++;
      }
    }

    if (userCount > 0) {
      double averageTimeCroatian = totalAverageTimeCroatian / userCount;
      double averageTimeEnglish = totalAverageTimeEnglish / userCount;
      double averageCorrectAnswersCroatian = totalCorrectAnswersCroatian / userCount;
      double averageCorrectAnswersEnglish = totalCorrectAnswersEnglish / userCount;

      return {
        'averageTimeCroatian': averageTimeCroatian,
        'averageTimeEnglish': averageTimeEnglish,
        'averageCorrectAnswersCroatian': averageCorrectAnswersCroatian,
        'averageCorrectAnswersEnglish': averageCorrectAnswersEnglish,
      };
    } else {
      return {
        'averageTimeCroatian': 0.0,
        'averageTimeEnglish': 0.0,
        'averageCorrectAnswersCroatian': 0.0,
        'averageCorrectAnswersEnglish': 0.0,
      };
    }
  }

  Future<void> saveAveragesToFirestore(Map<String, dynamic> averages) async {
    var db = FirebaseFirestore.instance;

    var dbData = <String, dynamic>{
      'averageTimeCroatian': averages['averageTimeCroatian'],
      'averageTimeEnglish': averages['averageTimeEnglish'],
      'averageCorrectAnswersCroatian': averages['averageCorrectAnswersCroatian'],
      'averageCorrectAnswersEnglish': averages['averageCorrectAnswersEnglish'],
    };
    await db.collection("AverageResults").doc('averages').set(dbData);
  }

}
