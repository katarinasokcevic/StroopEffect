import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../answer_data.dart';
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
                    builder: (BuildContext context, BoxConstraints constraints) {
                      bool isMobile = constraints.maxWidth > 600;
                      double fontSize = isMobile ? 23 : 16;

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
              fontSize: 20,
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
              fontSize: 30,
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
                List<AnswerData> answers = [];
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(
                      isCroatian: isCroatian,
                      isSecondRound: false,
                      resultData: resultData,
                      answers: answers,
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
          content: Image.network(
            'assets/screenshot.jpg',
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
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
