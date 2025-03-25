// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/services.dart';
// import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:my_bhulekh_app/api_url/url.dart';
// import 'package:my_bhulekh_app/profile/profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class informationscreen extends StatefulWidget {
//   informationscreen({super.key});

//   @override
//   _informationscreenState createState() => _informationscreenState();
// }

// class _informationscreenState extends State<informationscreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form Key

//   final TextEditingController _customerNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   String? Selectedstate;
//   String? Selectedcity;
//   List<Map<String, dynamic>> stateData = [];
//   List<Map<String, dynamic>> cityData = [];
//   String? Selectedstateid;
//   String? SelectedcityId;
//   bool istoggled = false;
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     _fetchState();
//     // _fetchCity();
//     _loadMobileNumber();
//   }

//   // Load mobile number from SharedPreferences
//   Future<void> _loadMobileNumber() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? mobileNumber = prefs.getString('mobileNumber');
//     if (mobileNumber != null && mobileNumber.isNotEmpty) {
//       setState(() {
//         _mobileController.text = mobileNumber;
//       });
//       log('Loaded Mobile Number: $mobileNumber');
//     } else {
//       log('No Mobile Number found in SharedPreferences');
//     }
//   }

//   void information() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? customerId = prefs.getString('customer_id');
//     var requestBody = {
//       "customer_id": customerId,
//       "customer_name": _customerNameController.text,
//       "mobile_number": _mobileController.text,
//       "email": _emailController.text,
//       "city_id": SelectedcityId ?? '',
//       "state_id": Selectedstateid ?? '',
//     };

//     print('Request Body: ${jsonEncode(requestBody)}');
//     final String url = URLS().update_customer_profile_apiUrl;
//     print('Request URL: $url');

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         body: jsonEncode(requestBody),
//         headers: {'Content-Type': 'application/json'},
//       );

//       print('Response Status Code: ${response.statusCode}');
//       log('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Details submitted successfully!'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ProfilePage(isToggled: istoggled)),
//         );
//         print(" Success Response: $responseData");
//       } else {
//         print(" Error Response: ${response.body}");
//       }
//     } catch (e) {
//       print(" Exception Occurred: $e");
//     }
//   }

//   void _fetchCity(String? selectedStateId) async {
//     var requestBody = {"state_id": selectedStateId};
//     print('Request Body: ${jsonEncode(requestBody)}');

//     final String url = URLS().get_all_city_apiUrl;
//     print('Request URL: $url');

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         body: jsonEncode(requestBody),
//         headers: {'Content-Type': 'application/json'},
//       );

//       print('Response Status Code: ${response.statusCode}');
//       log('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == 'true') {
//           setState(() {
//             cityData = List<Map<String, dynamic>>.from(data['data']);
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

//   Future<void> _fetchState() async {
//     final String url = URLS().get_all_state_apiUrl;
//     print('Request URL: $url');

//     try {
//       var response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//       );

//       print('Response Status Code: ${response.statusCode}');
//       log('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['status'] == 'true') {
//           stateData = List<Map<String, dynamic>>.from(data['data']);

//           // Print full state data
//           print('Full state data: $stateData');

//           String? validStateId;

//           // Find first non-null state_id
//           for (var state in stateData) {
//             print('Fetched State ID: ${state['state_id']}');
//             if (state['state_id'] != null &&
//                 state['state_id'].toString().trim().isNotEmpty) {
//               validStateId = state['state_id'].toString();
//               break;
//             }
//           }

//           if (validStateId != null) {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.setString('state_id', validStateId);
//             print('✅ Saved State ID in SharedPreferences: $validStateId');

//             setState(() {
//               Selectedstateid = validStateId!;
//             });
//           } else {
//             print('⚠ No valid state_id found. Nothing saved.');
//           }
//         } else {
//           print('Failed to load state: ${data['message']}');
//         }
//       } else {
//         print('Failed to load data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
//     return emailRegex.hasMatch(email);
//   }

