import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_bhulekh_app/api_url/url.dart';
import 'package:my_bhulekh_app/homepage.dart';
import 'package:my_bhulekh_app/language/hindi.dart';
import 'package:my_bhulekh_app/quicke_services_forms/pay.dart';
import 'package:my_bhulekh_app/validations_chan_lang/seventwelveextract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigitallySign1 extends StatefulWidget {
  final String id;
  final String serviceName;
  final String tblName;
  final bool isToggled;
  final String serviceNameInLocalLanguage;

  const DigitallySign1({
    Key? key,
    required this.id,
    required this.serviceName,
    required this.tblName,
    required this.isToggled,
    required this.serviceNameInLocalLanguage,
  }) : super(key: key);

  @override
  State<DigitallySign1> createState() => _DigitallySign1State();
}

class _DigitallySign1State extends State<DigitallySign1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _surveyNoController = TextEditingController();
  final TextEditingController _ByNameIncasesurveynoisnotknownController =
      TextEditingController();

  String? Selectedcity;
  String? SelectedId;
  List<Map<String, dynamic>> talukaData = [];
  String? selectedTaluka;
  List<Map<String, dynamic>> CityData = [];
  List<Map<String, dynamic>> villageData = [];
  String? selectedVillageName;
  String? selectedVillageId;
  String? selectedTalukaId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCity();
  }

  Future<void> submitQuickServiceForm(
    BuildContext context,
    Map<String, dynamic> formData,
  ) async {
    final String url = URLS().submit_quick_service_enquiry_form_apiUrl;

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(formData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => payscreen(responseData: responseData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Form submission failed. Please try again."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    }
  }

  void _fetchCity() async {
    final String url = URLS().get_all_city_apiUrl;

    // Fetch state_id from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('state_id', '22');
    print('✅ state_id 22 saved to SharedPreferences');

    var requestBody = {"state_id": "22"};
    print('Request URL: $url');
    print('Request Body: ${jsonEncode(requestBody)}');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response Status Code: ${response.statusCode}');
        print('Raw Response Body: "${response.body}"');

        if (data['status'] == 'true') {
          setState(() {
            CityData = List<Map<String, dynamic>>.from(data['data'] ?? []);
            isLoading = false;
          });
          print('Fetched City Data: ${data['data']}');
        } else {
          print('Failed to load city: ${data['message'] ?? 'Unknown error'}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _fetchTaluka(String cityId) async {
    final String url = URLS().get_all_taluka_apiUrl;
    var requestBody = {"city_id": cityId};
    log('Request Body: ${jsonEncode(requestBody)}');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response Status Code: ${response.statusCode}');
        print('Raw Response Body: "${response.body}"');

        if (data['status'] == 'true') {
          setState(() {
            talukaData = List<Map<String, dynamic>>.from(data['data']);
          });
        }
      }
    } catch (e) {
      print('❌ Taluka fetch error: $e');
    }
  }

  void _fetchVillages(String cityId, String talukaId) async {
    final url = URLS().get_all_village_apiUrl;
    var requestBody = {"city_id": cityId, "taluka_id": talukaId};
    log('Request Body: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response Status Code: ${response.statusCode}');
        print('Raw Response Body: "${response.body}"');

        if (data['status'] == 'true') {
          setState(() {
            villageData = List<Map<String, dynamic>>.from(data['data']);
          });
        }
      }
    } catch (e) {
      print("❌ Exception while fetching villages: $e");
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
      Selectedcity = null;
      _surveyNoController.clear();
      selectedVillageName = null;
      selectedTaluka = null;
      _ByNameIncasesurveynoisnotknownController.clear();
    });
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const HomePage2()),
            // );
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
            child: Container(
              height: 800,
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
                                  hintText: LocalizedStrings.getString(
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
                              // popupProps: PopupProps.menu(
                              //   showSearchBox: true,
                              //   searchFieldProps: TextFieldProps(
                              //     textCapitalization: TextCapitalization.words,
                              //     inputFormatters: [
                              //       FilteringTextInputFormatter.allow(
                              //         RegExp(r'[\p{L}\s]', unicode: true),
                              //       ),
                              //       LengthLimitingTextInputFormatter(50),
                              //     ],
                              //     decoration: InputDecoration(
                              //       hintText:
                              //           widget.isToggled
                              //               ? 'जिल्हा शोधा...'
                              //               : 'Search District...',
                              //       border: const OutlineInputBorder(),
                              //     ),
                              //   ),
                              // ),
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
                        final trimmedValue = selectedVillageName!.trim();
                        if (RegExp(
                          r'<.*?>|script|alert|on\w+=',
                          caseSensitive: false,
                        ).hasMatch(trimmedValue)) {
                          return ValidationMessagesseventweleve.getMessage(
                            'invalidCharacters',
                            widget.isToggled,
                          );
                        } // Allow Marathi (Devanagari), English alphabets, and spaces
                        // if (!RegExp(
                        //   r'^[\p{L}\s]+$',
                        //   unicode: true,
                        // ).hasMatch(trimmedValue)) {
                        //   // Debug: Log the failing value
                        //   print("Regex failed for taluka: '$trimmedValue'");
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
                                log('${widget.isToggled}');

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
                                  if (selectedTalukaId != null &&
                                      SelectedId != null) {
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
                                  villageData
                                      .map<String>((item) {
                                        final villageName =
                                            widget.isToggled
                                                ? (item['village_name_in_local_language'] ??
                                                    item['village_name'])
                                                : item['village_name'];
                                        return villageName?.toString() ?? '';
                                      })
                                      .where(
                                        (name) =>
                                            name.trim().isNotEmpty &&
                                            name.toLowerCase() != 'null',
                                      )
                                      .toList(),
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
                      controller: _surveyNoController,
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
                        FilteringTextInputFormatter.allow(RegExp("[0-9 /]")),
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
                                "survey_no": _surveyNoController.text,
                                "name":
                                    _ByNameIncasesurveynoisnotknownController
                                        .text,
                              };
                              submitQuickServiceForm(context, formData);
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
// import 'dart:convert';
// import 'dart:developer';

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:my_bhulekh_app/api_url/url.dart';
// import 'package:my_bhulekh_app/homepage.dart';
// import 'package:my_bhulekh_app/information/info.dart';
// import 'package:my_bhulekh_app/quicke_services_forms/digitally_sign_property_card.dart';
// import 'package:my_bhulekh_app/quicke_services_forms/pay.dart';
// import 'package:my_bhulekh_app/quicke_services_forms/thank_you.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DigitallySign1 extends StatefulWidget {
//   final String id;
//   final String serviceName;
//   final String tblName;

//   DigitallySign1({
//     Key? key,
//     required this.id,
//     required this.serviceName,
//     required this.tblName,
//   }) : super(key: key);

//   @override
//   State<DigitallySign1> createState() => _DigitallySign1State();
// }

// class _DigitallySign1State extends State<DigitallySign1> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _surveyNoController = TextEditingController();
//   // ignore: non_constant_identifier_names
//   final TextEditingController _ByNameIncasesurveynoisnotknownController =
//       TextEditingController();

//   // ignore: non_constant_identifier_names
//   String? Selectedcity;
//   String? SelectedId;
//   List<Map<String, dynamic>> talukaData = [];
//   String? selectedTaluka; // ignore: non_constant_identifier_names
//   List<Map<String, dynamic>> CityData = [];
//   List<Map<String, dynamic>> villageData = [];
//   String? selectedVillageName;
//   String? selectedVillageId;
//   //String? selectedCityId;
//   String? selectedTalukaId;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     // submitQuickServiceForm(
//     //   tblName: widget.tblName, // ensure this is coming properly
//     //   serviceName: widget.serviceName,
//     //   id: widget.id,
//     // );
//     _fetchCity();
//   }

//   Future<void> submitQuickServiceForm(
//     BuildContext context,
//     Map<String, dynamic> formData,
//   ) async {
//     final String url = URLS().submit_quick_service_enquiry_form_apiUrl;
//     print('Request URL: $url');
//     print('Request Body: ${jsonEncode(formData)}');

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         body: jsonEncode(formData),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("Form submitted successfully: $responseData");

//         // ✅ Show success dialog with PAY button
//         // 🔥 Navigate directly to payscreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => payscreen(responseData: responseData),
//           ),
//         );
//       } else {
//         print("❌ Failed to submit form: ${response.body}");

//         // Optional: You can navigate to a custom error page if needed
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Form submission failed. Please try again.")),
//         );
//       }
//     } catch (e) {
//       print("❌ Exception occurred: $e");

//       // Optional: You can navigate to a custom error page or show snackbar
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
//     }
//   }

//   void _fetchCity() async {
//     // var requestBody = {"taluka_id": selectedTaluka};
//     // print('Request Body: ${jsonEncode(requestBody)}');

//     final String url = URLS().get_all_city_apiUrl;
//     print('Request URL: $url');

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         // body: jsonEncode(requestBody),
//         headers: {'Content-Type': 'application/json'},
//       );

//       print('Response Status Code: ${response.statusCode}');
//       log('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == 'true') {
//           setState(() {
//             CityData = List<Map<String, dynamic>>.from(data['data']);
//           });
//           log('Fetched City Data: ${data['data']}');
//         } else {
//           print('Failed to load city: ${data['message']}');
//         }
//       } else {
//         print('Failed to load data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _fetchTaluka(String cityId) async {
//     final String url = URLS().get_all_taluka_apiUrl;
//     var requestBody = {"city_id": cityId};

//     print('📤 Requesting Taluka List from: $url');
//     print('📤 Request Body: ${jsonEncode(requestBody)}');

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       print('📥 Taluka Response Status Code: ${response.statusCode}');
//       log('📥 Taluka Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'true') {
//           setState(() {
//             talukaData = List<Map<String, dynamic>>.from(data['data']);
//           });
//         } else {
//           print('❌ Failed to load taluka: ${data['message']}');
//         }
//       } else {
//         print('❌ Failed to load taluka. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Taluka fetch error: $e');
//     }
//   }

//   void _fetchVillages(String cityId, String talukaId) async {
//     final url = URLS().get_all_village_apiUrl;

//     var requestBody = {"city_id": cityId, "taluka_id": talukaId};

//     print('Village Request: ${jsonEncode(requestBody)}');
//     print('Request URL: $url');

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: jsonEncode(requestBody),
//         headers: {'Content-Type': 'application/json'},
//       );

//       print('Village Response Status Code: ${response.statusCode}');
//       log('Village Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == 'true') {
//           setState(() {
//             villageData = List<Map<String, dynamic>>.from(data['data']);
//           });
//           log("✅ Villages Loaded");
//         } else {
//           print("❌ Village loading failed: ${data['message']}");
//         }
//       } else {
//         print("❌ Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Exception while fetching villages: $e");
//     }
//   }

//   Future<void> _onRefresh() async {
//     setState(() {
//       isLoading = true;
//       Selectedcity = null;
//       _surveyNoController.clear();
//       selectedVillageName = null;
//       selectedTaluka = null;
//       _ByNameIncasesurveynoisnotknownController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFDFDFD),
//       appBar: AppBar(
//         title: Text(
//           widget.serviceName,
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF36322E),
//           ),
//         ),
//         backgroundColor: Color(0xFFFFFFFF),
//         titleSpacing: 0.0,
//         elevation: 0, // Remove default shadow
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomePage2(),
//               ), // Replace with your screen widget
//             );
//           },
//           child: Icon(Icons.arrow_back),
//         ),

//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1.0), // Height of the bottom border
//           child: Divider(
//             height: 1,
//             thickness: 1,
//             color: Color(0xFFD9D9D9), // Set the border color
//           ),
//         ),
//       ),

//       body: RefreshIndicator(
//         onRefresh: _onRefresh,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Container(
//               height: 800,
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     // SizedBox(height: 10),
//                     Text(
//                       'Please Enter Your Details ',
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         height:
//                             1.57, // line height of 22px (14px * 1.57 = 22px)
//                         color: Color(0xFF36322E), // Set color to black
//                       ),
//                       textAlign: TextAlign.center, // Centers the text
//                     ),

//                     // Customer Name Field
//                     SizedBox(height: 16),
//                     FormField<String>(
//                       validator: (value) {
//                         if (Selectedcity == null ||
//                             Selectedcity!.trim().isEmpty) {
//                           return 'Please select a District';
//                         }

//                         final trimmedValue = Selectedcity!.trim();

//                         if (RegExp(
//                           r'<.*?>|script|alert|on\w+=',
//                           caseSensitive: false,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Invalid characters or script content detected';
//                         }

//                         if (!RegExp(
//                           r'^[\p{L}\s]+$',
//                           unicode: true,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Only alphabets and spaces allowed';
//                         }

//                         return null;
//                       },
//                       builder: (FormFieldState<String> state) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             DropdownSearch<String>(
//                               items:
//                                   CityData.map(
//                                     (item) => item['city_name'].toString(),
//                                   ).toList(),
//                               selectedItem: Selectedcity,
//                               dropdownDecoratorProps: DropDownDecoratorProps(
//                                 dropdownSearchDecoration: InputDecoration(
//                                   hintText: "District",
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 14,
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(6),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFC5C5C5),
//                                     ),
//                                   ),
//                                   errorText:
//                                       state
//                                           .errorText, // Validation error shown here
//                                 ),
//                               ),
//                               popupProps: PopupProps.menu(
//                                 showSearchBox: true,
//                                 searchFieldProps: TextFieldProps(
//                                   textCapitalization: TextCapitalization.words,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.allow(
//                                       RegExp(r'[\p{L}\s]', unicode: true),
//                                     ),
//                                     LengthLimitingTextInputFormatter(50),
//                                   ],
//                                   decoration: InputDecoration(
//                                     hintText: "Search District...",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   Selectedcity = value;
//                                   SelectedId =
//                                       CityData.firstWhere(
//                                         (element) =>
//                                             element['city_name'] == value,
//                                       )['id'].toString();
//                                   _fetchTaluka(SelectedId!);
//                                   state.didChange(
//                                     value,
//                                   ); // ✅ Important to trigger validator
//                                 });
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     ),

