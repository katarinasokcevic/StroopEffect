import 'package:flutter/material.dart';

class QuestionResult {
  final int questionNumber;
  final Color displayedColor;
  final Color selectedColor;
  final bool isCroatian;
  final bool isCorrect;
  final double timeTaken;

  QuestionResult({
    required this.questionNumber,
    required this.displayedColor,
    required this.selectedColor,
    required this.isCroatian,
    required this.isCorrect,
    required this.timeTaken,
  });

}
