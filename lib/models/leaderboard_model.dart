import 'package:cloud_firestore/cloud_firestore.dart';
import 'leaderboard_data.dart';

class LeaderboardModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LeaderboardData>> fetchLeaderboardData(bool isCroatian) async {
    final resultsRef = _firestore.collection("results");

    QuerySnapshot querySnapshot;
    if (isCroatian) {
      querySnapshot = await resultsRef
          .orderBy("correctCroatian", descending: true)
          .orderBy("timeCroatian", descending: false)
          .limit(10)
          .get();
    } else {
      querySnapshot = await resultsRef
          .orderBy("correctEnglish", descending: true)
          .orderBy("timeEnglish", descending: false)
          .limit(10)
          .get();
    }

    return querySnapshot.docs
        .map((doc) => LeaderboardData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
