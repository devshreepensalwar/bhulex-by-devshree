import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_bhulekh_app/onboarding_screens/onboarding_screen3.dart';
import 'package:my_bhulekh_app/sign_up_screens/signup1.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // First Image (Background)
              Positioned(
                top: 51,
                left: 12,
                right: 12,
                child: Image.asset(
                  'assets/images/rb_66 2.png',
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.45,
                  fit: BoxFit.cover,
                ),
              ),
              // Second Image (Foreground)
              Positioned(
                top: screenHeight * 0.24,
                left: screenWidth * 0.15,
                child: Image.asset(
                  'assets/images/12083277_Wavy_Bus-11_Single-11.png',
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
              ),

              // First Text Container
              Positioned(
                bottom: screenHeight * 0.3,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.15,
                  alignment: Alignment.center,
                  child: Text(
                    'Hassle-Free Land\nRecord Search',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                      height: 1.29,
                      letterSpacing: 0,
                      color: Color(0xFFF57C03),
                    ),
                  ),
                ),
              ),
              // Second Text Container
              Positioned(
                bottom: screenHeight * 0.22,
                left: (screenWidth - 356) / 2,
                child: Container(
                  width: 356,
                  height: 75,
                  alignment: Alignment.center,
                  child: Text(
                    'Find land records using name,survey number,\nor village & Download official documents\nanytime',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                      letterSpacing: 0,
                      color: Color(0xFF36322E),
                    ),
                  ),
                ),
              ),
              // Orange Button
              Positioned(
                bottom: screenHeight * 0.14, // Positioned below the text
                left: (screenWidth - 133) / 2, // Center alignment
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                OnboardingScreen3(), // Ensure this class is defined
                      ),
                    );
                  },
                  child: Container(
                    width: 133,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFF57C03), // Orange Background
                      borderRadius: BorderRadius.circular(
                        32,
                      ), // Rounded corners
                      border: Border.all(
                        color: Colors.white, // White border
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/Arrow 2.png', // Custom arrow image
                      width: 30, // Set width
                      height: 30, // Set height
                      color: Colors.white, // Apply color
                      fit: BoxFit.contain, // Ensure proper scaling
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.08,
                left: (screenWidth - 133) / 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup1()),
                    );
                  },
                  child: Container(
                    width: 133,
                    height: 21,
                    alignment: Alignment.center,
                    child: Text(
                      'Skip',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF757575),
                      ),
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
}
