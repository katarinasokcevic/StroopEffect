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

  Future<List<Map<String, dynamic>>> fetchAllData(String language) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage.ref().listAll();
      List<Map<String, dynamic>> data = [];

      for (var item in result.prefixes) {
        String userId = item.name;
        ListResult userResult = await storage.ref(userId).listAll();

        for (var file in userResult.items) {
          if (file.name.startsWith('${language}_results_') &&
              file.name.endsWith('.txt')) {
            String downloadURL = await file.getDownloadURL();
            final response = await http.get(Uri.parse(downloadURL));
            List<String> lines = response.body.split('\n');
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
                } else if (key == 'Name') {
                  data.last['name'] = value;
                }
              }
            }
          }
        }
      }
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void sortLeaderboardData(List<Map<String, dynamic>> leaderboardData) {
    leaderboardData.sort((a, b) {
      int compareByCorrectAnswers = b['correctAnswers'].compareTo(a['correctAnswers']);
      if (compareByCorrectAnswers != 0) {
        return compareByCorrectAnswers;
      } else {
        return a['timeTaken'].compareTo(b['timeTaken']);
      }
    });
  }


  String language = 'croatian';

  @override
  Widget build(BuildContext context) {
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
                    leaderboardData = await fetchAllData(language);
                    sortLeaderboardData(leaderboardData);
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
                    leaderboardData = await fetchAllData(language);
                    sortLeaderboardData(leaderboardData);
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
              future: fetchAllData(language),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> leaderboardData = snapshot.data!;
                  sortLeaderboardData(leaderboardData);
                  return DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Ranking',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Correct\nanswers',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: leaderboardData.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> playerData = entry.value;
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text('${index + 1}.')),
                          DataCell(Text(playerData['name'])),
                          DataCell(Text('${playerData['correctAnswers']}')),
                          DataCell(Text('${playerData['timeTaken']} s')),
                        ],
                      );
                    }).take(10).toList(),
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
