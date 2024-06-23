import 'answer_data.dart';

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
}