//   Future<void> _onRefresh() async {
//     setState(() {
//       isLoading = true;
//       Selectedcity = null;
//       _customerNameController.clear();
//       Selectedstate = null;
//       _emailController.clear();
//       _cityController.clear();
//       // _mobileController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => informationscreen()),
//         );
//         return false; // 👈 Prevent default back pop
//       },
//       child: Scaffold(
//         backgroundColor: Color(0xFFFDFDFD),
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFFFFFF),
//           titleSpacing: 0.0,
//           elevation: 0, // Remove default shadow
//           leading: GestureDetector(
//             onTap: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => OtpScreen(mobilenumber: '', otp: null),
//               //   ), // Replace with your screen widget
//               // );
//             },
//             child: Image.asset('assets/eva_arrow-back-fill.png'),
//           ),

//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(1.0), // Height of the bottom border
//             child: Divider(
//               height: 1,
//               thickness: 1,
//               color: Color(0xFFD9D9D9), // Set the border color
//             ),
//           ),
//         ),

//         body: RefreshIndicator(
//           onRefresh: _onRefresh,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Container(
//                 height: 900,
//                 child: Form(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,

//                   key: _formKey, // Assign the form key
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       // SizedBox(height: 10),
//                       Text(
//                         'Please Enter Your Details',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           height:
//                               1.57, // line height of 22px (14px * 1.57 = 22px)
//                           color: Color(0xFF36322E), // Set color to black
//                         ),
//                         textAlign: TextAlign.center, // Centers the text
//                       ),

//                       // Customer Name Field
//                       SizedBox(height: 16),
//                       TextFormField(
//                         controller: _customerNameController,
//                         decoration: InputDecoration(
//                           hintText: 'Name',
//                           hintStyle: TextStyle(
//                             color: Color(0xFF36322E),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),

//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                             borderSide: BorderSide(
//                               color: Color(0xFFD9D9D9),
//                             ), // Set border color
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                             borderSide: BorderSide(
//                               color: Color(0xFFD9D9D9),
//                             ), // Set focused border color
//                           ),
//                         ),
//                         validator:
//                             (value) =>
//                                 (value == null || value.isEmpty)
//                                     ? 'Please enter name'
//                                     : null,
//                       ),
//                       SizedBox(height: 16),

//                       TextFormField(
//                         controller: _mobileController,
//                         decoration: InputDecoration(
//                           hintText: 'Mobile No',
//                           hintStyle: TextStyle(
//                             color: Color(0xFF36322E),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                             borderSide: BorderSide(
//                               color: Color(0xFFD9D9D9),
//                             ), // Set border color
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                             borderSide: BorderSide(
//                               color: Color(0xFFD9D9D9),
//                             ), // Set focused border color
//                           ),
//                         ),
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter mobile number';
//                           }
//                           if (value.length != 10) {
//                             return 'Enter valid 10-digit mobile number';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 16),

//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           hintText: 'E-mail ID',
//                           hintStyle: TextStyle(
//                             color: Color(0xFF36322E),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                             borderSide: BorderSide(
//                               color: Color(0xFFD9D9D9),
//                             ), // Set border color
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               6,
//                             ), // Set border radius
//                             borderSide: BorderSide(
//                               color: Color(0xFFD9D9D9),
//                             ), // Set focused border color
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter email';
//                           }
//                           if (!_isValidEmail(value)) return 'Enter valid email';
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 16),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           border: Border.all(
//                             color: Color(0xFFD9D9D9),
//                             width: 1,
//                           ),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 0),
//                         child: DropdownButtonHideUnderline(
//                           child: SearchableDropdown.single(
//                             items:
//                                 cityData.map((city) {
//                                   return DropdownMenuItem<String>(
//                                     value: city['city_name'],
//                                     child: Text(
//                                       city['city_name'],
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFF36322E),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                             value: Selectedcity,
//                             hint: Text(
//                               'City',
//                               style: TextStyle(
//                                 color: Color(0xFF36322E),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             searchHint: 'Search city...',
//                             onChanged: (newValue) async {
//                               setState(() {
//                                 Selectedcity = newValue;
//                               });

//                               //  Get city ID from selected city name
//                               final selectedCityData = cityData.firstWhere(
//                                 (city) => city['city_name'] == newValue,
//                                 orElse: () => {},
//                               );

//                               SelectedcityId = selectedCityData['id'];

//                               log("Selected city ID: $SelectedcityId");
//                             },
//                             isExpanded: true,
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 16),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           border: Border.all(
//                             color: Color(0xFFD9D9D9),
//                             width: 1,
//                           ),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 0),
//                         child: DropdownButtonHideUnderline(
//                           child: FormField<String>(
//                             validator: (value) {
//                               if (Selectedstate == null ||
//                                   Selectedstate!.isEmpty) {
//                                 return 'Please select a state';
//                               }
//                               return null;
//                             },
//                             builder: (FormFieldState<String> field) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SearchableDropdown.single(
//                                     items:
//                                         stateData.map((state) {
//                                           return DropdownMenuItem<String>(
//                                             value: state['state_name'],
//                                             child: Text(
//                                               state['state_name'],
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Color(0xFF36322E),
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                     value: Selectedstate,
//                                     hint: Text(
//                                       'State',
//                                       style: TextStyle(
//                                         color: Color(0xFF36322E),
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                     searchHint: 'Search state...',
//                                     onChanged: (newValue) async {
//                                       setState(() {
//                                         Selectedstate = newValue;
//                                         Selectedcity = "";
//                                         field.didChange(newValue);
//                                       });

//                                       final selectedStateData = stateData
//                                           .firstWhere(
//                                             (state) =>
//                                                 state['state_name'] == newValue,
//                                             orElse: () => {},
//                                           );

//                                       Selectedstateid =
//                                           selectedStateData['id']?.toString() ??
//                                           '';
//                                       log(
//                                         "Selected state ID: $Selectedstateid",
//                                       );

//                                       SharedPreferences prefs =
//                                           await SharedPreferences.getInstance();
//                                       await prefs.setString(
//                                         'state_id',
//                                         Selectedstateid!,
//                                       );
//                                       log(
//                                         '📦 State ID saved in SharedPreferences: $Selectedstateid',
//                                       );

//                                       _fetchCity(Selectedstateid);
//                                     },
//                                     isExpanded: true,
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 70),

