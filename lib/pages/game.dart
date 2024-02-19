import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroop_effect/pages/result.dart';

const wordsCount = 10;
class GamePage extends StatefulWidget {
  final bool? isCroatian;
  final bool? isSecondRound;

  const GamePage ({ Key? key, this.isCroatian, this.isSecondRound }): super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Map<String, Color> wordColorMap = {
    'zelena': Colors.green,
    'plava': Colors.blue,
    'žuta': Colors.yellow,
    'crvena': Colors.red,
    'green': Colors.green,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
    'red': Colors.red
  };

  late String currentWord = '';
  late Color currentColor;
  late bool isCroatian;
  late bool isSecondRound;
  late Color wordColor = Colors.transparent;
  List<String> words = [];
  List<Color> colors = [];
  int wordLeftCounter = wordsCount;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  bool bothLanguagesPlayed = false;
  bool quizStarted = false;
  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    words = wordColorMap.keys.toList();
    colors = wordColorMap.values.toList();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!quizStarted) {
      isCroatian = widget.isCroatian!;
      isSecondRound = widget.isSecondRound == true;
      nextWord();
      quizStarted = true;
    }
    if (wordLeftCounter ==  -1) {
      print(wordLeftCounter);
      navigateToResultPage();
      return Scaffold();
    }

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

  void nextWord() {
    setState(() {
      currentWord = isCroatian ? words[Random().nextInt(4)] : words[Random().nextInt(4) + 4];
      wordColor = wordColorMap.values.elementAt(Random().nextInt(4));
      wordLeftCounter--;
    });
  }

  void _handleAnswer(Color selectedColor) {
    setState(() {
      Color? expectedColor = wordColorMap[currentWord];

      if (selectedColor == expectedColor) {
        correctAnswers++;
      } else {
        incorrectAnswers++;
      }
      nextWord();
    });
  }

  Future<void> navigateToResultPage() async {
    double timeTaken = (DateTime.now().difference(startTime).inMilliseconds) /  1000.0;
    int correctAnswersToPass = isCroatian ? correctAnswers : incorrectAnswers;
    int incorrectAnswersToPass = isCroatian ? incorrectAnswers : correctAnswers;
    correctAnswers =  0;
    incorrectAnswers =  0;
    isCroatian=!isCroatian;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          timeTaken,
          correctAnswersToPass,
          incorrectAnswersToPass,
          isCroatian,
          isSecondRound,
        ),
      ),
    );
  }
}
