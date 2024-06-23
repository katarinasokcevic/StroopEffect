import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stroop_effect/views/splash_screen.dart';
import 'views/base_scaffold.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'The Stroop Effect',
      debugShowCheckedModeBanner: false,
      home: BaseScaffold(child: SplashScreen()),
    );
  }
}