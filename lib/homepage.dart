// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:my_bhulekh_app/api_url/url.dart';
// import 'package:my_bhulekh_app/investigate_reports_form/mortage_report.dart';
// import 'package:my_bhulekh_app/investigate_reports_form/registered_document.dart';
// import 'package:my_bhulekh_app/investigate_reports_form/rera%20builder.dart';
// import 'package:my_bhulekh_app/legal_advisory_forms/adhikar_abhilekh.dart';
// import 'package:my_bhulekh_app/legal_advisory_forms/courtcases.dart';
// import 'package:my_bhulekh_app/legal_advisory_forms/investigate.dart';
// import 'package:my_bhulekh_app/legal_advisory_forms/legaldrafts.dart';
// import 'package:my_bhulekh_app/old_records_form/old%20extract1.dart';
// import 'package:my_bhulekh_app/profile/profile.dart';
// import 'package:my_bhulekh_app/quicke_services_forms/digitally_sign1.dart';
// import 'package:my_bhulekh_app/quicke_services_forms/digitally_sign_property_card.dart';
// import 'package:my_bhulekh_app/quicke_services_forms/indexII_search.dart';
// import 'package:my_bhulekh_app/quicke_services_forms/rera_certificate.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'colors/custom_color.dart';

// class HomePage2 extends StatefulWidget {
//   const HomePage2({Key? key}) : super(key: key);

//   @override
//   State<HomePage2> createState() => _HomePage2State();
// }

// class _HomePage2State extends State<HomePage2> {
//   List<dynamic> categoryList = [];
//   String iconPath = '';
//   String customerName = '';
//   bool isLoading = true;
//   List<dynamic> customerList = [];
//   bool isToggled = false;
//   String? selectedState;
//   int _selectedIndex = 0;

//   final Map<String, String> instantTextMap = {
//     'Quick Services': 'instant',
//     'Old Records of Rights': 'within12Hours',
//     'Legal Advisory': 'within12Hours',
//     'Investigative Reports': 'within24Hours',
//     'E-Applications': 'within12Hours',
//   };

//   final List<Map<String, dynamic>> packages = [
//     {
//       "offerName": "Home Loan/Loan Against Property",
//       "description": "Lorem Ipsum has been the store standard dummy text",
//       "iconPath": "assets/images/package1.png",
//       "services": ["Consultation", "Processing", "Approval"],
//     },
//     {
//       "offerName": "Agriculture Loan",
//       "description": "Lorem Ipsum has been the store standard dummy text",
//       "iconPath": "assets/images/package2.png",
//       "services": ["Loan Assistance", "Guidance", "Subsidy Support"],
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//     _loadToggleState(); // Load initial toggle state
//   }

//   Future<void> fetchCategories() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? customerId = prefs.getString('customer_id');
//     var requestBody = {"customer_id": customerId};