//                     SizedBox(height: 16),

//                     /// Taluka Dropdown
//                     FormField<String>(
//                       validator: (value) {
//                         if (selectedTaluka == null ||
//                             selectedTaluka!.trim().isEmpty) {
//                           return 'Please select a Taluka';
//                         }

//                         final trimmedValue = selectedTaluka!.trim();

//                         // Block HTML/script tags or suspicious patterns
//                         if (RegExp(
//                           r'<.*?>|script|alert|on\w+=',
//                           caseSensitive: false,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Invalid characters or script content detected';
//                         }

//                         // Allow only Unicode letters and spaces
//                         if (!RegExp(
//                           r'^[\p{L}\s]+$',
//                           unicode: true,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Only alphabets and spaces allowed';
//                         }

//                         return null;
//                       },
//                       builder: (FormFieldState<String> state) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             DropdownSearch<String>(
//                               items:
//                                   talukaData
//                                       .map(
//                                         (item) =>
//                                             item['taluka_name'].toString(),
//                                       )
//                                       .toList(),
//                               selectedItem: selectedTaluka,
//                               dropdownDecoratorProps: DropDownDecoratorProps(
//                                 dropdownSearchDecoration: InputDecoration(
//                                   hintText: "Taluka/Tahashil",
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 14,
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(6),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFC5C5C5),
//                                     ),
//                                   ),
//                                   errorText: state.errorText,
//                                 ),
//                               ),
//                               popupProps: PopupProps.menu(
//                                 showSearchBox: true,
//                                 searchFieldProps: TextFieldProps(
//                                   textCapitalization: TextCapitalization.words,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.allow(
//                                       RegExp(r'[\p{L}\s]', unicode: true),
//                                     ),
//                                     LengthLimitingTextInputFormatter(50),
//                                   ],
//                                   decoration: InputDecoration(
//                                     hintText: "Search Taluka...",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedTaluka = value;
//                                   selectedTalukaId =
//                                       talukaData
//                                           .firstWhere(
//                                             (element) =>
//                                                 element['taluka_name'] == value,
//                                           )['id']
//                                           .toString();
//                                   _fetchVillages(
//                                     SelectedId!,
//                                     selectedTalukaId!,
//                                   );
//                                   state.didChange(
//                                     value,
//                                   ); // ✅ Important for validation update
//                                 });
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     ),

