import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_bhulekh_app/api_url/url.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhulex',
      home: DisclaimerScreen(),
    );
  }
}

class DisclaimerScreen extends StatefulWidget {
  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  String content = '';
  bool isLoading = true;
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
    await fetchDisclaimerContent(); // Fetch content after setting toggle state
  }

  Future<void> fetchDisclaimerContent() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? customerId = prefs.getString('customer_id');

      if (customerId == null || customerId.isEmpty) {
        setState(() {
          content =
              isToggled
                  ? '<p>त्रुटी: ग्राहक आयडी सापडला नाही.</p>'
                  : '<p>Error: Customer ID not found.</p>';
          isLoading = false;
        });
        return;
      }

      final String url = URLS().get_disclaimer_apiUrl;
      log('➡ GET Disclaimer API URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"customer_id": customerId}),
      );

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
      log("❌ Exception: $e");
      setState(() {
        content =
            isToggled
                ? '<p>काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.</p>'
                : '<p>Something went wrong. Please try again.</p>';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await fetchDisclaimerContent();
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
          isToggled ? "अस्वीकरण" : "Disclaimer",
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