//     final String url = URLS().get_all_category_apiUrl;
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json; charset=UTF-8'},
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         setState(() {
//           categoryList = responseData['data'] ?? [];
//           iconPath = responseData['icon_path'] ?? '';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("❌ Error: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> _onRefresh() async {
//     await fetchCategories();
//   }

//   Future<void> _loadToggleState() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isToggled = prefs.getBool('isToggled') ?? false;
//     });
//   }

//   Future<void> _saveToggleState(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isToggled', value);
//   }
//   // Future<void> _saveToggleState(bool value) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.setBool('isToggled', value);
//   // }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         print("Home tapped");
//         break;
//       case 1:
//         print("Customer Care tapped");
//         break;
//       case 2:
//         print("My Order tapped");
//         break;
//       case 3:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProfilePage(isToggled: isToggled),
//           ),
//         ).then((_) {
//           _loadToggleState(); // Reload state when returning from ProfilePage
//         });
//         break;
//     }
//   }

//   Future<bool> _showExitDialog(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           builder:
//               (context) => AlertDialog(
//                 title: const Text(
//                   'Unsaved Data Will Be Lost',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 content: const Text(
//                   'Are you sure you want to exit?',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, false),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => SystemNavigator.pop(),
//                     child: const Text(
//                       'Yes',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//         ) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => await _showExitDialog(context),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8F8F8),
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colorfile.body,
//           title: Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Image.asset('assets/images/bhulex.png', height: 40),
//           ),
//           shape: Border(
//             bottom: BorderSide(color: Colorfile.border, width: 1.0),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Row(
//                 children: [
//                   Container(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         CupertinoSwitch(
//                           value: isToggled,
//                           onChanged: (bool newValue) {
//                             setState(() {
//                               isToggled = newValue;
//                               _saveToggleState(newValue); // Save when toggled
//                             });
//                           },
//                           activeColor: Colorfile.bordertheme,
//                         ),
//                         if (!isToggled)
//                           const Positioned(
//                             right: 10,
//                             child: Text(
//                               'अ',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colorfile.lightblack,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.search,
//                   size: 30,
//                   color: Colorfile.lightblack,
//                 ),
//                 onPressed: () {
//                   print('Search icon pressed');
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: RefreshIndicator(
//           onRefresh: _onRefresh,
//           child:
//               isLoading
//                   ? ListView.builder(
//                     itemCount: 10,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Shimmer.fromColors(
//                           baseColor: Colors.grey.shade300,
//                           highlightColor: Colors.grey.shade100,
//                           child: Container(height: 150, color: Colors.white),
//                         ),
//                       );
//                     },
//                   )
//                   : SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ...categoryList.map((category) {
//                           var services = category['service'] ?? [];
//                           return Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       category['category_name'] ?? '',
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     Text(
//                                       instantTextMap[category['category_name']] ??
//                                           '',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colorfile.lightgrey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 GridView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: services.length,
//                                   gridDelegate:
//                                       const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 4,
//                                         crossAxisSpacing: 10,
//                                         mainAxisSpacing: 10,
//                                         childAspectRatio: 1.4,
//                                       ),
//                                   itemBuilder: (context, serviceIndex) {
//                                     var service = services[serviceIndex];
//                                     String serviceIcon =
//                                         service['icon'] != null
//                                             ? iconPath + service['icon']
//                                             : '';
//                                     String displayName =
//                                         isToggled
//                                             ? (service['service_name_in_local_language'] ??
//                                                 service['service_name'] ??
//                                                 '')
//                                             : (service['service_name'] ?? '');

//                                     String displayTalukaName =
//                                         isToggled
//                                             ? (service['taluka_name_in_local_language'] ??
//                                                 service['taluka_name'] ??
//                                                 '')
//                                             : (service['taluka_name'] ?? '');

//                                     String displayVillageName =
//                                         isToggled
//                                             ? (service['village_name_in_local_language'] ??
//                                                 service['village_name'] ??
//                                                 '')
//                                             : (service['village_name'] ?? '');

//                                     String displaycourtName =
//                                         isToggled
//                                             ? (service['court_name_in_local_language'] ??
//                                                 service['court_name'] ??
//                                                 '')
//                                             : (service['court_name'] ?? '');
//                                     String displayregionName =
//                                         isToggled
//                                             ? (service['region_in_local_language'] ??
//                                                 service['region_name'] ??
//                                                 '')
//                                             : (service['region_name'] ?? '');
//                                     String displaySROofficeName =
//                                         isToggled
//                                             ? (service['sro_office_name_in_local_language'] ??
//                                                 service['sro_office_name'] ??
//                                                 '')
//                                             : (service['sro_office_name'] ??
//                                                 '');

//                                     return InkWell(
//                                       onTap: () {
//                                         var selectedService =
//                                             services[serviceIndex];
//                                         final id =
//                                             selectedService['id'].toString();
//                                         final serviceName =
//                                             selectedService['service_name'] ??
//                                             '';
//                                         final tblName =
//                                             selectedService['tbl_name'] ?? '';

//                                         if ([
//                                           "tbl_seven_twelve",
//                                           "tbl_eighta_extract",
//                                           "tbl_e_mutation_extract",
//                                           "tbl_bhu_naksha",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => DigitallySign1(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled: isToggled,
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else if ([
//                                           "tbl_index_second_search",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => IndexSearch1(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                           // In HomePage2.dart, inside the InkWell onTap
//                                         } else if ([
//                                           "tbl_rera_certificate",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => ReraCertificate(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else if ([
//                                           "tbl_property_card",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => propertyCard(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Fixed: Added required parameter
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName, // Fixed: Added required parameter
//                                                   ),
//                                             ),
//                                           );
//                                         } else if ([
//                                           "tbl_old_seven_twelve",
//                                           "tbl_old_eighta_extract",
//                                           "tbl_old_e_mutation_extract",
//                                           "tbl_old_bhu_naksha",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => oldextract1(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled: isToggled,
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else if ([
//                                           "tbl_mortage_report",
//                                           "tbl_ceersai_report",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => MortgageReports(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else if ([
//                                           "tbl_rera_builder_documents",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => RERA_Builder(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else if ([
//                                           "tbl_registered_document",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (
//                                                     context,
//                                                   ) => RegisteredDocument(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                           // In HomePage2.dart, inside the InkWell onTap
//                                         } else if ([
//                                           "tbl_title_investigation_report",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => Investigation(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else if ([
//                                           "tbl_legal_drafts",
//                                         ].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => Legaldrafts(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                           //
//                                         } else if (["tbl_court_cases"].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => Courtcases(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else if (["tbl_adhikar_abhilekh"].contains(tblName)) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder:
//                                                   (context) => Adhikar_Abhilekh(
//                                                     id: id,
//                                                     serviceName: serviceName,
//                                                     tblName: tblName,
//                                                     isToggled:
//                                                         isToggled, // Pass the toggle state
//                                                     serviceNameInLocalLanguage:
//                                                         selectedService['service_name_in_local_language'] ??
//                                                         serviceName,
//                                                   ),
//                                             ),
//                                           );
//                                         } else {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             const SnackBar(
//                                               content: Text(
//                                                 "Service not available for this selection.",
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                       },
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           serviceIcon.isNotEmpty
//                                               ? Image.network(
//                                                 serviceIcon,
//                                                 height: 25,
//                                                 width: 25,
//                                                 fit: BoxFit.contain,
//                                                 errorBuilder:
//                                                     (ctx, _, __) => const Icon(
//                                                       Icons.broken_image,
//                                                       size: 25,
//                                                     ),
//                                               )
//                                               : const Icon(
//                                                 Icons.miscellaneous_services,
//                                                 size: 30,
//                                               ),
//                                           const SizedBox(height: 5),
//                                           Text(
//                                             displayName,
//                                             style: GoogleFonts.poppins(
//                                               fontSize: 9,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colorfile.lightblack,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 18,
//                           ),
//                           child: Text(
//                             'Packages',
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colorfile.lightblack,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             left: 15.0,
//                             right: 20,
//                             bottom: 10,
//                           ),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: List.generate(packages.length, (index) {
//                                 final offer = packages[index];
//                                 return Padding(
//                                   padding: const EdgeInsets.only(right: 12.0),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       print("Tapped on: ${offer['offerName']}");
//                                     },
//                                     child: Container(
//                                       width: 200,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         border: Border.all(
//                                           color: const Color(0xFFDFE6F8),
//                                           width: 0.5,
//                                         ),
//                                         color: Colors.white,
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Image.asset(
//                                               offer['iconPath'] ??
//                                                   'images/package1.png',
//                                               width: 40,
//                                               height: 40,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(
//                                               offer['offerName'] ??
//                                                   'No Offer Name',
//                                               style: const TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Color(0xFF353B43),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 1),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0,
//                                             ),
//                                             child: Text(
//                                               offer['description'] ??
//                                                   'No Description',
//                                               style: const TextStyle(
//                                                 fontSize: 8,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: Color(0xFF4B5563),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 5),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Wrap(
//                                               spacing: 5,
//                                               runSpacing: 5,
//                                               children:
//                                                   (offer['services']
//                                                           as List<String>?)
//                                                       ?.map((service) {
//                                                         return Container(
//                                                           padding:
//                                                               const EdgeInsets.symmetric(
//                                                                 horizontal: 8,
//                                                                 vertical: 4,
//                                                               ),
//                                                           decoration: BoxDecoration(
//                                                             color: const Color(
//                                                               0xFFF5F4F1,
//                                                             ),
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   5,
//                                                                 ),
//                                                             border: Border.all(
//                                                               color:
//                                                                   const Color(
//                                                                     0xFFE5E7EB,
//                                                                   ),
//                                                             ),
//                                                           ),
//                                                           child: Text(
//                                                             service,
//                                                             style:
//                                                                 const TextStyle(
//                                                                   fontSize: 7,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400,
//                                                                   color: Color(
//                                                                     0xFF757575,
//                                                                   ),
//                                                                 ),
//                                                           ),
//                                                         );
//                                                       })
//                                                       .toList() ??
//                                                   [],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//         ),
//         bottomNavigationBar: Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFFFFFFFF),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0x14000000),
//                 offset: Offset(2, 0),
//                 blurRadius: 25,
//                 spreadRadius: 0,
//               ),
//             ],
//           ),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             items: [
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.home),
//                 label: BottomNavigationStrings.getString(
//                   'home',
//                   isToggled,
//                 ), // Localized
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.support_agent_outlined),
//                 label: BottomNavigationStrings.getString(
//                   'customerCare',
//                   isToggled,
//                 ), // Localized
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.edit_document),
//                 label: BottomNavigationStrings.getString(
//                   'myOrder',
//                   isToggled,
//                 ), // Localized
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.person),
//                 label: BottomNavigationStrings.getString(
//                   'myProfile',
//                   isToggled,
//                 ), // Localized
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: Colorfile.bordertheme,
//             unselectedItemColor: Colorfile.lightgrey,
//             onTap: _onItemTapped,
//             showUnselectedLabels: true,
//             showSelectedLabels: true,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // lib/language/bottom_navigation_strings.dart
// class BottomNavigationStrings {
//   static String getString(String key, bool isToggled) {
//     final Map<String, Map<String, String>> strings = {
//       'home': {
//         'en': 'Home',
//         'local': 'होम', // Marathi example
//       },
//       'customerCare': {'en': 'Customer Care', 'local': 'ग्राहक सेवा'},
//       'myOrder': {'en': 'My Order', 'local': 'माझी ऑर्डर'},
//       'myProfile': {'en': 'My Profile', 'local': 'माझे प्रोफाइल'},
//       'packages': {'en': 'Packages', 'local': 'पॅकेजेस'},
//     };

//     final language = isToggled ? 'local' : 'en';
//     return strings[key]?[language] ??
//         key; // Fallback to key if string not found
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_bhulekh_app/api_url/url.dart';
import 'package:my_bhulekh_app/investigate_reports_form/mortage_report.dart';
import 'package:my_bhulekh_app/investigate_reports_form/registered_document.dart';
import 'package:my_bhulekh_app/investigate_reports_form/rera%20builder.dart';
import 'package:my_bhulekh_app/language/hindi.dart';
import 'package:my_bhulekh_app/legal_advisory_forms/adhikar_abhilekh.dart';
import 'package:my_bhulekh_app/legal_advisory_forms/courtcases.dart';
import 'package:my_bhulekh_app/legal_advisory_forms/investigate.dart';
import 'package:my_bhulekh_app/legal_advisory_forms/legaldrafts.dart';
import 'package:my_bhulekh_app/old_records_form/old%20extract1.dart';
import 'package:my_bhulekh_app/profile/profile.dart';
import 'package:my_bhulekh_app/quicke_services_forms/digitally_sign1.dart';
import 'package:my_bhulekh_app/quicke_services_forms/digitally_sign_property_card.dart';
import 'package:my_bhulekh_app/quicke_services_forms/indexII_search.dart';
import 'package:my_bhulekh_app/quicke_services_forms/rera_certificate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'colors/custom_color.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<dynamic> categoryList = [];
  String iconPath = '';
  String customerName = '';
  bool isLoading = true;
  List<dynamic> customerList = [];
  bool isToggled = false;
  String? selectedState;
  int _selectedIndex = 0;

  final Map<String, String> instantTextMap = {
    'Quick Services': 'instant',
    'Old Records of Rights': 'within12Hours',
    'Legal Advisory': 'within12Hours',
    'Investigative Reports': 'within24Hours',
    'E-Applications': 'within12Hours',
  };

  final List<Map<String, dynamic>> packages = [
    {
      "offerName": "Home Loan/Loan Against Property",
      "description": "Lorem Ipsum has been the store standard dummy text",
      "iconPath": "assets/images/package1.png",
      "services": ["Consultation", "Processing", "Approval"],
    },
    {
      "offerName": "Agriculture Loan",
      "description": "Lorem Ipsum has been the store standard dummy text",
      "iconPath": "assets/images/package2.png",
      "services": ["Loan Assistance", "Guidance", "Subsidy Support"],
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _loadToggleState();
  }

  Future<void> fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? customerId = prefs.getString('customer_id');
    var requestBody = {"customer_id": customerId};

    final String url = URLS().get_all_category_apiUrl;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          categoryList = responseData['data'] ?? [];
          iconPath = responseData['icon_path'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _onRefresh() async {
    await fetchCategories();
  }

  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggled = prefs.getBool('isToggled') ?? false;
    });
  }

  Future<void> _saveToggleState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isToggled', value);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        print("Home tapped");
        break;
      case 1:
        print("Customer Care tapped");
        break;
      case 2:
        print("My Order tapped");
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(isToggled: isToggled),
          ),
        ).then((_) {
          _loadToggleState(); // Reload state when returning from ProfilePage
        });
        break;
    }
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text(
                  'Unsaved Data Will Be Lost',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                content: const Text(
                  'Are you sure you want to exit?',
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _showExitDialog(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colorfile.body,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset('assets/images/bhulex.png', height: 40),
          ),
          shape: Border(
            bottom: BorderSide(color: Colorfile.border, width: 1.0),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Row(
                children: [
                  Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CupertinoSwitch(
                          value: isToggled,
                          onChanged: (bool newValue) {
                            setState(() {
                              isToggled = newValue;
                              _saveToggleState(newValue); // Save when toggled
                            });
                          },
                          activeColor: Colorfile.bordertheme,
                        ),
                        if (!isToggled)
                          const Positioned(
                            right: 10,
                            child: Text(
                              'अ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colorfile.lightblack,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colorfile.lightblack,
                ),
                onPressed: () {
                  print('Search icon pressed');
                },
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child:
              isLoading
                  ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(height: 150, color: Colors.white),
                        ),
                      );
                    },
                  )
                  : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...categoryList.map((category) {
                          var services = category['service'] ?? [];
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isToggled
                                          ? (category['category_name_in_local_language'] ??
                                              category['category_name'] ??
                                              '')
                                          : (category['category_name'] ?? ''),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      LocalizationStringsinstant.getString(
                                        instantTextMap[category['category_name']] ??
                                            '',
                                        isToggled,
                                      ),
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colorfile.lightgrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: services.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 1.4,
                                      ),
                                  itemBuilder: (context, serviceIndex) {
                                    var service = services[serviceIndex];
                                    String serviceIcon =
                                        service['icon'] != null
                                            ? iconPath + service['icon']
                                            : '';
                                    String displayName =
                                        isToggled
                                            ? (service['service_name_in_local_language'] ??
                                                service['service_name'] ??
                                                '')
                                            : (service['service_name'] ?? '');
                                    return InkWell(
                                      onTap: () {
                                        var selectedService =
                                            services[serviceIndex];
                                        final id =
                                            selectedService['id'].toString();
                                        final serviceName =
                                            selectedService['service_name'] ??
                                            '';
                                        final tblName =
                                            selectedService['tbl_name'] ?? '';
                                        if ([
                                          "tbl_seven_twelve",
                                          "tbl_eighta_extract",
                                          "tbl_e_mutation_extract",
                                          "tbl_bhu_naksha",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => DigitallySign1(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_index_second_search",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => IndexSearch1(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_rera_certificate",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ReraCertificate(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_property_card",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => propertyCard(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_old_seven_twelve",
                                          "tbl_old_eighta_extract",
                                          "tbl_old_e_mutation_extract",
                                          "tbl_old_bhu_naksha",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => oldextract1(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_mortage_report",
                                          "tbl_ceersai_report",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => MortgageReports(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_rera_builder_documents",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => RERA_Builder(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_registered_document",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (
                                                    context,
                                                  ) => RegisteredDocument(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_title_investigation_report",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => Investigation(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if ([
                                          "tbl_legal_drafts",
                                        ].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => Legaldrafts(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if (["tbl_court_cases"].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => Courtcases(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else if (["tbl_adhikar_abhilekh"].contains(tblName)) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => Adhikar_Abhilekh(
                                                    id: id,
                                                    serviceName: serviceName,
                                                    tblName: tblName,
                                                    isToggled: isToggled,
                                                    serviceNameInLocalLanguage:
                                                        selectedService['service_name_in_local_language'] ??
                                                        serviceName,
                                                  ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Service not available for this selection.",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          serviceIcon.isNotEmpty
                                              ? Image.network(
                                                serviceIcon,
                                                height: 25,
                                                width: 25,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (ctx, _, __) => const Icon(
                                                      Icons.broken_image,
                                                      size: 25,
                                                    ),
                                              )
                                              : const Icon(
                                                Icons.miscellaneous_services,
                                                size: 30,
                                              ),
                                          const SizedBox(height: 5),
                                          Text(
                                            displayName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w500,
                                              color: Colorfile.lightblack,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 18,
                          ),
                          child: Text(
                            isToggled ? 'पॅकेजेस' : 'Packages',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colorfile.lightblack,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 20,
                            bottom: 10,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(packages.length, (index) {
                                final offer = packages[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("Tapped on: ${offer['offerName']}");
                                    },
                                    child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color(0xFFDFE6F8),
                                          width: 0.5,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              offer['iconPath'] ??
                                                  'images/package1.png',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              offer['offerName'] ??
                                                  'No Offer Name',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF353B43),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: Text(
                                              offer['description'] ??
                                                  'No Description',
                                              style: const TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF4B5563),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Wrap(
                                              spacing: 5,
                                              runSpacing: 5,
                                              children:
                                                  (offer['services']
                                                          as List<String>?)
                                                      ?.map((service) {
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFFF5F4F1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  5,
                                                                ),
                                                            border: Border.all(
                                                              color:
                                                                  const Color(
                                                                    0xFFE5E7EB,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            service,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 7,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                    0xFF757575,
                                                                  ),
                                                                ),
                                                          ),
                                                        );
                                                      })
                                                      .toList() ??
                                                  [],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                offset: Offset(2, 0),
                blurRadius: 25,
                spreadRadius: 0,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: BottomNavigationStrings.getString('home', isToggled),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.support_agent_outlined),
                label: BottomNavigationStrings.getString(
                  'customerCare',
                  isToggled,
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.edit_document),
                label: BottomNavigationStrings.getString('myOrder', isToggled),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: BottomNavigationStrings.getString(
                  'myProfile',
                  isToggled,
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colorfile.bordertheme,
            unselectedItemColor: Colorfile.lightgrey,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

// lib/language/bottom_navigation_strings.dart
class BottomNavigationStrings {
  static String getString(String key, bool isToggled) {
    final Map<String, Map<String, String>> strings = {
      'home': {
        'en': 'Home',
        'local': 'होम', // Marathi example
      },
      'customerCare': {'en': 'Customer Care', 'local': 'ग्राहक सेवा'},
      'myOrder': {'en': 'My Order', 'local': 'माझी ऑर्डर'},
      'myProfile': {'en': 'My Profile', 'local': 'माझे प्रोफाइल'},
      'packages': {'en': 'Packages', 'local': 'पॅकेजेस'},
    };

    final language = isToggled ? 'local' : 'en';
    return strings[key]?[language] ??
        key; // Fallback to key if string not found
  }
}