//                       // Submit Button
//                       Padding(
//                         padding: const EdgeInsets.only(top: 110.0),
//                         child: Container(
//                           width: double.infinity, // Full width
//                           height: 50, // Set height
//                           decoration: BoxDecoration(
//                             color: Color(0xFFF57C03), // Orange Background
//                             borderRadius: BorderRadius.circular(
//                               8,
//                             ), // Set border radius
//                           ),
//                           child: TextButton(
//                             onPressed: () {
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (context) => digitally_sign1(),
//                               //   ), // Replace with your screen widget
//                               information();
//                               // );
//                             },

//                             //   if (_formKey.currentState!.validate()) {
//                             //     // Handle form submission
//                             //     setState(() {
//                             //       _isSubmitted = true; // Set submitted to true
//                             //     });
//                             //   }
//                             // },
//                             child: Text(
//                               'Submit',
//                               style: GoogleFonts.inter(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// // import 'dart:convert';
// // import 'dart:developer';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:my_bhulekh_app/api_url/url.dart';
// // import 'package:my_bhulekh_app/profile/profile.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class information extends StatefulWidget {
// //   const information({super.key});

// //   @override
// //   _informationState createState() => _informationState();
// // }

// // class _informationState extends State<information> {
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// //   final TextEditingController _customerNameController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _cityController = TextEditingController();
// //   final TextEditingController _mobileController = TextEditingController();

// //   String? Selectedstate;
// //   String? Selectedcity;
// //   List<Map<String, dynamic>> stateData = [];
// //   List<Map<String, dynamic>> cityData = [];
// //   String? Selectedstateid;
// //   String? SelectedcityId;
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchState();
// //     _loadMobileNumber(); // Load mobile number from SharedPreferences
// //   }

//   // // Load mobile number from SharedPreferences
//   // Future<void> _loadMobileNumber() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? mobileNumber = prefs.getString('mobileNumber');
//   //   if (mobileNumber != null && mobileNumber.isNotEmpty) {
//   //     setState(() {
//   //       _mobileController.text = mobileNumber;
//   //     });
//   //     log('Loaded Mobile Number: $mobileNumber');
//   //   } else {
//   //     log('No Mobile Number found in SharedPreferences');
//   //   }
//   // }

// //   void informations() async {
// //     if (!_formKey.currentState!.validate()) {
// //       return; // Stop if form validation fails
// //     }

// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     final String? customerId = prefs.getString('customer_id');

