import 'package:flutter/material.dart';
import 'package:stroop_effect/color_map.dart';
import 'package:stroop_effect/pages/result.dart';
import 'dart:math';
import '../answer_data.dart';
import '../base_scaffold.dart';
import '../result_data.dart';

const wordsCount = 10;
const questionNumber = 1;

class GamePage extends StatefulWidget {
  final bool isCroatian;
  final bool isSecondRound;
  final ResultData resultData;
  final List<AnswerData> answers;

  const GamePage({
    Key? key,
    required this.isCroatian,
    required this.isSecondRound,
    required this.resultData,
    required this.answers,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<AnswerData> answers = [];
  late String currentWord = '';
  late Color currentColor;
  late Color wordColor = Colors.transparent;
  List<String> words = [];
  List<Color> colors = [];
  int wordLeftCounter = wordsCount;
  int currentQuestionNumber = questionNumber;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  bool bothLanguagesPlayed = false;
  bool quizStarted = false;
  DateTime questionStartTime = DateTime.now();
  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    words = wordColorMap.keys.toList();
    colors = wordColorMap.values.toList();
    answers = List.from(widget.answers);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!quizStarted) {
      nextWord();
      quizStarted = true;
    }

    return BaseScaffold(
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
                      style: TextButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                      style: TextButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
    );
  }

  void nextWord() {
    setState(() {
      questionStartTime = DateTime.now();
      currentWord = widget.isCroatian
          ? words[Random().nextInt(4)]
          : words[Random().nextInt(4) + 4];
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
      double timeTaken =
          (DateTime.now().difference(questionStartTime).inMilliseconds) /
              1000.0;
      answers.add(AnswerData(
        questionNumber: currentQuestionNumber++,
        displayedWord: currentWord,
        displayedColor: wordColor,
        selectedColor: selectedColor,
        isCroatian: widget.isCroatian,
        isCorrect: selectedColor == expectedColor,
        timeTaken: timeTaken,
      ));

      if (wordLeftCounter == 0) {
        navigateToResultPage();
        return;
      }

      nextWord();
    });
  }

  Future<void> navigateToResultPage() async {
    double timeTaken =
        (DateTime.now().difference(startTime).inMilliseconds) / 1000.0;
    int correctAnswersToPass = correctAnswers;
    int incorrectAnswersToPass = incorrectAnswers;
    correctAnswers = 0;
    incorrectAnswers = 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          timeTaken,
          correctAnswersToPass,
          incorrectAnswersToPass,
          !widget.isCroatian,
          widget.isSecondRound,
          widget.resultData,
          answers,
        ),
      ),
    );
  }
}
