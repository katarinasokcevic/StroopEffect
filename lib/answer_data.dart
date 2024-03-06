import 'package:flutter/material.dart';

class AnswerData {
  final int questionNumber;
  final String displayedWord;
  final Color displayedColor;
  final Color selectedColor;
  final bool isCroatian;
  final bool isCorrect;
  final double timeTaken;

  AnswerData({
    required this.questionNumber,
    required this.displayedWord,
    required this.displayedColor,
    required this.selectedColor,
    required this.isCroatian,
    required this.isCorrect,
    required this.timeTaken,
  });

}
