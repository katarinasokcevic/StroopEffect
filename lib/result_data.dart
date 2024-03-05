import 'package:flutter/material.dart';

class ResultData {
  final String userId;
  final String timestamp;
  String? name;
  int? correctEnglish;
  double? timeEnglish;
  int? correctCroatian;
  double? timeCroatian;

  ResultData(this.userId, this.timestamp);
}