//                     SizedBox(height: 16),

//                     /// Village Dropdown
//                     FormField<String>(
//                       validator: (value) {
//                         if (selectedVillageName == null ||
//                             selectedVillageName!.trim().isEmpty) {
//                           return 'Please select a Village';
//                         }

//                         final trimmedValue = selectedVillageName!.trim();

//                         // Block HTML/script tags or suspicious patterns
//                         if (RegExp(
//                           r'<.*?>|script|alert|on\w+=',
//                           caseSensitive: false,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Invalid characters or script content detected';
//                         }

//                         // Allow only Unicode letters and spaces
//                         if (!RegExp(
//                           r'^[\p{L}\s]+$',
//                           unicode: true,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Only alphabets and spaces allowed';
//                         }

//                         return null;
//                       },
//                       builder: (FormFieldState<String> state) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             DropdownSearch<String>(
//                               items:
//                                   villageData
//                                       .map(
//                                         (item) =>
//                                             item['village_name'].toString(),
//                                       )
//                                       .toList(),
//                               selectedItem: selectedVillageName,
//                               dropdownDecoratorProps: DropDownDecoratorProps(
//                                 dropdownSearchDecoration: InputDecoration(
//                                   hintText: "Village/Mauza",
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 14,
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(6),
//                                     borderSide: BorderSide(
//                                       color: Color(0xFFC5C5C5),
//                                     ),
//                                   ),
//                                   errorText:
//                                       state.errorText, // 🔥 Show error here
//                                 ),
//                               ),
//                               popupProps: PopupProps.menu(
//                                 showSearchBox: true,
//                                 searchFieldProps: TextFieldProps(
//                                   textCapitalization: TextCapitalization.words,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.allow(
//                                       RegExp(r'[\p{L}\s]', unicode: true),
//                                     ),
//                                     LengthLimitingTextInputFormatter(50),
//                                   ],
//                                   decoration: InputDecoration(
//                                     hintText: "Search Village...",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedVillageName = value;
//                                   selectedVillageId =
//                                       villageData
//                                           .firstWhere(
//                                             (element) =>
//                                                 element['village_name'] ==
//                                                 value,
//                                           )['id']
//                                           .toString();
//                                   state.didChange(
//                                     value,
//                                   ); // 🔥 Notify form field of change
//                                 });
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     ),

