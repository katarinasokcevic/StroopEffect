import 'package:flutter/material.dart';
import 'dart:math';

import 'package:stroop_effect/pages/result.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<String> words = [
    'zelena',
    'plava',
    'žuta',
    'crvena',
    'green',
    'blue',
    'yellow',
    'red'
  ];
  final List<Color> colors = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red
  ];
  late String currentWord = '';
  late Color currentColor;
  late Color wordColor = Colors.transparent;
  int wordCount = 0;
  bool isCroatian = Random().nextBool();
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int croatianCorrectAnswers = 0;
  int croatianIncorrectAnswers = 0;
  int englishCorrectAnswers = 0;
  int englishIncorrectAnswers = 0;
  DateTime startTime = DateTime.now();

  void nextWord() {
    setState(() {
      currentWord = isCroatian ? words[Random().nextInt(4)] : words[Random().nextInt(4) + 4];
      wordColor = colors[Random().nextInt(4)];
      wordCount++;
      if (wordCount == 11) {
        if (isCroatian) {
          croatianCorrectAnswers += correctAnswers;
          croatianIncorrectAnswers += incorrectAnswers;
        } else {
          englishCorrectAnswers += correctAnswers;
          englishIncorrectAnswers += incorrectAnswers;
        }
        isCroatian = !isCroatian;
        wordCount = 0;
        correctAnswers = 0;
        incorrectAnswers = 0;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Language Change'),
              content: Text(
                  'The language has changed to ${isCroatian ? 'Croatian' : 'English'}.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    nextWord();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Start'),
            content: Text(
              'The game will start in ${isCroatian ? 'Croatian' : 'English'}.',
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  nextWord();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "The game Stroop effect",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentWord,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: wordColor,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: colors
                      .take(2)
                      .map((color) => Expanded(
                            child: TextButton(
                              style:
                                  TextButton.styleFrom(backgroundColor: color),
                              onPressed: () {
                                _handleAnswer(color);
                              },
                              child: Container(height: 70),
                            ),
                          ))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: colors
                      .skip(2)
                      .take(2)
                      .map((color) => Expanded(
                            child: TextButton(
                              style:
                                  TextButton.styleFrom(backgroundColor: color),
                              onPressed: () {
                                _handleAnswer(color);
                              },
                              child: Container(height: 70),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAnswer(Color selectedColor) {
    setState(() {
      Color expectedColor = Colors.transparent; // Default value
      int wordIndex = words.indexOf(currentWord);

      if (wordIndex >= 0 && wordIndex < colors.length) {
        expectedColor = colors[wordIndex];
      }

      if (selectedColor == expectedColor) {
        correctAnswers++;
      } else {
        incorrectAnswers++;
      }
      nextWord();
      if (wordCount == 0) {
        // Calculate the time taken
        double timeTaken = (DateTime.now().difference(startTime).inMilliseconds) / 1000.0;
        if ((isCroatian && wordCount == 0) || (!isCroatian && wordCount == 0)) {
          // Navigate to the result page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                timeTaken,
                croatianCorrectAnswers,
                croatianIncorrectAnswers,
                englishCorrectAnswers,
                englishIncorrectAnswers,
              ),
            ),
          );
        }
      }
    });
  }

}
