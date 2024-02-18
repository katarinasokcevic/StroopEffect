import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentication/auth.dart';
import 'game.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = [HomePage()];

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
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
              '../assets/logo.png',
              height: 200,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Our Flutter application delves into the phenomenon known as the Stroop effect, an intriguing cognitive occurrence involving the interplay of colors and words in the brain.\n"
                    "Objective is to observe user interactions, garner insights into cognitive processes, and contribute to a comprehensive understanding of cross-cultural influences on the Stroop effect.\n"
                    "All acquired data will be meticulously documented and disseminated, aiming \n to enrich the collective understanding of cognitive phenomena.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (user == null) {
                    // User is not signed in, navigate to AuthPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                  } else {
                    // User is signed in, show the game rules
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
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
                                  text:
                                      ", you should click on red rectangle.\n\n"
                                      "The words are written in Croatian and English, and there will be a total of 10 words per language. \n The order may vary to ensure unbiased research.",
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the AlertDialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GamePage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink),
                              child: const Text(
                                "Start",
                                style: TextStyle(
                                  fontSize: 30
                                  ,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
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
}
