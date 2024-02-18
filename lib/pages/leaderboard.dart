import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<String> leaderboardData = [];
  bool isCroatian = true;

  @override
  void initState() {
    super.initState();
    getLeaderboardData();
  }

  void getLeaderboardData() async {
    // Fetch the leaderboard data here
    leaderboardData = (await fetchLeaderboardData(isCroatian)).cast<String>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Croatian'),
                  onPressed: () {
                    setState(() {
                      isCroatian = true;
                      getLeaderboardData(); // Fetch Croatian data
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('English'),
                  onPressed: () {
                    setState(() {
                      isCroatian = false;
                      getLeaderboardData(); // Fetch English data
                    });
                  },
                ),
              ],
            ),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text('Ranking'),
                ),
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text('Correct answers'),
                ),
                DataColumn(
                  label: Text('Time'),
                ),
              ],
              rows: leaderboardData.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> playerData = entry.value as Map<String, dynamic>;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text('${index +  1}.')), // Ranking data from  1 to  10
                    DataCell(Text(playerData['userId'])), // User ID
                    DataCell(Text('${playerData['correctAnswers']}')), // Correct answers
                    DataCell(Text('${playerData['timeTaken']} seconds')), // Time taken
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchLeaderboardData(bool isCroatian) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<Map<String, dynamic>> leaderboardData = [];

    ListResult result = await storage.ref().listAll();
    for (var item in result.items) {
      String userId = item.name;
      String fileName = isCroatian ? 'croatian_results.txt' : 'english_results.txt';
      Reference resultFileRef = storage.ref('$userId/$fileName');

      try {
        String data = (await resultFileRef.getData()) as String;
        List<String> lines = data.split('\n');

        double timeTaken = double.tryParse(lines[0].split(': ')[1].split(' ')[0]) ?? 0.0;
        int correctAnswers = int.tryParse(lines[1].split(': ')[1]) ?? 0;

        leaderboardData.add({
          'userId': userId,
          'timeTaken': timeTaken,
          'correctAnswers': correctAnswers,
        });
      } catch (e) {
        print('Error reading file $fileName for user $userId: $e');
      }
    }

    leaderboardData.sort((a, b) {
      int compare = b['correctAnswers'].compareTo(a['correctAnswers']);
      if (compare != 0) return compare;
      return a['timeTaken'].compareTo(b['timeTaken']);
    });

    return leaderboardData;
  }

}