import '../models/result_data.dart';

class ResultController {
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
    await resultData.saveToDatabase();
  }
}
