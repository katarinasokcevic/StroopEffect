import 'package:flutter/material.dart';
import 'package:stroop_effect/models/result_data.dart';

const wordsCount = 10;
const questionNumber = 1;

class GameModel {
  final bool isCroatian;
  final bool isSecondRound;
  final ResultData resultData;

  String currentWord = '';
  Color wordColor = Colors.transparent;
  List<String> words = [];
  List<Color> colors = [];
  int wordLeftCounter = wordsCount;
  int currentQuestionNumber = questionNumber;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  bool quizStarted = false;
  DateTime questionStartTime = DateTime.now();
  DateTime startTime = DateTime.now();

  GameModel({
    required this.isCroatian,
    required this.isSecondRound,
    required this.resultData,
  });

  void resetGame() {
    wordLeftCounter = wordsCount;
    currentQuestionNumber = questionNumber;
    correctAnswers = 0;
    incorrectAnswers = 0;
    quizStarted = false;
    questionStartTime = DateTime.now();
    startTime = DateTime.now();
  }
}
