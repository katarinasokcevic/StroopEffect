import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../base_scaffold.dart';
import '../result_data.dart';
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
    return SafeArea(
      child: BaseScaffold(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
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
                height: min(max(MediaQuery.of(context).size.height - 450, 50), 170)
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
                        double fontSize = isMobile ? 23 : 16;
                        if (MediaQuery.of(context).size.height < 460 || MediaQuery.of(context).size.width < 300 ) {
                          fontSize = 12;
                        }

                        return Text(
                          "This application explores the Stroop effect, a cognitive phenomenon involving colors and words.\n"
                          "The goal is to study user interactions, gain insights into cognitive\n"
                          "processes, and understand cross-cultural influences on the Stroop effect.\n"
                          "All data will be carefully recorded and shared to enhance our understanding of cognitive phenomena.",
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
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => buildDialog(context),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
        OutlinedButton(
          onPressed: () {
            _showScreenshotPreviewDialog(context);
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
          ),
          child: Text(
            'Preview',
            style: TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            var isCroatian = Random().nextBool();
            Navigator.pop(context);
            _showGameStartDialog(context, isCroatian);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Start",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ],
    );
  }

  void _showGameStartDialog(BuildContext context, bool isCroatian) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Game Start'),
          content: Text(
            'The game will start in ${isCroatian ? 'Croatian' : 'English'}.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                var timestamp = DateFormat('ddHHmmss').format(DateTime.now());
                var resultData = ResultData(user.uid, timestamp);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(
                      isCroatian: isCroatian,
                      isSecondRound: false,
                      resultData: resultData,
                    ),
                  ),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showScreenshotPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Preview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Image.asset('assets/screenshot.jpg'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }
}
