import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import '../controllers/result_controller.dart';
import '../models/result_data.dart';
import 'game.dart';
import 'leaderboard.dart';

class ResultPage extends StatelessWidget {
  final double timeTaken;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool isCroatian;
  final bool bothLanguagesPlayed;
  final ResultData resultData;
  final ResultController _controller = ResultController();

   ResultPage(
      this.timeTaken,
      this.correctAnswers,
      this.incorrectAnswers,
      this.isCroatian,
      this.bothLanguagesPlayed,
      this.resultData, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Language: ${isCroatian ? 'Croatian' : 'English'}',
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
                                  isCroatian: !isCroatian,
                                  isSecondRound: true,
                                  resultData: resultData)),
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
                      child:
                      Text('Continue to ${isCroatian ? 'English' : 'Croatian'}'),
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
    final _formKey = GlobalKey<FormState>();
    String _name = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your first and last name for the leaderboard'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "First and last name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _name = value;
                  },
                ),
              ],
            ),
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
                if (_formKey.currentState!.validate()) {
                  resultData.name = _name;
                  _controller.saveResult(resultData);

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardPage(),
                      ),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
