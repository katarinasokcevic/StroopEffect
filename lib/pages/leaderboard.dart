import 'package:firebase_auth/firebase_auth.dart';
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
  }

  Future<List<Map<String, dynamic>>> fetchData(String userId, String language) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref('$userId/${language}_results.txt');
      String downloadURL = await ref.getDownloadURL();
      final response = await http.get(Uri.parse(downloadURL));
      List<String> lines = response.body.split('\n');
      List<Map<String, dynamic>> data = [];
      for (var line in lines) {
        List<String> parts = line.split(':');
        if (parts.length == 2) {
          String key = parts[0].trim();
          String value = parts[1].trim();
          if (key == 'Time taken') {
            data.add({
              'userId': userId,
              'timeTaken': double.parse(value.split(' ')[0]),
            });
          } else if (key == 'Correct answers') {
            data.last['correctAnswers'] = int.parse(value);
          }
        }
      }
      return data;
    } on http.ClientException catch (e) {
      print('HTTP error: ${e.message}');
      return [];
    }
  }

  String language = 'croatian';

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    List<Map<String, dynamic>> leaderboardData = [];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    language = 'croatian';
                    leaderboardData = await fetchData(userId, language);
                    leaderboardData.sort((a, b) => a['timeTaken'].compareTo(b['timeTaken']));
                    setState(() {});
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
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    language = 'english';
                    leaderboardData = await fetchData(userId, language);
                    leaderboardData.sort((a, b) => a['timeTaken'].compareTo(b['timeTaken']));
                    setState(() {});
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(userId, language),
              builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> leaderboardData = snapshot.data!;
                  leaderboardData.sort((a, b) => a['timeTaken'].compareTo(b['timeTaken']));
                  return DataTable(
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
                          DataCell(Text('${index + 1}.')),
                          DataCell(Text(playerData['userId'])),
                          DataCell(Text('${playerData['correctAnswers']}')),
                          DataCell(Text('${playerData['timeTaken']} seconds')),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
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