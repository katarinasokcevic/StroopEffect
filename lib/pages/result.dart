import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int timeTaken;
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
              'Correct answers: $correctAnswers',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Incorrect answers: $incorrectAnswers',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}