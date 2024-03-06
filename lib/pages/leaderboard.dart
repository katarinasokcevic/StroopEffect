import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../base_scaffold.dart';
import 'home.dart';

class LeaderboardPage extends StatefulWidget {

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> allData = [];
  bool isCroatian = true;

  @override
  void initState() {
    super.initState();
    fetchCroatianData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    isCroatian = true;
                    fetchCroatianData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(25),
                  ),
                  child: const Text('Croatian'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    isCroatian = false;
                    fetchEnglishData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(25),
                  ),
                  child: const Text('English'),
                ),
              ],
            ),
            DataTable(
              columnSpacing: 30.0,
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
              rows: allData
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> playerData = entry.value;
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text('${index + 1}.'),
                          ),
                        ),
                        DataCell(Text(playerData['name'])),
                        DataCell(Container(
                          alignment: Alignment.center,
                          child: Text(
                              '${isCroatian ? playerData['correctCroatian'] : playerData['correctEnglish']}'),
                        )),
                        DataCell(Text(
                            '${isCroatian ? playerData['timeCroatian'] : playerData['timeEnglish']} s')),
                      ],
                    );
                  })
                  .take(10)
                  .toList(),

            ),
            const SizedBox(width: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(25),
              ),
              child: const Text('Go to Menu'),
            ),
          ],
        ),
      ),
    );
  }

  void fetchCroatianData() async {
    var db = FirebaseFirestore.instance;
    final resultsRef = db.collection("results");
    final data = resultsRef.orderBy("correctCroatian", descending: true).
    orderBy("timeCroatian", descending: false).limit(10);
    var snapshot = await data.get();
    allData = snapshot.docs.map((doc) => doc.data()).toList();
    setState(() {});
  }

  void fetchEnglishData() async {
    var db = FirebaseFirestore.instance;
    final resultsRef = db.collection("results");
    final data = resultsRef.orderBy("correctEnglish", descending: true).
    orderBy("timeEnglish", descending: false).limit(10);
    var snapshot = await data.get();
    allData = snapshot.docs.map((doc) => doc.data()).toList();
    setState(() {});
  }
}
