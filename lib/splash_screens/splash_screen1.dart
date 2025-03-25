import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_bhulekh_app/onboarding_screens/onboarding_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen1(),
        ), // Replace with your next screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bhulex Text
            Text(
              'Bhulex',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.1, // Responsive font size (~42px)
                fontWeight: FontWeight.w600, // Semi-bold
                height: 1.0, // 100% line height
                letterSpacing: -0.17, // Small letter spacing
                color: Color(0xFFF57C03),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
