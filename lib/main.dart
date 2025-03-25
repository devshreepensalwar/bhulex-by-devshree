import 'package:flutter/material.dart';
import 'package:my_bhulekh_app/splash_screens/splash_screen1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Bhulekh App', // Updated to match your app's name
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Optional: Enable Material 3 if desired
      ),
      home: const SplashScreen(), // Start with SplashScreen
    );
  }
}
