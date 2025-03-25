import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_bhulekh_app/api_url/url.dart';
import 'package:my_bhulekh_app/onboarding_screens/onboarding_screen3.dart';
import 'package:my_bhulekh_app/otp_screen/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup1 extends StatefulWidget {
  const Signup1({super.key});

  @override
  _Signup1State createState() => _Signup1State();
}

class _Signup1State extends State<Signup1> {
  bool isChecked = true;
  int? otp;
  TextEditingController mobileController = TextEditingController();

  // bool isLoading = false;
  void _navigateToOTPPage() async {
    String phoneNumber = mobileController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your Mobile number'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else if (phoneNumber.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 10-digit Mobile number'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var requestBody = {"mobile_number": phoneNumber};
    String? savedMobile = prefs.getString('mobileNumber');
    print('Saved Mobile Number: $savedMobile');

    print('Request Body: ${jsonEncode(requestBody)}');
    final String url = URLS().login_apiUrl;
    print('Request URL: $url');

    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse != null && jsonResponse['data'] != null) {
        await prefs.setString('mobileNumber', phoneNumber);
        setState(() {
          otp = jsonResponse['data']['otp'] ?? '';
          print("otp $otp");
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => OtpScreen(mobilenumber: phoneNumber, otp: otp),
          ),
        );
        var data = jsonResponse['data'];

        var isNew = data['is_new'] ?? false;
        var customerId =
            data['customer_id'] ?? ''; // ✔ This is the correct variable name

        await prefs.setBool('is_new', isNew);
        await prefs.setString(
          'customer_id',
          customerId.toString(),
        ); // ✔ Save in SharedPreferences
        print('Saved Customer ID: $customerId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 200),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get OTP. Please try again later.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get OTP. Please try again later.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> getOtpFromApi() async {
    final url = Uri.parse(URLS().login_apiUrl);

    final Map<String, dynamic> requestBody = {
      "mobile_number": mobileController,
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];
        print('Response Body: ${response.body}');
        if (data != null) {
          final otp = data['otp'].toString();
          final isNew = data['is_new'] == 1 ? true : false;

          // Store values
          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setBool('is_new', isNew);

          debugPrint('OTP: $otp | isNew: $isNew');
        } else {
          debugPrint("No data received in response.");
        }
      } else {
        debugPrint("API call failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signup1()),
        );
        return false; // 👈 Prevent default back pop
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Image.asset('assets/eva_arrow-back-fill.png'),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => OnboardingScreen3()),
              // );
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Background Image
              Container(
                width: screenWidth,
                height: screenHeight * 0.45,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/rb_66 2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 155),
                  child: Center(
                    child: Image.asset(
                      'assets/images/Wavy_Tech2.png',
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Title Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Start Your Safe Journey!',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF36322E),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Subtitle Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Enter your mobile number',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF595959),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Mobile Number Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Color(0xFFD0D0D0),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/Call.png'),
                          SizedBox(width: 15),
                          Container(
                            width: 1,
                            height: 41,
                            color: Color(0xFFD0D0D0),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                hintText: 'Enter Your Mobile No',
                                hintStyle: TextStyle(color: Color(0xFF757575)),
                                border: InputBorder.none,
                                counterText: "", // Hide character counter
                                contentPadding: EdgeInsets.zero,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]"),
                                ),
                              ],
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter mobile no';
                                }

                                final trimmedValue = value.trim();

                                // Block HTML/script tags or suspicious patterns
                                if (RegExp(
                                  r'<.*?>|script|alert|on\w+=',
                                  caseSensitive: false,
                                ).hasMatch(trimmedValue)) {
                                  return 'Invalid characters or script content detected';
                                }

                                // // Allow only Unicode letters and spaces
                                // if (!RegExp(
                                //   r'^[\p{L}\s]+$',
                                //   unicode: true,
                                // ).hasMatch(trimmedValue)) {
                                //   return 'Only alphabets and spaces allowed';
                                // }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Checkbox with Description
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 0,
                      ), // 👈 Add left space between checkbox and text
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: Colors.orange,
                            checkColor: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'A 6-digit security code will be sent via SMS to verify your mobile number!',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF36322E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Login Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF57C03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          _navigateToOTPPage();
                        },
                        child: Center(
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
