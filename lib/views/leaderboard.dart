import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/leaderboard_controller.dart';
import '../models/leaderboard_data.dart';
import 'base_scaffold.dart';
import 'home.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LeaderboardController(),
      child: SafeArea(
        child: BaseScaffold(
          child: Center(
            child: Consumer<LeaderboardController>(
              builder: (context, controller, child) {
                return FutureBuilder(
                  future: controller.fetchFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildLanguageButtons(context, controller),
                          _buildDataTable(controller.allData, controller.isCroatian),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  HomePage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(18),
                            ),
                            child: const Text('Go to Menu'),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButtons(BuildContext context, LeaderboardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            controller.toggleLanguage(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(18),
          ),
          child: const Text('Croatian'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            controller.toggleLanguage(false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(18),
          ),
          child: const Text('English'),
        ),
      ],
    );
  }

  Widget _buildDataTable(List<LeaderboardData> allData, bool isCroatian) {
    return FittedBox(
      child: DataTable(
        columnSpacing: 25.0,
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
          LeaderboardData playerData = entry.value;
          return DataRow(
            cells: <DataCell>[
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: Text('${index + 1}.'),
                ),
              ),
              DataCell(Text(playerData.name)),
              DataCell(Container(
                alignment: Alignment.center,
                child: Text(isCroatian ? '${playerData.correctCroatian}' : '${playerData.correctEnglish}'),
              )),
              DataCell(Text(isCroatian ? '${playerData.timeCroatian} s' : '${playerData.timeEnglish} s')),
            ],
          );
        })
            .take(10)
            .toList(),
      ),
    );
  }
}