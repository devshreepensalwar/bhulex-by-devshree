// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_bhulekh_app/api_url/url.dart' show URLS;
import 'package:my_bhulekh_app/language/hindi.dart';
import 'package:my_bhulekh_app/quicke_services_forms/pay.dart';
import 'package:my_bhulekh_app/validations_chan_lang/seventwelveextract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class oldextract1 extends StatefulWidget {
  final String id;
  final String serviceName;
  final String tblName;
  final bool isToggled;
  final String serviceNameInLocalLanguage;
  const oldextract1({
    super.key,
    required this.id,
    required this.serviceName,
    required this.tblName,
    required this.isToggled,
    required this.serviceNameInLocalLanguage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _oldextract1State createState() => _oldextract1State();
}

class _oldextract1State extends State<oldextract1> {
  final TextEditingController _FieldSurveyNoController =
      TextEditingController();

  // ignore: non_constant_identifier_names
  final TextEditingController _ByNameIncasesurveynoisnotknownController =
      TextEditingController();

  String? Selectedcity;
  String? SelectedId;
  List<Map<String, dynamic>> talukaData = [];
  String? selectedTaluka; // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> CityData = [];
  List<Map<String, dynamic>> villageData = [];
  String? selectedVillageName;
  String? selectedVillageId;
  //String? selectedCityId;
  String? selectedTalukaId;
  TextEditingController cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    _fetchCity();
  }

  Future<void> submitOldServiceForm(
    BuildContext context,
    Map<String, dynamic> formData,
  ) async {
    final String url = URLS().submit_old_record_enquiry_form_apiUrl;
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
        print("Form submitted successfully: $responseData");

        // ✅ Show success dialog with PAY button
        // 🔥 Navigate directly to payscreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => payscreen(responseData: responseData),
          ),
        );
      } else {
        print("❌ Failed to submit form: ${response.body}");

        // Optional: You can navigate to a custom error page if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Form submission failed. Please try again.")),
        );
      }
    } catch (e) {
      print("❌ Exception occurred: $e");

      // Optional: You can navigate to a custom error page or show snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    }
  }

  // void _fetchCity() async {
  //   final String url = URLS().get_all_city_apiUrl;

  //   // Fetch state_id from SharedPreferences
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('state_id', '22');
  //   print('✅ state_id 22 saved to SharedPreferences');

  //   var requestBody = {"state_id": "22"};
  //   print('Request URL: $url');
  //   print('Request Body: ${jsonEncode(requestBody)}');

  //   try {
  //     var response = await http.post(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print('Response Status Code: ${response.statusCode}');
  //       print('Raw Response Body: "${response.body}"');

  //       if (data['status'] == 'true') {
  //         setState(() {
  //           CityData = List<Map<String, dynamic>>.from(data['data'] ?? []);
  //           isLoading = false;
  //         });
  //         print('Fetched City Data: ${data['data']}');
  //       } else {
  //         print('Failed to load city: ${data['message'] ?? 'Unknown error'}');
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     } else {
  //       print('Failed to load data. Status code: ${response.statusCode}');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // void _fetchTaluka(String cityId) async {
  //   final String url = URLS().get_all_taluka_apiUrl;
  //   var requestBody = {"city_id": cityId};

  //   print('📤 Requesting Taluka List from: $url');
  //   print('📤 Request Body: ${jsonEncode(requestBody)}');

  //   try {
  //     var response = await http.post(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       log('Taluka Response Status Code: ${response.statusCode}');
  //       log('Taluka Response Body: ${response.body}'); // Explicit raw response
  //       if (data != null && data['status'] == 'true') {
  //         setState(() {
  //           talukaData = List<Map<String, dynamic>>.from(data['data']);
  //         });
  //         log(' Taluka Data Loaded: ${data['data']}');
  //       } else {
  //         log('Taluka load failed: ${data['message'] ?? "Unknown error"}');
  //       }
  //     } else {
  //       print('Taluka API HTTP Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Taluka fetch exception: $e');
  //   }
  // }

  // void _fetchVillages(String cityId, String talukaId) async {
  //   final url = URLS().get_all_village_apiUrl;

  //   var requestBody = {"city_id": cityId, "taluka_id": talukaId};

  //   print('Village Request: ${jsonEncode(requestBody)}');
  //   print('Request URL: $url');

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: jsonEncode(requestBody),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       log('Village Response Status Code: ${response.statusCode}');
  //       log('Village Response Body: ${response.body}');
  //       if (data['status'] == 'true') {
  //         setState(() {
  //           villageData = List<Map<String, dynamic>>.from(data['data']);
  //         });
  //         log("Villages Loaded");
  //       } else {
  //         log("Village loading failed: ${data['message']}");
  //       }
  //     } else {
  //       log("Server error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     ("Exception while fetching villages: $e");
  //   }
  // }
  void _fetchCity() async {
    final String url = URLS().get_all_city_apiUrl;
    log('City URL: $url');

    // Fetch state_id from SharedPreferences and set it to "22" for testing
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('state_id', '22');
    log('✅ state_id 22 saved to SharedPreferences');

    var requestBody = {"state_id": "22"};
    log('City Request Body: ${jsonEncode(requestBody)}');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      log('City Response Status Code: ${response.statusCode}');
      log('City Raw Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'true') {
          setState(() {
            CityData = List<Map<String, dynamic>>.from(data['data'] ?? []);
            isLoading = false;
          });
          log('Fetched City Data: ${data['data']}');
        } else {
          log('Failed to load city: ${data['message'] ?? 'Unknown error'}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        log('Failed to load city data. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('City Fetch Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _fetchTaluka(String cityId) async {
    final String url = URLS().get_all_taluka_apiUrl;
    log('Taluka URL: $url');

    var requestBody = {"city_id": cityId};
    log('Taluka Request Body: ${jsonEncode(requestBody)}');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      log('Taluka Response Status Code: ${response.statusCode}');
      log('Taluka Raw Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'true') {
          setState(() {
            talukaData = List<Map<String, dynamic>>.from(data['data'] ?? []);
          });
          log('Fetched Taluka Data: ${data['data']}');
        } else {
          log('Failed to load taluka: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        log('Failed to load taluka data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Taluka Fetch Error: $e');
    }
  }

  void _fetchVillages(String cityId, String talukaId) async {
    final String url = URLS().get_all_village_apiUrl;
    log('Village URL: $url');

    var requestBody = {"city_id": cityId, "taluka_id": talukaId};
    log('Village Request Body: ${jsonEncode(requestBody)}');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      log('Village Response Status Code: ${response.statusCode}');
      log('Village Raw Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'true') {
          setState(() {
            villageData = List<Map<String, dynamic>>.from(data['data'] ?? []);
          });
          log('Fetched Village Data: ${data['data']}');
        } else {
          log('Failed to load villages: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        log('Failed to load village data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Village Fetch Error: $e');
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
      Selectedcity = null;
      _FieldSurveyNoController.clear();
      selectedVillageName = null;
      selectedTaluka = null;
      _ByNameIncasesurveynoisnotknownController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        title: Text(
          widget.serviceName,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF36322E),
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        titleSpacing: 0.0,
        elevation: 0, // Remove default shadow
        leading: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HomePage2(),
            //   ), // Replace with your screen widget
            // );
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Height of the bottom border
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFD9D9D9), // Set the border color
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              height: 900,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      LocalizedStrings.getString(
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
                    const SizedBox(height: 16),
                    FormField<String>(
                      validator: (value) {
                        if (Selectedcity == null ||
                            Selectedcity!.trim().isEmpty) {
                          return ValidationMessagesseventweleve.getMessage(
                            'pleaseSelectDistrict',
                            widget.isToggled,
                          );
                        }
                        final trimmedValue = Selectedcity!.trim();
                        if (RegExp(
                          r'<.*?>|script|alert|on\w+=',
                          caseSensitive: false,
                        ).hasMatch(trimmedValue)) {
                          return ValidationMessagesseventweleve.getMessage(
                            'invalidCharacters',
                            widget.isToggled,
                          );
                        }
                        // if (!RegExp(
                        //   r'^[\p{L}\s]+$',
                        //   unicode: true,
                        // ).hasMatch(trimmedValue)) {
                        //   return ValidationMessagesseventweleve.getMessage(
                        //     'onlyAlphabetsAllowed',
                        //     widget.isToggled,
                        //   );
                        // }
                        return null;
                      },
                      builder: (FormFieldState<String> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownSearch<String>(
                              items:
                                  CityData.map<String>((item) {
                                    return widget.isToggled
                                        ? (item['city_name_in_local_language'])
                                            .toString()
                                        : (item['city_name']).toString();
                                  }).toList(),

                              selectedItem: Selectedcity,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: LegaldraftsStrings.getString(
                                    'district',
                                    widget.isToggled,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFC5C5C5),
                                    ),
                                  ),
                                  errorText: state.errorText,
                                ),
                              ),
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  textCapitalization: TextCapitalization.words,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[\p{L}\s]', unicode: true),
                                    ),
                                    LengthLimitingTextInputFormatter(50),
                                  ],
                                  decoration: InputDecoration(
                                    hintText:
                                        widget.isToggled
                                            ? 'जिल्हा शोधा...'
                                            : 'Search District...',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              dropdownButtonProps: DropdownButtonProps(
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 28,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              // onChanged: (value) {
                              //   setState(() {
                              //     Selectedcity = value;
                              //     SelectedId =
                              //         CityData.firstWhere(
                              //           (element) =>
                              //               element['city_name'] == value,
                              //         )['id'].toString();
                              //     _fetchTaluka(SelectedId!);
                              //     state.didChange(value);
                              //   });
                              // },
                              onChanged: (value) {
                                log('${widget.isToggled}');
                                setState(() {
                                  Selectedcity = value;

                                  final matchedCity = CityData.firstWhere(
                                    (element) =>
                                        (widget.isToggled
                                            ? (element['city_name_in_local_language'])
                                            : element['city_name']) ==
                                        value,
                                    orElse: () => {},
                                  );

                                  SelectedId =
                                      matchedCity.isNotEmpty
                                          ? matchedCity['id'].toString()
                                          : null;

                                  if (SelectedId != null) {
                                    _fetchTaluka(SelectedId!);
                                  }

                                  state.didChange(value);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    FormField<String>(
                      validator: (value) {
                        if (selectedTaluka == null ||
                            selectedTaluka!.trim().isEmpty) {
                          return ValidationMessagesseventweleve.getMessage(
                            'pleaseSelectTaluka',
                            widget.isToggled,
                          );
                        }
                        final trimmedValue = selectedTaluka!.trim();
                        if (RegExp(
                          r'<.*?>|script|alert|on\w+=',
                          caseSensitive: false,
                        ).hasMatch(trimmedValue)) {
                          return ValidationMessagesseventweleve.getMessage(
                            'invalidCharacters',
                            widget.isToggled,
                          );
                        }
                        // if (!RegExp(
                        //   r'^[\p{L}\s]+$',
                        //   unicode: true,
                        // ).hasMatch(trimmedValue)) {
                        //   return ValidationMessagesseventweleve.getMessage(
                        //     'onlyAlphabetsAllowed',
                        //     widget.isToggled,
                        //   );
                        // }
                        return null;
                      },
                      builder: (FormFieldState<String> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownSearch<String>(
                              items:
                                  talukaData.map<String>((item) {
                                    return widget.isToggled
                                        ? (item['taluka_name_in_local_language'] ??
                                                item['taluka_name'] ??
                                                '')
                                            .toString()
                                        : (item['taluka_name'] ?? '')
                                            .toString();
                                  }).toList(),

                              selectedItem: selectedTaluka,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: LocalizedStrings.getString(
                                    'taluka',
                                    widget.isToggled,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFC5C5C5),
                                    ),
                                  ),
                                  errorText: state.errorText,
                                ),
                              ),
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  textCapitalization: TextCapitalization.words,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[\p{L}\s]', unicode: true),
                                    ),
                                    LengthLimitingTextInputFormatter(50),
                                  ],
                                  decoration: InputDecoration(
                                    hintText:
                                        widget.isToggled
                                            ? 'तालुका शोधा...'
                                            : 'Search Taluka...',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              dropdownButtonProps: DropdownButtonProps(
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 28,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedTaluka = value;

                                  final matchedTaluka = talukaData.firstWhere(
                                    (element) =>
                                        (widget.isToggled
                                            ? (element['taluka_name_in_local_language'] ??
                                                element['taluka_name'])
                                            : element['taluka_name']) ==
                                        value,
                                    orElse: () => {},
                                  );

                                  selectedTalukaId =
                                      matchedTaluka.isNotEmpty
                                          ? matchedTaluka['id'].toString()
                                          : null;

                                  if (selectedTalukaId != null) {
                                    _fetchVillages(
                                      SelectedId!,
                                      selectedTalukaId!,
                                    );
                                  }

                                  state.didChange(value);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    FormField<String>(
                      validator: (value) {
                        if (selectedVillageName == null ||
                            selectedVillageName!.trim().isEmpty) {
                          return ValidationMessagesseventweleve.getMessage(
                            'pleaseSelectVillage',
                            widget.isToggled,
                          );
                        }
                        final trimmedValue = selectedVillageName!.trim();
                        if (RegExp(
                          r'<.*?>|script|alert|on\w+=',
                          caseSensitive: false,
                        ).hasMatch(trimmedValue)) {
                          return ValidationMessagesseventweleve.getMessage(
                            'invalidCharacters',
                            widget.isToggled,
                          );
                        }
                        // if (!RegExp(
                        //   r'^[\p{L}\s]+$',
                        //   unicode: true,
                        // ).hasMatch(trimmedValue)) {
                        //   return ValidationMessagesseventweleve.getMessage(
                        //     'onlyAlphabetsAllowed',
                        //     widget.isToggled,
                        //   );
                        // }
                        return null;
                      },
                      builder: (FormFieldState<String> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownSearch<String>(
                              items:
                                  villageData.map<String>((item) {
                                    return widget.isToggled
                                        ? (item['village_name_in_local_language'] ??
                                                item['village_name'] ??
                                                '')
                                            .toString()
                                        : (item['village_name'] ?? '')
                                            .toString();
                                  }).toList(),

                              selectedItem: selectedVillageName,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: LocalizedStrings.getString(
                                    'village',
                                    widget.isToggled,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFC5C5C5),
                                    ),
                                  ),
                                  errorText: state.errorText,
                                ),
                              ),
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  textCapitalization: TextCapitalization.words,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[\p{L}\s]', unicode: true),
                                    ),
                                    LengthLimitingTextInputFormatter(50),
                                  ],
                                  decoration: InputDecoration(
                                    hintText:
                                        widget.isToggled
                                            ? 'गाव शोधा...'
                                            : 'Search Village...',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              dropdownButtonProps: DropdownButtonProps(
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 28,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedVillageName = value;

                                  final matchedVillage = villageData.firstWhere(
                                    (element) =>
                                        (widget.isToggled
                                            ? (element['village_name_in_local_language'] ??
                                                element['village_name'])
                                            : element['village_name']) ==
                                        value,
                                    orElse: () => {},
                                  );

                                  selectedVillageId =
                                      matchedVillage.isNotEmpty
                                          ? matchedVillage['id'].toString()
                                          : null;

                                  state.didChange(value);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _FieldSurveyNoController,
                      decoration: InputDecoration(
                        hintText: LocalizedStrings.getString(
                          'fieldSurveyNo',
                          widget.isToggled,
                        ),
                        hintStyle: const TextStyle(color: Color(0xFF36322E)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFC5C5C5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFC5C5C5),
                          ),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return ValidationMessagesseventweleve.getMessage(
                            'pleaseEnterSurveyNo',
                            widget.isToggled,
                          );
                        }
                        final trimmedValue = value.trim();
                        if (RegExp(
                          r'<.*?>|script|alert|on\w+=',
                          caseSensitive: false,
                        ).hasMatch(trimmedValue)) {
                          return ValidationMessagesseventweleve.getMessage(
                            'invalidCharacters',
                            widget.isToggled,
                          );
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ByNameIncasesurveynoisnotknownController,
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            text: LocalizedStrings.getString(
                              'byName',
                              widget.isToggled,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF36322E),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    ' ${LocalizedStrings.getString('byNameHint', widget.isToggled)}',
                                style: const TextStyle(
                                  color: Color(0xFF36322E),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9),
                          ),
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
                          return ValidationMessagesseventweleve.getMessage(
                            'pleaseEnterByName',
                            widget.isToggled,
                          );
                        }
                        final trimmedValue = value.trim();
                        if (RegExp(
                          r'<.*?>|script|alert|on\w+=',
                          caseSensitive: false,
                        ).hasMatch(trimmedValue)) {
                          return ValidationMessagesseventweleve.getMessage(
                            'invalidCharacters',
                            widget.isToggled,
                          );
                        }
                        if (!RegExp(
                          r'^[\p{L}\s]+$',
                          unicode: true,
                        ).hasMatch(trimmedValue)) {
                          return ValidationMessagesseventweleve.getMessage(
                            'onlyAlphabetsAllowed',
                            widget.isToggled,
                          );
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
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
                              final String? stateId = prefs.getString(
                                'state_id',
                              );
                              final String? customerId = prefs.getString(
                                'customer_id',
                              );
                              Map<String, dynamic> formData = {
                                "tbl_name": widget.tblName,
                                "customer_id": customerId,
                                "state_id": stateId,
                                "city_id": SelectedId,
                                "taluka_id": selectedTalukaId,
                                "village_id": selectedVillageId,
                                "survey_no": _FieldSurveyNoController.text,
                                "name":
                                    _ByNameIncasesurveynoisnotknownController
                                        .text,
                              };
                              submitOldServiceForm(context, formData);
                            }
                          },
                          child: Center(
                            child: Text(
                              LocalizedStrings.getString(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.19),
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
                          LocalizedStrings.getString('note', widget.isToggled),
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
      ),
    );
  }
}
