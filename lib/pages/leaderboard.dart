import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

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

  }



  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> leaderboardData = List.generate(10, (index) {
      return {
        'userId': 'user${index + 1}', // Generate user IDs like 'user1', 'user2', etc.
        'correctAnswers': index * 5, // Randomly assign correct answers (for demonstration)
        'timeTaken': index * 10, // Randomly assign time taken (for demonstration)
      };
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text('Croatian'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(25),
                  ),
                ),
                SizedBox(width: 10), // Add some space between the buttons
                ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text('English'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(25),
                  ),
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
                  label: Text('Correct\nanswers'),

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
                    DataCell(Text('${index + 1}.')), // Ranking data from 1 to 10
                    DataCell(Text(playerData['userId'])), // User ID
                    DataCell(Text('${playerData['correctAnswers']}')), // Correct answers
                    DataCell(Text('${playerData['timeTaken']} seconds')), // Time taken
                  ],
                );
              }).toList(),
            ),
            SizedBox(width: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Start Again'),
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(25),
              ),
            ),
          ],
        ),
      ),
    );
  }

}