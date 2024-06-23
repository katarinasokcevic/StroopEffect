import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/color_map.dart';
import '../models/result_data.dart';

class ResultController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void uploadUserResults(ResultData resultData, double timeTaken,
      int correctAnswers, bool isCroatian) {
    if (isCroatian) {
      resultData.correctCroatian = correctAnswers;
      resultData.timeCroatian = timeTaken;
    } else {
      resultData.correctEnglish = correctAnswers;
      resultData.timeEnglish = timeTaken;
    }
  }

  Future<void> saveResult(ResultData resultData) async {
    List<Map<String, dynamic>> answersData =
    resultData.answers.map((result) {
      return {
        'questionNumber': result.questionNumber,
        'displayedWord': result.displayedWord,
        'displayedColor': colorToString(result.displayedColor),
        'selectedColor': colorToString(result.selectedColor),
        'isCroatian': result.isCroatian ? "croatian" : "english",
        'isCorrect': result.isCorrect ? "correct" : "incorrect",
        'timeTaken': result.timeTaken,
      };
    }).toList();

    var dbData = <String, dynamic>{
      'userId': resultData.userId,
      'timestamp': resultData.timestamp,
      'timeCroatian': resultData.timeCroatian,
      'timeEnglish': resultData.timeEnglish,
      'correctEnglish': resultData.correctEnglish,
      'correctCroatian': resultData.correctCroatian,
      'name': resultData.name,
      'answers': answersData,
    };

    await _firestore.collection("results").doc(resultData.timestamp).set(dbData);
  }

  String colorToString(Color color) {
    for (var entry in wordColorMap.entries) {
      if (entry.value == color) {
        return entry.key;
      }
    }
    return '';
  }
}
