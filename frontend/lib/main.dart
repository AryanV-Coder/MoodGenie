import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

int? currentId;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  // Open your box
  await Hive.openBox('moodBox');

  currentId = Random().nextInt(900000) + 100000; // Generates a 6-digit random number

  runApp(const MoodGenieApp());
}

class MoodGenieApp extends StatelessWidget {
  const MoodGenieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodGenie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        textTheme: GoogleFonts.martelSansTextTheme(),
      ),
      darkTheme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
