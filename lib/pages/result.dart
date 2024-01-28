import 'package:flutter/material.dart';

import 'game.dart';

class ResultPage extends StatelessWidget {
  final double timeTaken;
  final int correctAnswers;
  final int incorrectAnswers;
  final int correctAnswers2;
  final int incorrectAnswers2;

  ResultPage(this.timeTaken, this.correctAnswers, this.incorrectAnswers,this.correctAnswers2, this.incorrectAnswers2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Time taken: $timeTaken seconds',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Correct answers croatian: $correctAnswers',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Incorrect answers croatian: $incorrectAnswers',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Correct answers english: $correctAnswers2',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Incorrect answers english: $incorrectAnswers2',
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