import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'game.dart';
import 'leaderboard.dart';

class ResultPage extends StatelessWidget {
  final double timeTaken;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool isEnglish;
  final bool bothLanguagesPlayed;


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
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Language: ${isEnglish ? 'English' : 'Croatian'}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                  Text(
                    'Time taken: $timeTaken seconds',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                  Text(
                    'Correct answers: $correctAnswers',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                  Text(
                    'Incorrect answers: $incorrectAnswers',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),

                  SizedBox(height: 16),
                  if (bothLanguagesPlayed)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LeaderboardPage()),
                        );
                      },
                      child: Text('Go to Leaderboard'),
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
                          MaterialPageRoute(builder: (context) => GamePage(isCroatian: isEnglish, isSecondRound: true)),
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

    if (language) {
      Reference resultFileRef = userFolderRef.child('english_results.txt');
      await resultFileRef.putString(data);
    } else {
      Reference resultFileRef = userFolderRef.child('croatian_results.txt');
      await resultFileRef.putString(data);
    }
  }
}