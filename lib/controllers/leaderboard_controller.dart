import 'package:flutter/cupertino.dart';
import '../models/leaderboard_model.dart';
import '../models/leaderboard_data.dart';

class LeaderboardController extends ChangeNotifier {
  final LeaderboardModel _model = LeaderboardModel();
  List<LeaderboardData> allData = [];
  bool isCroatian = true;
  late Future<void> fetchFuture;

  LeaderboardController() {
    fetchFuture = fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    allData = await _model.fetchLeaderboardData(isCroatian);
    notifyListeners();
  }

  void toggleLanguage(bool isCroatian) {
    this.isCroatian = isCroatian;
    fetchFuture = fetchLeaderboardData();
    notifyListeners();
  }
}
