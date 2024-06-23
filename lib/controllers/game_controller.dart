import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stroop_effect/models/color_map.dart';
import 'package:stroop_effect/models/game_model.dart';
import 'package:stroop_effect/views/result.dart';
import '../models/answer_data.dart';

class GameController {
  final GameModel gameModel;
  final VoidCallback updateState;

  GameController({
    required this.gameModel,
    required this.updateState,
  }) {
    gameModel.words = wordColorMap.keys.toList();
    gameModel.colors = wordColorMap.values.toList();
  }

  void startGame() {
    if (!gameModel.quizStarted) {
      nextWord();
      gameModel.quizStarted = true;
    }
    updateState();
  }

  void nextWord() {
    gameModel.questionStartTime = DateTime.now();
    gameModel.currentWord = gameModel.isCroatian
        ? gameModel.words[Random().nextInt(4)]
        : gameModel.words[Random().nextInt(4) + 4];
    gameModel.wordColor = wordColorMap.values.elementAt(Random().nextInt(4));
    gameModel.wordLeftCounter--;
    updateState();
  }

  void handleAnswer(Color selectedColor, BuildContext context) {
    Color? expectedColor = wordColorMap[gameModel.currentWord];

    if (selectedColor == expectedColor) {
      gameModel.correctAnswers++;
    } else {
      gameModel.incorrectAnswers++;
    }

    double timeTaken = (DateTime.now().difference(gameModel.questionStartTime).inMilliseconds) / 1000.0;
    gameModel.resultData.answers.add(AnswerData(
      questionNumber: gameModel.currentQuestionNumber++,
      displayedWord: gameModel.currentWord,
      displayedColor: gameModel.wordColor,
      selectedColor: selectedColor,
      isCroatian: gameModel.isCroatian,
      isCorrect: selectedColor == expectedColor,
      timeTaken: timeTaken,
    ));

    if (gameModel.wordLeftCounter == 0) {
      navigateToResultPage(context);
    } else {
      nextWord();
    }
  }

  Future<void> navigateToResultPage(BuildContext context) async {
    double timeTaken = (DateTime.now().difference(gameModel.startTime).inMilliseconds) / 1000.0;
    int correctAnswersToPass = gameModel.correctAnswers;
    int incorrectAnswersToPass = gameModel.incorrectAnswers;

    if (gameModel.isCroatian) {
      gameModel.resultData.correctCroatian = correctAnswersToPass;
      gameModel.resultData.timeCroatian = timeTaken;
    } else {
      gameModel.resultData.correctEnglish = correctAnswersToPass;
      gameModel.resultData.timeEnglish = timeTaken;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          timeTaken,
          correctAnswersToPass,
          incorrectAnswersToPass,
          gameModel.isCroatian,
          gameModel.isSecondRound,
          gameModel.resultData,
        ),
      ),
    );
  }
}