//                     SizedBox(height: 16),

//                     TextFormField(
//                       controller: _surveyNoController,
//                       decoration: InputDecoration(
//                         hintText: 'Field Survey No',
//                         hintStyle: TextStyle(
//                           color: Color(0xFF36322E),
//                         ), // Set hint text color
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(
//                             6,
//                           ), // Set border radius
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(
//                             6,
//                           ), // Set border radius
//                           borderSide: BorderSide(
//                             color: Color(0xFFC5C5C5),
//                           ), // Set border color
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(
//                             6,
//                           ), // Set border radius
//                           borderSide: BorderSide(color: Color(0xFFC5C5C5)),
//                           // Set focused border color
//                         ),
//                       ),
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//                       ],
//                       textCapitalization: TextCapitalization.words,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter Field Survey No.';
//                         }

//                         final trimmedValue = value.trim();

//                         // Block HTML/script tags or suspicious patterns
//                         if (RegExp(
//                           r'<.*?>|script|alert|on\w+=',
//                           caseSensitive: false,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Invalid characters or script content detected';
//                         }

//                         // // Allow only Unicode letters and spaces
//                         // if (!RegExp(
//                         //   r'^[\p{L}\s]+$',
//                         //   unicode: true,
//                         // ).hasMatch(trimmedValue)) {
//                         //   return 'Only alphabets and spaces allowed';
//                         // }

//                         return null;
//                       },
//                       // validator: (value) {
//                       //   if (value == null || value.isEmpty) {
//                       //     return 'Please enter Field Survey No.';
//                       //   }
//                       //   return null;
//                       // },
//                     ),

//                     SizedBox(height: 16),

//                     // Date of Birth Field
//                     TextFormField(
//                       controller: _ByNameIncasesurveynoisnotknownController,
//                       decoration: InputDecoration(
//                         label: RichText(
//                           text: TextSpan(
//                             text: 'By Name ',
//                             style: const TextStyle(
//                               color: Color(0xFF36322E),
//                               fontSize: 16, // Normal font size
//                               fontWeight: FontWeight.w400,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: '(In Case Survey No. Is Not known)',
//                                 style: const TextStyle(
//                                   color: Color(0xFF36322E),
//                                   fontSize: 10, // Smaller font size
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                           borderSide: const BorderSide(
//                             color: Color(0xFFD9D9D9),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                           borderSide: const BorderSide(
//                             color: Color(0xFFD9D9D9),
//                           ),
//                         ),
//                       ),
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(
//                           RegExp(r'[\p{L}\s]', unicode: true),
//                         ),
//                         LengthLimitingTextInputFormatter(50),
//                       ],
//                       textCapitalization: TextCapitalization.words,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter By name';
//                         }

//                         final trimmedValue = value.trim();

//                         // Block HTML/script tags or suspicious patterns
//                         if (RegExp(
//                           r'<.*?>|script|alert|on\w+=',
//                           caseSensitive: false,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Invalid characters or script content detected';
//                         }

//                         // Allow only Unicode letters and spaces
//                         if (!RegExp(
//                           r'^[\p{L}\s]+$',
//                           unicode: true,
//                         ).hasMatch(trimmedValue)) {
//                           return 'Only alphabets and spaces allowed';
//                         }

//                         return null;
//                       },
//                       //    validator: (value) {
//                       //                   if (value == null || value.isEmpty) {
//                       //                     return 'Please select By Name (In case survey no. is not known)';
//                       //                   }
//                       //                   return null;
//                       //                 },
//                     ),

//                     // Submit Button
//                     Padding(
//                       padding: const EdgeInsets.only(top: 70.0),
//                       child: Container(
//                         width: double.infinity, // Full width
//                         height: 50, // Set height
//                         decoration: BoxDecoration(
//                           color: Color(0xFFF57C03), // Orange Background
//                           borderRadius: BorderRadius.circular(
//                             8,
//                           ), // Set border radius
//                         ),
//                         child: TextButton(
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();
//                               final String? stateId = prefs.getString(
//                                 'state_id',
//                               );
//                               final String? customer_id = prefs.getString(
//                                 'customer_id',
//                               );
//                               // ✅ All validations passed
//                               Map<String, dynamic> formData = {
//                                 "tbl_name": widget.tblName,
//                                 "customer_id": customer_id,
//                                 "state_id": stateId,
//                                 "city_id": SelectedId,
//                                 "taluka_id": selectedTalukaId,
//                                 "village_id": selectedVillageId,
//                                 "survey_no": _surveyNoController.text,
//                                 "name":
//                                     _ByNameIncasesurveynoisnotknownController
//                                         .text,
//                               };

//                               submitQuickServiceForm(context, formData);
//                             } else {
//                               // ❌ Validation failed - errors will show up automatically
//                               debugPrint("Validation failed. Fix errors.");
//                             }
//                           },
//                           child: Center(
//                             child: Text(
//                               'Next',
//                               style: GoogleFonts.inter(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Padding(
//                     //   padding: const EdgeInsets.only(top: 70.0),
//                     //   child: Container(
//                     //     width: double.infinity,
//                     //     height: 50,
//                     //     decoration: BoxDecoration(
//                     //       color: Color(0xFFF57C03),
//                     //       borderRadius: BorderRadius.circular(8),
//                     //     ),
//                     //     child: TextButton(
//                     //       onPressed: () {
//                     //         if (_formKey.currentState!.validate()) {
//                     //           // ✅ All validations passed
//                     //           Map<String, dynamic> formData = {
//                     //   "tbl_name": widget.tblName,
//                     //   "customer_id": widget.id,
//                     //   "city_id": SelectedId,
//                     //   "taluka_id": selectedTalukaId,
//                     //   "village_id": selectedVillageId,
//                     //   "survey_no": _surveyNoController.text,
//                     //   "name":
//                     //       _ByNameIncasesurveynoisnotknownController.text,
//                     // };

//                     // submitQuickServiceForm(context, formData);
//                     //         } else {
//                     //           // ❌ Validation failed - errors will show up automatically
//                     //           debugPrint("Validation failed. Fix errors.");
//                     //         }
//                     //       },
//                     //       child: Center(
//                     //         child: Text(
//                     //           'Next',
//                     //           style: GoogleFonts.inter(
//                     //             color: Colors.white,
//                     //             fontSize: 18,
//                     //             fontWeight: FontWeight.w500,
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.19),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal:
//                             MediaQuery.of(context).size.width *
//                             0.00, // 5% of screen width
//                         // vertical: 20, // Keeps the top margin as per the design
//                       ), //ect margin
//                       child: Container(
//                         width: double.infinity, // Full width
//                         margin: const EdgeInsets.only(
//                           // top: 10,
//                           // left: 10,
//                           //right: 10,
//                         ), // Adjust positioning
//                         decoration: BoxDecoration(
//                           color: Color(0x40F57C03), // Orange with 25% opacity
//                           borderRadius: BorderRadius.circular(
//                             8,
//                           ), // Rounded corners
//                           border: Border.all(
//                             width: 0.5, // Border width
//                             color: const Color(0xFFFCCACA), // Light red border
//                           ),
//                         ),
//                         padding: const EdgeInsets.fromLTRB(
//                           14,
//                           14,
//                           18,
//                           14,
//                         ), // (left, top, right, bottom)
//                         child: Text(
//                           "Note : After payment document can be downloaded from\norder section only once which you can share.",
//                           style: GoogleFonts.inter(
//                             fontSize: 11, // Small text size
//                             fontWeight: FontWeight.w400,
//                             color: const Color(
//                               0xFF36322E,
//                             ), // Error red text color
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
