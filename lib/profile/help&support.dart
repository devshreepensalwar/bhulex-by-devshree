import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HelpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  String _content = 'Loading...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHelpContent();
  }

  Future<void> fetchHelpContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your actual API endpoint URL
      final url = Uri.parse('https://seekhelp.in/bhulex/get_help_support');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'true') {
          setState(() {
            _content = data['data']['page_content'];
            _isLoading = false;
          });
        } else {
          throw Exception('API returned false status');
        }
      } else {
        throw Exception('Failed to load help content');
      }
    } catch (e) {
      setState(() {
        _content = 'Error loading content: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & Support')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Text(_content, style: TextStyle(fontSize: 16.0)),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchHelpContent,
        child: Icon(Icons.refresh),
        tooltip: 'Refresh',
      ),
    );
  }
}
