// ignore_for_file: camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_bhulekh_app/homepage.dart';
import 'package:my_bhulekh_app/language/hindi.dart';
import 'package:my_bhulekh_app/quicke_services_forms/pay.dart';
import 'package:my_bhulekh_app/validations_chan_lang/indexIIsearch.dart';
import 'package:my_bhulekh_app/validations_chan_lang/rera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RERA_Builder extends StatefulWidget {
  final String id;
  final String serviceName;
  final String tblName;
  final bool isToggled; // Added for language toggle
  final String serviceNameInLocalLanguage; // Added for local service name

  const RERA_Builder({
    super.key,
    required this.id,
    required this.serviceName,
    required this.tblName,
    required this.isToggled,
    required this.serviceNameInLocalLanguage,
  });

  @override
  _RERA_BuilderState createState() => _RERA_BuilderState();
}

class _RERA_BuilderState extends State<RERA_Builder> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _builderController = TextEditingController();

  @override
  void dispose() {
    _projectController.dispose();
    _builderController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
      _projectController.clear();
      _builderController.clear();
    });
  }

  Future<void> submitQuickServiceForm(
    BuildContext context,
    Map<String, dynamic> formData,
  ) async {
    const String url =
        'https://seekhelp.in/bhulex/submit_quick_service_enquiry_form';
    print('Request URL: $url');
    print('Request Body: ${jsonEncode(formData)}');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(formData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ Form submitted successfully: $responseData");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => payscreen(responseData: responseData),
          ),
        );
      } else {
        print("❌ Failed to submit form: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Form submission failed. Please try again."),
          ),
        );
      }
    } catch (e) {
      print("❌ Exception occurred: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayServiceName =
        widget.isToggled
            ? widget.serviceNameInLocalLanguage
            : widget.serviceName;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: Text(
          displayServiceName,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF36322E),
          ),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        titleSpacing: 0.0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ReraCertificateStrings.getString(
                      'pleaseEnterYourDetails',
                      widget.isToggled,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.57,
                      color: const Color(0xFF36322E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _projectController,
                    decoration: InputDecoration(
                      hintText: ReraCertificateStrings.getString(
                        'projectName',
                        widget.isToggled,
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF36322E),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFC5C5C5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFC5C5C5)),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[\p{L}\s]', unicode: true),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return ValidationMessagesrera.getMessage(
                          'pleaseEnterProjectName',
                          widget.isToggled,
                        );
                      }
                      final trimmedValue = value.trim();
                      if (RegExp(
                        r'<.*?>|script|alert|on\w+=',
                        caseSensitive: false,
                      ).hasMatch(trimmedValue)) {
                        return ValidationMessagesrera.getMessage(
                          'invalidCharacters',
                          widget.isToggled,
                        );
                      }
                      if (!RegExp(
                        r'^[\p{L}\s]+$',
                        unicode: true,
                      ).hasMatch(trimmedValue)) {
                        return ValidationMessagesrera.getMessage(
                          'onlyAlphabetsAllowed',
                          widget.isToggled,
                        );
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _builderController,
                    decoration: InputDecoration(
                      hintText: ReraCertificateStrings.getString(
                        'builderName',
                        widget.isToggled,
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF36322E),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFC5C5C5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFC5C5C5)),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[\p{L}\s]', unicode: true),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return ValidationMessagesrera.getMessage(
                          'pleaseEnterBuilderName',
                          widget.isToggled,
                        );
                      }
                      final trimmedValue = value.trim();
                      if (RegExp(
                        r'<.*?>|script|alert|on\w+=',
                        caseSensitive: false,
                      ).hasMatch(trimmedValue)) {
                        return ValidationMessagesrera.getMessage(
                          'invalidCharacters',
                          widget.isToggled,
                        );
                      }
                      if (!RegExp(
                        r'^[\p{L}\s]+$',
                        unicode: true,
                      ).hasMatch(trimmedValue)) {
                        return ValidationMessagesrera.getMessage(
                          'onlyAlphabetsAllowed',
                          widget.isToggled,
                        );
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF57C03),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final String? stateId = prefs.getString('state_id');
                            final String? customerId = prefs.getString(
                              'customer_id',
                            );

                            Map<String, dynamic> formData = {
                              "customer_id": customerId,
                              "state_id": stateId,
                              "project_name": _projectController.text.trim(),
                              "builder_name": _builderController.text.trim(),
                              "tbl_name": "tbl_rera_certificate",
                            };

                            submitQuickServiceForm(context, formData);
                          }
                        },
                        child: Center(
                          child: Text(
                            ReraCertificateStrings.getString(
                              'next',
                              widget.isToggled,
                            ),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.43),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.00,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0x40F57C03),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 0.5,
                          color: const Color(0xFFFCCACA),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(14, 14, 18, 14),
                      child: Text(
                        ReraCertificateStrings.getString(
                          'note',
                          widget.isToggled,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF36322E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
