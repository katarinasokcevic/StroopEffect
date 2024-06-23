import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer_data.dart';
import 'color_map.dart';

class ResultData {
  final String userId;
  final String timestamp;
  String? name;
  int? correctEnglish;
  double? timeEnglish;
  int? correctCroatian;
  double? timeCroatian;
  final List<AnswerData> answers = [];

  ResultData(this.userId, this.timestamp);

  Future<void> saveToDatabase() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    List<Map<String, dynamic>> answersData =
    answers.map((result) {
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
      'userId': userId,
      'timestamp': timestamp,
      'timeCroatian': timeCroatian,
      'timeEnglish': timeEnglish,
      'correctEnglish': correctEnglish,
      'correctCroatian': correctCroatian,
      'name': name,
      'answers': answersData,
    };

    await _firestore.collection("results").doc(timestamp).set(dbData);
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
