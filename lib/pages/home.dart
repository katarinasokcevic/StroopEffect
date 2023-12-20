import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("The Stroop Effect"),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "The game Stroop effect",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(150.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue, // Set box color to your desired color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Our Flutter application delves into the phenomenon known as the Stroop effect, an intriguing cognitive occurrence involving the interplay of colors and words in the brain.\n "
                            "The application comprises two segments—one in English and the other in Croatian. Users are tasked with identifying the color of the text, even when it contradicts the written word.\n"
                            "Our objective is to observe user interactions, garner insights into cognitive processes, and contribute to a comprehensive understanding of cross-cultural influences on the Stroop effect.\n"
                            "All acquired data will be meticulously documented and disseminated, aiming to enrich the collective understanding of cognitive phenomena.",
                        textAlign: TextAlign.center, // Center the text
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            ElevatedButton(
              onPressed: () {
                // Add code to start the game
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.pink, // Set button color to your desired color
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                "Start",
                style: TextStyle(
                  fontSize: 30, // Set button font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}