import 'package:flutter/material.dart';
import 'package:my_bhulekh_app/homepage.dart';
import 'package:my_bhulekh_app/profile/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhulex',
      home: ChangeLanguageScreen(),
    );
  }
}

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  bool isToggled = false;

  @override
  void initState() {
    super.initState();
    _loadToggleState();
  }

  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggled = prefs.getBool('isToggled') ?? false;
    });
  }

  Future<void> _saveToggleState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isToggled', value);
    setState(() {
      isToggled = value;
    });
  }

  // Handle physical back button press
  Future<bool> _onWillPop() async {
    // Show a confirmation dialog or navigate to HomePage2
    bool? shouldPop = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isToggled ? 'बाहेर पडायचे?' : 'Exit?'),
            content: Text(
              isToggled
                  ? 'आपण खात्रीशीर आहात की आपण बाहेर पडू इच्छिता?'
                  : 'Are you sure you want to exit?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Cancel
                child: Text(isToggled ? 'नाही' : 'No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true); // Confirm
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage2()),
                  );
                },
                child: Text(isToggled ? 'होय' : 'Yes'),
              ),
            ],
          ),
    );

    return shouldPop ?? false; // Default to not popping if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle physical back button
      child: Scaffold(
        backgroundColor: Color(0xFFFDFDFD),
        appBar: AppBar(
          backgroundColor: Color(0xFFFDFDFD),
          elevation: 0,
          title: Text(
            isToggled ? "भाषा बदलें" : "Change Language",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Color(0xFF36322E),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF36322E)),
            onPressed:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(isToggled: isToggled),
                  ),
                ), // App bar back button remains unaffected
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isToggled ? "अपनी भाषा चुनें" : "Select Your Language",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Color(0xFF36322E),
                ),
              ),
              SizedBox(height: 20),
              _buildLanguageOption("English", !isToggled, () {
                _saveToggleState(false);
              }),
              SizedBox(height: 10),
              _buildLanguageOption("Marathi", isToggled, () {
                _saveToggleState(true);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    String language,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 368,
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE5E7EB), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF36322E),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Color(0xFFFFA500) : Color(0xFFB0B0B0),
            ),
          ],
        ),
      ),
    );
  }
}
