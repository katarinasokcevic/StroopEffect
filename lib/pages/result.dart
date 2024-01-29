import 'package:flutter/material.dart';

import 'game.dart';

class ResultPage extends StatelessWidget {
  final double timeTaken;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool language;


  ResultPage(this.timeTaken, this.correctAnswers, this.incorrectAnswers,this.language);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Language: ${language == 1 ? 'Croatian' : 'English'}',
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

            SizedBox(height: 16), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to the Game page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GamePage()), // Replace with your actual Game page
                );
              },
              child: Text('Continue to second language'),
            ),
          ],
        ),
      ),
    );
  }
}