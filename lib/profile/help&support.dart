import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HelpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  String _content = 'Loading...';
  bool _isLoading = false;
  bool isToggled = false; // Language toggle state

  @override
  void initState() {
    super.initState();
    _loadToggleState(); // Load language preferenceijnijn
  }

  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggled = prefs.getBool('isToggled') ?? false;
    });
    await fetchHelpContent(); // Fetch content after setting toggle state
  }

  Future<void> fetchHelpContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://seekhelp.in/bhulex/get_help_support');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'true') {
          setState(() {
            _content =
                isToggled
                    ? (data['data']['page_content_in_local_language'] ??
                        'कोणताही मजकूर सापडला नाही.')
                    : (data['data']['page_content'] ?? 'No content found.');
            _isLoading = false;
          });
        } else {
          setState(() {
            _content =
                isToggled
                    ? 'मजकूर लोड करण्यात अयशस्वी.'
                    : 'Failed to load content.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _content =
              isToggled
                  ? 'सर्व्हर त्रुटी: ${response.statusCode}'
                  : 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _content =
            isToggled ? 'काहीतरी चूक झाली: $e' : 'Error loading content: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isToggled ? 'मदत आणि समर्थन' : 'Help & Support',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: Color(0xFF36322E),
          ),
        ),
        backgroundColor: Color(0xFFFDFDFD),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF36322E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Text(
                    _content,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: isToggled ? 'NotoSansDevanagari' : 'Poppins',
                      color: Color(0xFF36322E),
                    ),
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchHelpContent,
        tooltip: isToggled ? 'रिफ्रेश' : 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
