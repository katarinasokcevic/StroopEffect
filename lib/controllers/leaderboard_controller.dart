import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/leaderboard_model.dart';

class LeaderboardController extends ChangeNotifier {
  List<LeaderboardData> allData = [];
  bool isCroatian = true;
  late Future<void> fetchFuture;

  LeaderboardController() {
    fetchFuture = fetchCroatianData();
  }

  Future<void> fetchCroatianData() async {
    var db = FirebaseFirestore.instance;
    final resultsRef = db.collection("results");
    final data = resultsRef
        .orderBy("correctCroatian", descending: true)
        .orderBy("timeCroatian", descending: false)
        .limit(10);
    var snapshot = await data.get();
    allData = snapshot.docs.map((doc) => LeaderboardData.fromMap(doc.data(), true)).toList();
    notifyListeners();
  }

  Future<void> fetchEnglishData() async {
    var db = FirebaseFirestore.instance;
    final resultsRef = db.collection("results");
    final data = resultsRef
        .orderBy("correctEnglish", descending: true)
        .orderBy("timeEnglish", descending: false)
        .limit(10);
    var snapshot = await data.get();
    allData = snapshot.docs.map((doc) => LeaderboardData.fromMap(doc.data(), false)).toList();
    notifyListeners();
  }

  void toggleLanguage(bool isCroatian) {
    this.isCroatian = isCroatian;
    if (isCroatian) {
      fetchFuture = fetchCroatianData();
    } else {
      fetchFuture = fetchEnglishData();
    }
    notifyListeners();
  }
}