import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_bhulekh_app/sign_up_screens/signup1.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
                  'assets/images/Wavy_Tech.png',
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
              ),

              // First Text Container
              Positioned(
                bottom: screenHeight * 0.33,
                left: (screenWidth - 356) / 2,
                child: Container(
                  width: 356, // Reduce width to allow wrapping
                  height: 39,
                  alignment: Alignment.center,
                  child: Text(
                    'Stay Secure & Updated',
                    textAlign: TextAlign.center,
                    softWrap: true, // Ensures text wraps naturally
                    style: GoogleFonts.poppins(
                      fontSize: 30,
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
                    'Safe,reliable,and government-backed\ninformation Stay updated with the latest\nchanges',
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
                bottom: screenHeight * 0.10, // Positioned below the text
                left: (screenWidth - 356) / 2, // Center alignment
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                Signup1(), // Ensure this class is defined
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      // right: 100,
                      bottom: 15,
                    ),
                    child: Container(
                      width: 356,
                      height: 52,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15, // Top & Bottom Padding
                        //horizontal: 153, // Left & Right Padding
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF57C03), // Orange Background
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Adjusted Border Radius
                        border: Border.all(
                          color: Colors.white, // White Border
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'Get Started', // Custom Arrow Image
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          //height: 1.67,
                          letterSpacing: 0,
                          color: Color(0xFFFFFFFF),
                        ),
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
