import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../answer_data.dart';
import '../base_scaffold.dart';
import '../result_data.dart';
import 'authentication/auth.dart';
import 'game.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "The game Stroop effect",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'assets/logo.png',
              height: 180,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      bool isMobile = constraints.maxWidth > 600;
                      double fontSize = isMobile ? 23 : 16; // Example values

                      return Text(
                        "This application delves into the phenomenon known as the Stroop effect, an intriguing cognitive occurrence involving the interplay of colors and words in the brain.\n"
                        "Objective is to observe user interactions, garner insights into cognitive processes, and contribute to a comprehensive understanding of cross-cultural influences on the Stroop effect.\n"
                        "All acquired data will be meticulously documented and disseminated, aiming \n to enrich the collective understanding of cognitive phenomena.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (user == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => buildDialog(context),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.pink, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Circular shape
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                ),
                child: const Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget buildDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Circular shape
      ),
      title: const Text(
        "Game Rules",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text:
                  "The rules of the Stroop effect are very simple. Click on the rectangle with a color which represents meaning of the word, not the color of written word.\n"
                  "For example, for the word, ",
            ),
            TextSpan(
              text: "RED",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ", you should click on red rectangle.\n\n"
                  "The words are written in Croatian and English, and there will be a total of 10 words per language. \n The order may vary to ensure unbiased research.",
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            var r = Random();
            var isCroatian = r.nextBool();
            void _showGameStartDialog() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Circular shape
                    ),
                    title: const Text('Game Start'),
                    content: Text(
                      'The game will start in ${isCroatian ? 'Croatian' : 'English'}.',
                      style: const TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Circular shape
                          ),
                        ),
                        onPressed: () {
                          var timestamp =
                              DateFormat('ddHHmmss').format(DateTime.now());
                          var resultData = ResultData(user.uid, timestamp);
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GamePage(
                                    isCroatian: isCroatian,
                                    isSecondRound: false,
                                    resultData: resultData)),
                          );
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            Navigator.pop(context);
            _showGameStartDialog();
          },
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.pink, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Circular shape
            ),),
          child: const Text(
            "Start",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}
