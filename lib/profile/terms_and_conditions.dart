import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_bhulekh_app/api_url/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhulex',
      home: TermsAndConditionsScreen(),
    );
  }
}

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  String content = '';
  bool isLoading = true;
  bool isToggled = false; // Language toggle state

  @override
  void initState() {
    super.initState();
    _loadToggleState(); // Load language preference
  }

  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggled = prefs.getBool('isToggled') ?? false;
    });
    await fetchTermsConditions(); // Fetch content after setting toggle state
  }

  Future<void> fetchTermsConditions() async {
    setState(() {
      isLoading = true;
    });

    final String url = URLS().get_terms_apiUrl;
    log('➡ GET Terms and Conditions API URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      log("📥 Status Code: ${response.statusCode}");
      log("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'].toString() == "true") {
          setState(() {
            content =
                isToggled
                    ? (jsonData['data']['page_content_in_local_language'] ??
                        '<p>कोणताही मजकूर सापडला नाही.</p>')
                    : (jsonData['data']['page_content'] ??
                        '<p>No content found.</p>');
            log('Displayed Content: $content');
          });
        } else {
          setState(() {
            content =
                isToggled
                    ? '<p>मजकूर लोड करण्यात अयशस्वी.</p>'
                    : '<p>Failed to load content.</p>';
          });
        }
      } else {
        setState(() {
          content =
              isToggled
                  ? '<p>सर्व्हर त्रुटी: ${response.statusCode}</p>'
                  : '<p>Server error: ${response.statusCode}</p>';
        });
      }
    } catch (e) {
      setState(() {
        content =
            isToggled
                ? '<p>काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.</p>'
                : '<p>Something went wrong. Please try again.</p>';
      });
      log("❌ Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await fetchTermsConditions();
  }

  Widget buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(8, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 18,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
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
          isToggled ? "अटी आणि शर्ती" : "Terms and Conditions",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: width * 0.05,
            color: const Color(0xFF36322E),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF36322E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
              isLoading
                  ? buildShimmer()
                  : Html(
                    data: content,
                    style: {
                      "body": Style(
                        fontFamily: 'Poppins',
                        fontSize: FontSize(width * 0.04),
                        color: const Color(0xFF36322E),
                        lineHeight: const LineHeight(1.5),
                      ),
                    },
                  ),
        ),
      ),
    );
  }
}
