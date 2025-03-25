import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:my_bhulekh_app/api_url/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String privacyHtmlContent = '';
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
    await fetchPrivacyPolicy(); // Fetch content after setting toggle state
  }

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
                isToggled
                    ? (jsonData['data']['page_content_in_local_language'] ??
                        '<p>कोणताही मजकूर उपलब्ध नाही.</p>')
                    : (jsonData['data']['page_content'] ??
                        '<p>No content available.</p>');
            log('Displayed Content: $privacyHtmlContent');
          });
        } else {
          setState(() {
            privacyHtmlContent =
                isToggled
                    ? '<p>मजकूर लोड करण्यात अयशस्वी.</p>'
                    : '<p>Failed to load content.</p>';
          });
        }
      } else {
        setState(() {
          privacyHtmlContent =
              isToggled
                  ? '<p>सर्व्हर त्रुटी: ${response.statusCode}</p>'
                  : '<p>Server error: ${response.statusCode}</p>';
        });
      }
    } catch (e) {
      setState(() {
        privacyHtmlContent =
            isToggled
                ? '<p>काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.</p>'
                : '<p>Something went wrong. Please try again.</p>';
      });
      print("❌ Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await fetchPrivacyPolicy();
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
          isToggled ? "गोपनीयता धोरण" : "Privacy Policy",
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Html(
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