// //     var requestBody = {
// //       "customer_id": customerId,
// //       "customer_name": _customerNameController.text.trim(),
// //       "mobile_number": _mobileController.text.trim(),
// //       "email": _emailController.text.trim(),
// //       "city_id": SelectedcityId ?? '',
// //       "state_id": Selectedstateid ?? '',
// //     };

// //     print('Request Body: ${jsonEncode(requestBody)}');
// //     final String url = URLS().update_customer_profile_apiUrl;
// //     print('Request URL: $url');

// //     try {
// //       var response = await http.post(
// //         Uri.parse(url),
// //         body: jsonEncode(requestBody),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       print('Response Status Code: ${response.statusCode}');
// //       log('Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final responseData = jsonDecode(response.body);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Details submitted successfully!'),
// //             backgroundColor: Colors.green,
// //             duration: Duration(seconds: 2),
// //           ),
// //         );

// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => ProfilePage()),
// //         );
// //         print("Success Response: $responseData");
// //       } else {
// //         print("Error Response: ${response.body}");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Failed to submit details. Please try again.'),
// //             backgroundColor: Colors.red,
// //             duration: Duration(seconds: 2),
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       print("Exception Occurred: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Something went wrong. Please try again.'),
// //           backgroundColor: Colors.red,
// //           duration: Duration(seconds: 2),
// //         ),
// //       );
// //     }
// //   }

// //   void _fetchCity(String? selectedStateId) async {
// //     var requestBody = {"state_id": selectedStateId};
// //     print('Request Body: ${jsonEncode(requestBody)}');

// //     final String url = URLS().get_all_city_apiUrl;
// //     print('Request URL: $url');

// //     try {
// //       var response = await http.post(
// //         Uri.parse(url),
// //         body: jsonEncode(requestBody),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       print('Response Status Code: ${response.statusCode}');
// //       log('Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['status'] == 'true') {
// //           setState(() {
// //             cityData = List<Map<String, dynamic>>.from(data['data']);
// //           });
// //           log('Fetched City Data: ${data['data']}');
// //         } else {
// //           print('Failed to load city: ${data['message']}');
// //         }
// //       } else {
// //         print('Failed to load data. Status code: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('Error: $e');
// //     }
// //   }

// //   Future<void> _fetchState() async {
// //     final String url = URLS().get_all_state_apiUrl;
// //     print('Request URL: $url');

// //     try {
// //       var response = await http.post(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       print('Response Status Code: ${response.statusCode}');
// //       log('Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);

// //         if (data['status'] == 'true') {
// //           stateData = List<Map<String, dynamic>>.from(data['data']);

// //           // Print full state data
// //           print('Full state data: $stateData');

// //           String? validStateId;

// //           // Find first non-null state_id
// //           for (var state in stateData) {
// //             print('Fetched State ID: ${state['state_id']}');
// //             if (state['state_id'] != null &&
// //                 state['state_id'].toString().trim().isNotEmpty) {
// //               validStateId = state['state_id'].toString();
// //               break;
// //             }
// //           }

// //           if (validStateId != null) {
// //             SharedPreferences prefs = await SharedPreferences.getInstance();
// //             await prefs.setString('state_id', validStateId);
// //             print('✅ Saved State ID in SharedPreferences: $validStateId');

// //             setState(() {
// //               Selectedstateid = validStateId!;
// //             });
// //           } else {
// //             print('⚠ No valid state_id found. Nothing saved.');
// //           }
// //         } else {
// //           print('Failed to load state: ${data['message']}');
// //         }
// //       } else {
// //         print('Failed to load data. Status code: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('Error: $e');
// //     }
// //   }

// //   bool _isValidEmail(String email) {
// //     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
// //     return emailRegex.hasMatch(email);
// //   }

// //   Future<void> _onRefresh() async {
// //     setState(() {
// //       isLoading = true;
// //       Selectedcity = null;
// //       _customerNameController.clear();
// //       Selectedstate = null;
// //       _emailController.clear();
// //       _cityController.clear();
// //       _mobileController.clear();
// //     });
// //     await _fetchState();
// //     await _loadMobileNumber();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => const information()),
// //         );
// //         return false;
// //       },
// //       child: Scaffold(
// //         backgroundColor: const Color(0xFFFDFDFD),
// //         appBar: AppBar(
// //           backgroundColor: const Color(0xFFFFFFFF),
// //           titleSpacing: 0.0,
// //           elevation: 0,
// //           leading: GestureDetector(
// //             onTap: () {
// //               // Optionally navigate back to OTP screen or elsewhere
// //             },
// //             child: Image.asset('assets/eva_arrow-back-fill.png'),
// //           ),
// //           bottom: const PreferredSize(
// //             preferredSize: Size.fromHeight(1.0),
// //             child: Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),
// //           ),
// //         ),
// //         body: RefreshIndicator(
// //           onRefresh: _onRefresh,
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: SingleChildScrollView(
// //               child: Container(
// //                 height: 900,
// //                 child: Form(
// //                   autovalidateMode: AutovalidateMode.onUserInteraction,
// //                   key: _formKey,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: <Widget>[
// //                       Text(
// //                         'Please Enter Your Details',
// //                         style: GoogleFonts.poppins(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.w500,
// //                           height: 1.57,
// //                           color: const Color(0xFF36322E),
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         controller: _customerNameController,
// //                         decoration: InputDecoration(
// //                           hintText: 'Name',
// //                           hintStyle: const TextStyle(
// //                             color: Color(0xFF36322E),
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w400,
// //                           ),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                           ),
// //                           enabledBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFFD9D9D9),
// //                             ),
// //                           ),
// //                           focusedBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFFD9D9D9),
// //                             ),
// //                           ),
// //                         ),
// //                         validator:
// //                             (value) =>
// //                                 (value == null || value.trim().isEmpty)
// //                                     ? 'Please enter name'
// //                                     : null,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         controller: _mobileController,
// //                         decoration: InputDecoration(
// //                           hintText: 'Mobile No',
// //                           hintStyle: const TextStyle(
// //                             color: Color(0xFF36322E),
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w400,
// //                           ),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                           ),
// //                           enabledBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFFD9D9D9),
// //                             ),
// //                           ),
// //                           focusedBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFFD9D9D9),
// //                             ),
// //                           ),
// //                         ),
// //                         keyboardType: TextInputType.phone,
// //                         inputFormatters: [
// //                           FilteringTextInputFormatter.digitsOnly,
// //                           LengthLimitingTextInputFormatter(10),
// //                         ],
// //                         validator: (value) {
// //                           if (value == null || value.trim().isEmpty) {
// //                             return 'Please enter mobile number';
// //                           }
// //                           if (value.length != 10) {
// //                             return 'Enter valid 10-digit mobile number';
// //                           }
// //                           return null;
// //                         },
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         controller: _emailController,
// //                         decoration: InputDecoration(
// //                           hintText: 'E-mail ID',
// //                           hintStyle: const TextStyle(
// //                             color: Color(0xFF36322E),
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w400,
// //                           ),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                           ),
// //                           enabledBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFFD9D9D9),
// //                             ),
// //                           ),
// //                           focusedBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(6),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFFD9D9D9),
// //                             ),
// //                           ),
// //                         ),
// //                         validator: (value) {
// //                           if (value == null || value.trim().isEmpty) {
// //                             return 'Please enter email';
// //                           }
// //                           if (!_isValidEmail(value)) return 'Enter valid email';
// //                           return null;
// //                         },
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Container(
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(6),
// //                           border: Border.all(
// //                             color: const Color(0xFFD9D9D9),
// //                             width: 1,
// //                           ),
// //                         ),
// //                         padding: const EdgeInsets.symmetric(horizontal: 0),
// //                         child: DropdownButtonHideUnderline(
// //                           child: SearchableDropdown.single(
// //                             items:
// //                                 cityData.map((city) {
// //                                   return DropdownMenuItem<String>(
// //                                     value: city['city_name'],
// //                                     child: Text(
// //                                       city['city_name'],
// //                                       style: const TextStyle(
// //                                         fontSize: 16,
// //                                         fontWeight: FontWeight.w500,
// //                                         color: Color(0xFF36322E),
// //                                       ),
// //                                     ),
// //                                   );
// //                                 }).toList(),
// //                             value: Selectedcity,
// //                             hint: const Text(
// //                               'City',
// //                               style: TextStyle(
// //                                 color: Color(0xFF36322E),
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.w400,
// //                               ),
// //                             ),
// //                             searchHint: 'Search city...',
// //                             onChanged: (newValue) {
// //                               setState(() {
// //                                 Selectedcity = newValue;
// //                                 final selectedCityData = cityData.firstWhere(
// //                                   (city) => city['city_name'] == newValue,
// //                                   orElse: () => {},
// //                                 );
// //                                 SelectedcityId =
// //                                     selectedCityData['id']?.toString();
// //                                 log("Selected city ID: $SelectedcityId");
// //                               });
// //                             },
// //                             isExpanded: true,
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Container(
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(6),
// //                           border: Border.all(
// //                             color: const Color(0xFFD9D9D9),
// //                             width: 1,
// //                           ),
// //                         ),
// //                         padding: const EdgeInsets.symmetric(horizontal: 0),
// //                         child: DropdownButtonHideUnderline(
// //                           child: FormField<String>(
// //                             validator:
// //                                 (value) =>
// //                                     (Selectedstate == null ||
// //                                             Selectedstate!.isEmpty)
// //                                         ? 'Please select a state'
// //                                         : null,
// //                             builder: (FormFieldState<String> field) {
// //                               return SearchableDropdown.single(
// //                                 items:
// //                                     stateData.map((state) {
// //                                       return DropdownMenuItem<String>(
// //                                         value: state['state_name'],
// //                                         child: Text(
// //                                           state['state_name'],
// //                                           style: const TextStyle(
// //                                             fontSize: 16,
// //                                             fontWeight: FontWeight.w500,
// //                                             color: Color(0xFF36322E),
// //                                           ),
// //                                         ),
// //                                       );
// //                                     }).toList(),
// //                                 value: Selectedstate,
// //                                 hint: const Text(
// //                                   'State',
// //                                   style: TextStyle(
// //                                     color: Color(0xFF36322E),
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.w400,
// //                                   ),
// //                                 ),
// //                                 searchHint: 'Search state...',
// //                                 onChanged: (newValue) async {
// //                                   setState(() {
// //                                     Selectedstate = newValue;
// //                                     Selectedcity =
// //                                         null; // Reset city when state changes
// //                                     field.didChange(newValue);
// //                                   });
// //                                   final selectedStateData = stateData
// //                                       .firstWhere(
// //                                         (state) =>
// //                                             state['state_name'] == newValue,
// //                                         orElse: () => {},
// //                                       );
// //                                   Selectedstateid =
// //                                       selectedStateData['state_id']?.toString();
// //                                   log("Selected state ID: $Selectedstateid");
// //                                   if (Selectedstateid != null) {
// //                                     _fetchCity(Selectedstateid);
// //                                   }
// //                                 },
// //                                 isExpanded: true,
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 70),
// //                       Padding(
// //                         padding: const EdgeInsets.only(top: 110.0),
// //                         child: Container(
// //                           width: double.infinity,
// //                           height: 50,
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFFF57C03),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: TextButton(
// //                             onPressed: informations,
// //                             child: const Text(
// //                               'Submit',
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.w500,
// //                                 fontFamily: 'Inter',
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_bhulekh_app/api_url/url.dart';
import 'package:my_bhulekh_app/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class informationscreen extends StatefulWidget {
  const informationscreen({super.key});

  @override
  _informationscreenState createState() => _informationscreenState();
}

class _informationscreenState extends State<informationscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String? Selectedstate;
  String? Selectedcity;
  List<Map<String, dynamic>> stateData = [];
  List<Map<String, dynamic>> cityData = [];
  String? Selectedstateid;
  String? SelectedcityId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchState();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString('mobileNumber');
    if (mobileNumber != null && mobileNumber.isNotEmpty) {
      setState(() {
        _mobileController.text = mobileNumber;
      });
      log('Loaded Mobile Number: $mobileNumber');
    } else {
      log('No Mobile Number found in SharedPreferences');
    }
  }

  void information() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form validation fails
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? customerId = prefs.getString('customer_id');
    var requestBody = {
      "customer_id": customerId,
      "customer_name": _customerNameController.text,
      "mobile_number": _mobileController.text,
      "email": _emailController.text,
      "city_id": SelectedcityId ?? '',
      "state_id": Selectedstateid ?? '',
    };

    print('Request Body: ${jsonEncode(requestBody)}');
    final String url = URLS().update_customer_profile_apiUrl;
    print('Request URL: $url');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'true') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Details submitted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(isToggled: false),
            ),
          );
          print("Success Response: $responseData");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update profile: ${responseData['message']}',
              ),
              backgroundColor: Colors.red,
            ),
          );
          print("Error Response: ${response.body}");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Server error. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
        print("Error Response: ${response.body}");
      }
    } catch (e) {
      print("Exception Occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _fetchCity(String? selectedStateId) async {
    var requestBody = {"state_id": selectedStateId};
    print('Request Body: ${jsonEncode(requestBody)}');

    final String url = URLS().get_all_city_apiUrl;
    print('Request URL: $url');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('Response Status Code: ${response.statusCode}');
        log('Response Body: ${response.body}');
        if (data['status'] == 'true') {
          setState(() {
            cityData = List<Map<String, dynamic>>.from(data['data']);
            isLoading = false;
          });
          log('Fetched City Data: ${data['data']}');
        } else {
          print('Failed to load city: ${data['message']}');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchState() async {
    final String url = URLS().get_all_state_apiUrl;
    print('Request URL: $url');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'true') {
          setState(() {
            stateData = List<Map<String, dynamic>>.from(data['data']);
            isLoading = false;
          });
          // No automatic state selection or saving here
        } else {
          print('Failed to load state: ${data['message']}');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
      Selectedcity = null;
      _customerNameController.clear();
      Selectedstate = null;
      _emailController.clear();
      _cityController.clear();
    });
    await _fetchState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const informationscreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          titleSpacing: 0.0,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/eva_arrow-back-fill.png'),
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
              child: SizedBox(
                height: 900,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Please Enter Your Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.57,
                          color: Color(0xFF36322E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _customerNameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
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
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter name'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          hintText: 'Mobile No',
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
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.length != 10) {
                            return 'Enter valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'E-mail ID',
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
                        textCapitalization: TextCapitalization.none,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(
                            r'^[\w\.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField<String>(
                        validator:
                            (value) =>
                                (Selectedcity == null ||
                                        Selectedcity!.trim().isEmpty)
                                    ? 'Please select a District'
                                    : null,
                        builder: (FormFieldState<String> state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownSearch<String>(
                                items:
                                    cityData
                                        .map<String>(
                                          (item) =>
                                              item['city_name'].toString(),
                                        )
                                        .toList(),
                                selectedItem: Selectedcity,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: 'District',
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
                                  searchFieldProps: const TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: 'Search District...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    Selectedcity = newValue;
                                    final selectedCityData = cityData
                                        .firstWhere(
                                          (city) =>
                                              city['city_name'] == newValue,
                                          orElse: () => {},
                                        );
                                    SelectedcityId =
                                        selectedCityData.isNotEmpty
                                            ? selectedCityData['id']?.toString()
                                            : null;
                                    log("Selected city ID: $SelectedcityId");
                                    state.didChange(newValue);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField<String>(
                        validator:
                            (value) =>
                                (Selectedstate == null ||
                                        Selectedstate!.trim().isEmpty)
                                    ? 'Please select a state'
                                    : null,
                        builder: (FormFieldState<String> state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownSearch<String>(
                                items:
                                    stateData
                                        .map<String>(
                                          (item) =>
                                              item['state_name'].toString(),
                                        )
                                        .toList(),
                                selectedItem: Selectedstate,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: 'State',
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
                                  searchFieldProps: const TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: 'Search State...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                onChanged: (value) async {
                                  setState(() {
                                    Selectedstate = value;
                                    Selectedcity =
                                        null; // Reset city when state changes
                                    state.didChange(value);
                                  });
                                  final matchedState = stateData.firstWhere(
                                    (item) => item['state_name'] == value,
                                    orElse: () => {},
                                  );
                                  Selectedstateid =
                                      matchedState.isNotEmpty
                                          ? matchedState['id']?.toString()
                                          : '';
                                  log("Selected state ID: $Selectedstateid");
                                  _fetchCity(Selectedstateid);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.only(top: 110.0),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF57C03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: information,
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
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
      ),
    );
  }
}
