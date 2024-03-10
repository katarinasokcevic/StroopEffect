import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stroop_effect/color_map.dart';
import 'package:stroop_effect/result_data.dart';
import '../answer_data.dart';
import '../base_scaffold.dart';
import 'game.dart';
import 'leaderboard.dart';

class ResultPage extends StatelessWidget {
  final double timeTaken;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool isCroatian;
  final bool bothLanguagesPlayed;
  final ResultData resultData;
  final List<AnswerData> answers;

  const ResultPage(this.timeTaken, this.correctAnswers, this.incorrectAnswers,
      this.isCroatian, this.bothLanguagesPlayed, this.resultData, this.answers, {super.key});

  @override
  Widget build(BuildContext context) {
    uploadUserResults(resultData, timeTaken, correctAnswers, isCroatian);
    return BaseScaffold(
      child: Center(
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
                  Text('Language: ${isCroatian ? 'Croatian' : 'English'}',
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
                  const SizedBox(height: 16),
                  if (bothLanguagesPlayed)
                    ElevatedButton(
                      onPressed: () {
                        _showNameInputDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(25),
                      ),
                      child: const Text('Submit'),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GamePage(
                                  isCroatian: !isCroatian, isSecondRound: true, resultData: resultData, answers: answers)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(25),
                      ),
                      child: Text('Continue to ${isCroatian ? 'English' : 'Croatian'}'),
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
          title: const Text('Enter your first and last name for the leaderboard'),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(hintText: "First and last name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(25),
              ),
              onPressed: () async {
                resultData.name = name;
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
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadUserResults(ResultData resultData, double timeTaken,
      int correctAnswers, bool isCroatian) async {
    if (isCroatian) {
      resultData.correctCroatian = correctAnswers;
      resultData.timeCroatian = timeTaken;
    } else {
      resultData.correctEnglish = correctAnswers;
      resultData.timeEnglish = timeTaken;
    }
  }

  Future<void> saveResult() async {
    var db = FirebaseFirestore.instance;
    List<Map<String, dynamic>> answersData = answers.map((result) {
      return {
        'questionNumber': result.questionNumber,
        'displayWord': result.displayedWord,
        'displayedColor': colorToString(result.displayedColor),
        'selectedColor': colorToString(result.selectedColor),
        'isCroatian': result.isCroatian ? "croatian" : "english",
        'isCorrect': result.isCorrect ? "correct" : "incorrect",
        'timeTaken': result.timeTaken,
      };
    }).toList();

    var dbData = <String, dynamic>{
      'userId': resultData.userId,
      'timestamp': resultData.timestamp,
      'timeCroatian': resultData.timeCroatian,
      'timeEnglish': resultData.timeEnglish,
      'correctEnglish': resultData.correctEnglish,
      'correctCroatian': resultData.correctCroatian,
      'name': resultData.name,
      'answers': answersData,

    };
    await db.collection("results").doc(resultData.timestamp).set(dbData);
  }

   String colorToString(Color color) {
     for (var entry in wordColorMap.entries) {
       if (entry.value == color) {
         return entry.key;
       }
     }
     return '';
   }
}
