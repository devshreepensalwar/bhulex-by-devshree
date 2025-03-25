import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutBhulexPage extends StatefulWidget {
  const AboutBhulexPage({super.key});

  @override
  _AboutBhulexPageState createState() => _AboutBhulexPageState();
}

class _AboutBhulexPageState extends State<AboutBhulexPage> {
  String aboutHtmlContent = '';
  String pageHeading = '';
  bool isLoading = true;
  bool isToggled = false; // Language toggle state

  @override
  void initState() {
    super.initState();
    _loadToggleState(); // Load toggle state before fetching content
  }

  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggled = prefs.getBool('isToggled') ?? false;
    });
    await fetchAboutUs(); // Fetch content after loading toggle state
  }

  Future<void> fetchAboutUs() async {
    setState(() {
      isLoading = true;
    });

    const String url = "https://seekhelp.in/bhulex/get_about_us";
    print('➡ GET About Us API URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'].toString() == "true") {
          setState(() {
            aboutHtmlContent =
                isToggled
                    ? (jsonData['data']['page_content_in_local_language'] ??
                        '<p>स्थानिक भाषेत सामग्री उपलब्ध नाही.</p>')
                    : (jsonData['data']['page_content'] ??
                        '<p>No content available.</p>');
            pageHeading =
                isToggled
                    ? (jsonData['data']['page_heading_in_local_language'] ??
                        'आमच्याबद्दल')
                    : (jsonData['data']['page_heading'] ?? 'About us');
          });
        } else {
          setState(() {
            aboutHtmlContent =
                isToggled
                    ? '<p>सामग्री लोड करण्यात अयशस्वी.</p>'
                    : '<p>Failed to load content.</p>';
            pageHeading = isToggled ? 'आमच्याबद्दल' : 'About us';
          });
        }
      } else {
        setState(() {
          aboutHtmlContent =
              isToggled
                  ? '<p>सर्व्हर त्रुटी: ${response.statusCode}</p>'
                  : '<p>Server error: ${response.statusCode}</p>';
          pageHeading = isToggled ? 'आमच्याबद्दल' : 'About us';
        });
      }
    } catch (e) {
      setState(() {
        aboutHtmlContent =
            isToggled
                ? '<p>काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.</p>'
                : '<p>Something went wrong. Please try again.</p>';
        pageHeading = isToggled ? 'आमच्याबद्दल' : 'About us';
      });
      print("❌ Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF36322E),
            size: width * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          pageHeading, // Dynamic heading based on toggle
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: width * 0.055,
            color: Color(0xFF36322E),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Html(
                    data: aboutHtmlContent,
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
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:my_bhulekh_app/api_url/url.dart';

// class AboutBhulexPage extends StatefulWidget {
//   @override
//   _AboutBhulexPageState createState() => _AboutBhulexPageState();
// }

// class _AboutBhulexPageState extends State<AboutBhulexPage> {
//   String aboutHtmlContent = '';
//   bool isLoading = true;

//   Future<void> fetchAboutUs() async {
//     setState(() {
//       isLoading = true;
//     });

//     final String url = URLS().get_about_us_apiUrl;
//     print('➡ GET About Us API URL: $url');

//     try {
//       final response = await http.get(Uri.parse(url));

//       print("📥 Status Code: ${response.statusCode}");
//       print("📥 Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);

//         if (jsonData['status'].toString() == "true") {
//           setState(() {
//             aboutHtmlContent = jsonData['data']['content'] ?? '';
//           });
//         } else {
//           setState(() {
//             aboutHtmlContent = '<p>Failed to load content.</p>';
//           });
//         }
//       } else {
//         setState(() {
//           aboutHtmlContent = '<p>Server error: ${response.statusCode}</p>';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         aboutHtmlContent = '<p>Something went wrong. Please try again.</p>';
//       });
//       print("❌ Exception: $e");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchAboutUs();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFDFDFD),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFDFDFD),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Color(0xFF36322E),
//             size: width * 0.06,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "About Bhulex",
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: width * 0.055,
//             color: Color(0xFF36322E),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: width * 0.04),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: height * 0.02),
//               Text(
//                 "Welcome to Bhulex,",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: width * 0.055,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               SizedBox(height: height * 0.01),
//               Text(
//                 "Welcome to Bhulex, your one-stop solution for hassle-free access to land records and government documents. "
//                 "We specialize in providing 7/12 extracts, 8A extracts, and various other land and property-related services with accuracy, reliability, and efficiency.",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   fontSize: width * 0.032,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               SizedBox(height: height * 0.02),
//               Text(
//                 "Who We Are",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: width * 0.045,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               SizedBox(height: height * 0.01),
//               Text(
//                 "At Bhulex, we are committed to simplifying the process of\nretrieving essential land records for individuals, businesses,\nand legal professionals. Our platform ensures quick and\nsecure access to official land documents, helping you save\ntime and effort.",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   fontSize: width * 0.032,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               SizedBox(height: height * 0.02),
//               Text(
//                 "Our Services",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: width * 0.045,
//                   color: Color(0xFF36322E),
//                 ),
//               ),
//               SizedBox(height: height * 0.01),

//               // Service 1
//               Padding(
//                 padding: EdgeInsets.only(bottom: width * 0.025),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "1.",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                         fontSize: width * 0.032,
//                         color: Color(0xFF36322E),
//                       ),
//                     ),
//                     SizedBox(width: width * 0.02),
//                     Expanded(
//                       child: Text(
//                         "7/12 Extract – Get the official land ownership record effortlessly.",
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           fontSize: width * 0.032,
//                           color: Color(0xFF36322E),
//                           height: 1.36,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Service 2
//               Padding(
//                 padding: EdgeInsets.only(bottom: width * 0.025),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "2.",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                         fontSize: width * 0.032,
//                         color: Color(0xFF36322E),
//                       ),
//                     ),
//                     SizedBox(width: width * 0.02),
//                     Expanded(
//                       child: Text(
//                         "8A Extract – Obtain important revenue records without any hassle.",
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           fontSize: width * 0.032,
//                           color: Color(0xFF36322E),
//                           height: 1.36,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Service 3
//               Padding(
//                 padding: EdgeInsets.only(bottom: width * 0.025),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "3.",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                         fontSize: width * 0.032,
//                         color: Color(0xFF36322E),
//                       ),
//                     ),
//                     SizedBox(width: width * 0.02),
//                     Expanded(
//                       child: Text(
//                         "Property Documents – Access property-related government documents.",
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           fontSize: width * 0.032,
//                           color: Color(0xFF36322E),
//                           height: 1.36,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Service 4
//               Padding(
//                 padding: EdgeInsets.only(bottom: width * 0.025),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "4.",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                         fontSize: width * 0.032,
//                         color: Color(0xFF36322E),
//                       ),
//                     ),
//                     SizedBox(width: width * 0.02),
//                     Expanded(
//                       child: Text(
//                         "Land Record Consultation – Expert guidance on land records and property details.",
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           fontSize: width * 0.032,
//                           color: Color(0xFF36322E),
//                           height: 1.36,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Service 5
//               Padding(
//                 padding: EdgeInsets.only(bottom: width * 0.025),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "5.",
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                         fontSize: width * 0.032,
//                         color: Color(0xFF36322E),
//                       ),
//                     ),
//                     SizedBox(width: width * 0.02),
//                     Expanded(
//                       child: Text(
//                         "Other Legal Services – Support for various land and revenue-related documentation.",
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           fontSize: width * 0.032,
//                           color: Color(0xFF36322E),
//                           height: 1.36,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: height * 0.04),
//               Text(
//                 "At Bhulex, we believe in transparency, efficiency, and customer satisfaction. "
//                 "Whether you're a farmer, property owner, or legal expert, our services are designed to meet your needs with ease. "
//                 "Experience the future of land record management with Bhulex!",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   fontSize: width * 0.032,
//                   color: Color(0xFF36322E),
//                   height: 1.36,
//                 ),
//               ),
//               SizedBox(height: height * 0.05),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
