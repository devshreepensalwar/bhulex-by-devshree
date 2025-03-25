import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:my_bhulekh_app/api_url/url.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String privacyHtmlContent = '';
  bool isLoading = true;

  Future<void> fetchPrivacyPolicy() async {
    setState(() {
      isLoading = true;
    });

    final String url = URLS().get_privacy_apiUrl;
    log('➡ GET Privacy Policy API URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      log("📥 Status Code: ${response.statusCode}");
      log("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'].toString() == "true") {
          setState(() {
            privacyHtmlContent =
                jsonData['data']['page_content'] ??
                '<p>No content available.</p>';
          });
        } else {
          setState(() {
            privacyHtmlContent = '<p>Failed to load content.</p>';
          });
        }
      } else {
        setState(() {
          privacyHtmlContent = '<p>Server error: ${response.statusCode}</p>';
        });
      }
    } catch (e) {
      setState(() {
        privacyHtmlContent = '<p>Something went wrong. Please try again.</p>';
      });
      print("❌ Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: width * 0.05,
            color: Color(0xFF36322E),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF36322E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Html(
                    data: privacyHtmlContent,
                    style: {
                      "body": Style(
                        fontFamily: 'Poppins',
                        fontSize: FontSize(width * 0.04),
                        color: Color(0xFF36322E),
                      ),
                    },
                  ),
                ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bhulex',
//       home: PrivacyPolicyScreen(),
//     );
//   }
// }

// class PrivacyPolicyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFDFDFD),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFDFDFD),
//         elevation: 0,
//         title: Text(
//           "Privacy Policy",
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//             fontSize: 20,
//             color: Color(0xFF36322E),
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Color(0xFF36322E)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section 1
//               Text(
//                 "Privacy Policy",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 22,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 "Last Updated: 25/01/2025\n"
//                 "Welcome to Bhulex! We value your privacy and are committed to protecting your personal information. "
//                 "This Privacy Policy explains how we collect, use, and safeguard your data when you use our services.",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 12,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Section 1
//               Text(
//                 "1. Information We Collect",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               Text.rich(
//                 TextSpan(
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12,
//                     color: Color(0xFF36322E),
//                     height: 1.5,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: "We collect the following types of information:\n",
//                     ),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "Personal Information: Name, email, phone number, and\n",
//                     ),
//                     TextSpan(
//                       text:
//                           "  address when you register or request services.\n",
//                     ),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "Transaction Data: Details related to your service requests,\n",
//                     ),
//                     TextSpan(text: "   payments, and document downloads.\n"),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "Device & Usage Data: Information about how you interact\n",
//                     ),
//                     TextSpan(
//                       text:
//                           "   with our platform, including IP addresses, browser type, and\n",
//                     ),
//                     TextSpan(text: "   cookies."),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 16),

//               // Section 2
//               Text(
//                 "2. How We Use Your Information\n",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               Text.rich(
//                 TextSpan(
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12,
//                     color: Color(0xFF36322E),
//                     height: 1.5,
//                   ),
//                   children: [
//                     TextSpan(text: "Your data is used for:\n "),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "Processing and fulfilling your requests for 7/12 extracts, 8A\n   extracts, and other land records.\n",
//                     ),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(text: "Improving our website and services.\n"),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(text: "Providing customer support.\n"),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "Sending important updates and service-related\n   notifications.\n",
//                     ),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(text: "Ensuring security and preventing fraud."),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Section 3
//               Text(
//                 "3. Data Protection & Security",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               Text(
//                 "We implement strict security measures to protect your personal information from unauthorized access, misuse,\nor loss.",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 12,
//                   color: Color(0xFF36322E),
//                   height: 1.5,
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Section 4
//               Text(
//                 "4. Data Sharing & Third Parties",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               Text.rich(
//                 TextSpan(
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12,
//                     color: Color(0xFF36322E),
//                     height: 1.5,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "We do not sell or rent your personal data to third parties.\n",
//                     ),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "Your information may be shared with government authorities or legal bodies if required by law.\n",
//                     ),
//                     TextSpan(
//                       text: "• ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text:
//                           "Trusted service providers may process data on our behalf to improve our services.",
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
