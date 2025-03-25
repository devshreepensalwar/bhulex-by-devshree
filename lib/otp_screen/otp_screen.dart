import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_bhulekh_app/api_url/url.dart';
import 'package:my_bhulekh_app/homepage.dart';
import 'package:my_bhulekh_app/information/info.dart';
import 'package:my_bhulekh_app/sign_up_screens/signup1.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String mobilenumber;
  final int? otp;

  const OtpScreen({super.key, required this.mobilenumber, required this.otp});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  String maskedNumber(String mobileNumber) {
    if (mobileNumber.length < 4) {
      return mobileNumber;
    }
    return mobileNumber.replaceRange(
      0,
      mobileNumber.length - 4,
      'X' * (mobileNumber.length - 4),
    );
  }

  void _resendOTPPage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final String mobile = widget.mobilenumber;

      final Map<String, dynamic> requestBody = {
        "mobile_number": widget.mobilenumber,
      };
      final String url = URLS().login_apiUrl;

      print('Request URL: $url');
      print('Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          final String newOtp = data['otp']?.toString() ?? '';
          final bool isNew = data['is_new'] ?? false;
          final String customerId = data['customer_id']?.toString() ?? '';

          // Save to SharedPreferences
          await prefs.setString('mobileNumber', mobile);
          await prefs.setBool('is_new', isNew);
          await prefs.setString('customer_id', customerId);

          print("Received OTP: $newOtp");
          print('Saved Customer ID: $customerId');

          // setState(() {
          //   otp = newOtp;
          // });

          // Navigate to OTP screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(mobilenumber: mobile, otp: null),
            ),
          );

          // Success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP sent successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 1500),
            ),
          );
        } else {
          _showErrorSnackBar('Failed to get OTP. Please try again later.');
        }
      } else {
        _showErrorSnackBar(
          'Failed to get OTP. Server returned ${response.statusCode}.',
        );
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToOTPPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var requestBody = {
      "mobile_number": widget.mobilenumber,
      "otp": _otpController.text,
    };

    print('Request Body: ${jsonEncode(requestBody)}');
    final String url = URLS().verify_otp_apiUrl;
    print('Request URL: $url');

    try {
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
          var data = jsonResponse['data'];
          var isNew = data['is_new']; // 1 = new, 0 = old

          if (isNew == "0") {
            print(isNew);
            //New customer → Go to Information screen
            await prefs.setString('mobileNumber', widget.mobilenumber);
            // await prefs.setBool('is_new', true);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('New customer verified successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => informationscreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('otp verified.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage2()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid response from server.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to verify OTP. Try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // void _resendOtp() async {
  //   final String url = URLS().verify_otp_apiUrl;

  //   var requestBody = {"mobile_number": widget.mobilenumber};

  //   try {
  //     var response = await http.post(
  //       Uri.parse(url),
  //       body: jsonEncode(requestBody),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     print('Resend OTP Response: ${response.statusCode}');
  //     print('Resend OTP Body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("OTP resent successfully."),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Failed to resend OTP."),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print("Exception in resend OTP: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Something went wrong. Try again."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }
  Future<void> _resendOtp() async {
    final String url = URLS().login_apiUrl; // Use login API to resend OTP
    final Map<String, dynamic> requestBody = {
      "mobile_number": widget.mobilenumber,
    };

    try {
      print('Resend OTP Request URL: $url');
      print('Resend OTP Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      print('Resend OTP Response: ${response.statusCode}');
      log('Resend OTP Body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == 'true') {
        final data = jsonResponse['data'];
        final String newOtp = data['otp']?.toString() ?? '';
        final String customerId = data['customer_id']?.toString() ?? '';

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customer_id', customerId);

        print('New OTP: $newOtp');
        print('Saved Customer ID: $customerId');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP resent successfully."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Optionally pre-fill the OTP field for testing (remove in production)
        // setState(() => _otpController.text = newOtp);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to resend OTP: ${jsonResponse['message']}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Exception in resend OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Try again."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    String? _validateOtp(String? value) {
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

      // Only digits allowed for OTP
      if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
        return 'Only numbers allowed';
      }

      if (trimmedValue.length != 4) {
        return 'OTP must be 4 digits';
      }

      return null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        elevation: 0, // Remove shadow
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signup1()),
            );
          },
          icon: Image.asset('assets/eva_arrow-back-fill.png'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// **OTP Image**
              // Image.asset(
              //   'assets/images/otp.png',
              //   width: screenWidth * 0.6,
              //   height: screenHeight * 0.2,
              //   fit: BoxFit.contain,
              // ),
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
                      'assets/images/otp.png',
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// **OTP Title**
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter OTP',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Color(0xff36322E),
                  ),
                ),
              ),

              SizedBox(height: 8),

              /// **OTP Sent Message**
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: 'An 4 digit code has been sent to\n+91 9995380399 ',
                    style: GoogleFonts.inter(
                      color: Color(0xFF595959),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: maskedNumber(widget.mobilenumber),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3B4453),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// **OTP Input Field**
              Align(
                alignment: Alignment.topCenter,
                child: Pinput(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  length: 4,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  textCapitalization:
                      TextCapitalization.none, // OTP should not be capitalized
                  validator: _validateOtp,
                  defaultPinTheme: PinTheme(
                    width: 65,
                    height: 67,
                    textStyle: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD0D0D0), width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              /// **Verify Button**
              GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => information()),
                  // );
                  _navigateToOTPPage();
                },
                child: Container(
                  width: 356,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Color(0xFFF57C03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Verify',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              /// **Resend OTP**
              GestureDetector(
                onTap: () {
                  _resendOtp(); // 🔁 Call the resend OTP function here
                },
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: Color(0xFF36322E),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
