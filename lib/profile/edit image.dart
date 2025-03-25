import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class GalleryAccess extends StatefulWidget {
//   final Function(String message) onApplyFilter;

//   const GalleryAccess({super.key, required this.onApplyFilter});

//   @override
//   State<GalleryAccess> createState() => _GalleryAccessState();
// }

// class _GalleryAccessState extends State<GalleryAccess> {
//   File? galleryFile;
//   final picker = ImagePicker();
//   String? imageUrl; // for storing uploaded profile URL

//   @override
//   void initState() {
//     super.initState();
//     loadSavedImage();
//   }

//   Future<void> loadSavedImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       imageUrl = prefs.getString("profile_image_url");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FA),
//       appBar: AppBar(
//         backgroundColor: Colors.green.shade700,
//         elevation: 0,
//         title: const Text("Photo Picker"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),

//               // 🟢 Circle Avatar Preview
//               CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.grey.shade300,
//                 backgroundImage:
//                     galleryFile != null
//                         ? FileImage(galleryFile!)
//                         : (imageUrl != null
//                             ? NetworkImage(imageUrl!) as ImageProvider
//                             : const AssetImage('assets/default_user.png')),
//               ),

//               const SizedBox(height: 30),
//               Material(
//                 elevation: 6,
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Upload your photo",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildOptionCard(
//                             icon: Icons.photo_library,
//                             label: "Gallery",
//                             onTap: () => getImage(ImageSource.gallery),
//                           ),
//                           _buildOptionCard(
//                             icon: Icons.photo_camera,
//                             label: "Camera",
//                             onTap: () => getImage(ImageSource.camera),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionCard({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         height: 120,
//         width: 120,
//         decoration: BoxDecoration(
//           color: Colors.green.shade50,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.green.shade100,
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.green.shade800),
//             const SizedBox(height: 10),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.green.shade900,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> getImage(ImageSource img) async {
//     final pickedFile = await picker.pickImage(source: img);
//     if (pickedFile != null) {
//       log("${pickedFile.name}");
//       setState(() {
//         galleryFile = File(pickedFile.path);
//       });

//       widget.onApplyFilter("Image selected: ${pickedFile.path}");
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class GalleryAccess extends StatefulWidget {
//   final Function(String message) onApplyFilter;

//   const GalleryAccess({super.key, required this.onApplyFilter});

//   @override
//   State<GalleryAccess> createState() => _GalleryAccessState();
// }

// class _GalleryAccessState extends State<GalleryAccess> {
//   File? galleryFile;
//   final picker = ImagePicker();
//   String? imageUrl; // for storing uploaded profile URL

//   @override
//   void initState() {
//     super.initState();
//     loadSavedImage();
//   }

//   Future<void> loadSavedImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       imageUrl = prefs.getString("profile_image_url");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FA),
//       appBar: AppBar(
//         backgroundColor: Colors.green.shade700,
//         elevation: 0,
//         title: const Text("Photo Picker"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),

//               // 🟢 Circle Avatar Preview
//               CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.grey.shade300,
//                 backgroundImage:
//                     galleryFile != null
//                         ? FileImage(galleryFile!)
//                         : (imageUrl != null
//                             ? NetworkImage(imageUrl!) as ImageProvider
//                             : const AssetImage('assets/default_user.png')),
//               ),

//               const SizedBox(height: 30),
//               Material(
//                 elevation: 6,
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Upload your photo",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildOptionCard(
//                             icon: Icons.photo_library,
//                             label: "Gallery",
//                             onTap: () => getImage(ImageSource.gallery),
//                           ),
//                           _buildOptionCard(
//                             icon: Icons.photo_camera,
//                             label: "Camera",
//                             onTap: () => getImage(ImageSource.camera),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionCard({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         height: 120,
//         width: 120,
//         decoration: BoxDecoration(
//           color: Colors.green.shade50,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.green.shade100,
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.green.shade800),
//             const SizedBox(height: 10),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.green.shade900,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> getImage(ImageSource img) async {
//     final pickedFile = await picker.pickImage(source: img);
//     if (pickedFile != null) {
//       log("${pickedFile.name}");
//       setState(() {
//         galleryFile = File(pickedFile.path);
//       });

//       widget.onApplyFilter("Image selected: ${pickedFile.path}");

//       // ✅ Upload image as base64
//       await uploadImageAsBase64(galleryFile!);
//     } else {
//       ScaffoldMessenger.of(
//         context as BuildContext,
//       ).showSnackBar(const SnackBar(content: Text('Nothing is selected')));
//     }
//   }

//   Future<void> uploadImageAsBase64(File imageFile) async {
//     log("${imageFile.path}");
//     try {
//       List<int> imageBytes = await imageFile.readAsBytes();
//       String base64Image = await base64Encode(imageBytes);
//       log("$base64Image");

//       String fileName = basename(imageFile.path);

//       var url = Uri.parse("https://seekhelp.in/bhulex/api/update_profile");
//       var response = await http.post(
//         url,
//         body: {
//           "customer_id": "1",
//           "profile_image": base64Image,
//           "file_name": fileName,
//         },
//       );

//       if (response.statusCode == 200) {
//         log("${response.statusCode}");
//         final jsonData = jsonDecode(response.body);

//         final imagePath =
//             jsonData['profile_image_path'] + jsonData['data']['profile_image'];

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString("profile_image_url", imagePath);

//         setState(() {
//           imageUrl = imagePath;
//         });

//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(content: Text('Failed to upload profile image')),
//         );
//       }
//     } catch (e) {
//       debugPrint("Upload Error: $e");
//       ScaffoldMessenger.of(
//         context as BuildContext,
//       ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
//     }
//   }
// }

//       // ✅ Upload image as base64
//       await uploadImageAsBase64(galleryFile!);
//     } else {
//       ScaffoldMessenger.of(
//         context as BuildContext,
//       ).showSnackBar(const SnackBar(content: Text('Nothing is selected')));
//     }
//   }

//   Future<void> uploadImageAsBase64(File imageFile) async {
//     log("${imageFile.path}");
//     try {
//       List<int> imageBytes = await imageFile.readAsBytes();
//       String base64Image = await base64Encode(imageBytes);
//       log("$base64Image");

//       String fileName = basename(imageFile.path);

//       var url = Uri.parse("https://seekhelp.in/bhulex/api/update_profile");
//       var response = await http.post(
//         url,
//         body: {
//           "customer_id": "1",
//           "profile_image": base64Image,
//           "file_name": fileName,
//         },
//       );

//       if (response.statusCode == 200) {
//         log("${response.statusCode}");
//         final jsonData = jsonDecode(response.body);

//         final imagePath =
//             jsonData['profile_image_path'] + jsonData['data']['profile_image'];

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString("profile_image_url", imagePath);

//         setState(() {
//           imageUrl = imagePath;
//         });

//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//           const SnackBar(content: Text('Failed to upload profile image')),
//         );
//       }
//     } catch (e) {
//       debugPrint("Upload Error: $e");
//       ScaffoldMessenger.of(
//         context as BuildContext,
//       ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
//     }
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  void _showEditProfileImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 16,
          ),
          child: Wrap(
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.photo, size: 40, color: Colors.orange),
                    const SizedBox(height: 10),
                    const Text(
                      "Edit Profile Photo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF36322E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Choose a method to update your photo",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => GalleryAccess(
                                          onApplyFilter: (msg) {
                                            debugPrint(msg);
                                          },
                                        ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.orange.shade100,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 28,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Camera",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => GalleryAccess(
                                          onApplyFilter: (msg) {
                                            debugPrint(msg);
                                          },
                                        ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.orange.shade100,
                                child: Icon(
                                  Icons.photo_library,
                                  size: 28,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showEditProfileImageBottomSheet(context),
          child: const Text("Edit Profile Photo"),
        ),
      ),
    );
  }
}

class GalleryAccess extends StatefulWidget {
  final Function(String message) onApplyFilter;

  const GalleryAccess({super.key, required this.onApplyFilter});

  @override
  State<GalleryAccess> createState() => _GalleryAccessState();
}

class _GalleryAccessState extends State<GalleryAccess> {
  File? galleryFile;
  final picker = ImagePicker();
  String? imageUrl; // for storing uploaded profile URL
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    loadSavedImage();
  }

  Future<void> loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString("profile_image_url");
    });
  }

  Future<void> updateProfileImage(File imageFile, BuildContext context) async {
    try {
      setState(() => isUploading = true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? customerId =
          prefs.getString('customer_id') ?? '1'; // Default to '1' if not found

      var url = Uri.parse("https://seekhelp.in/bhulex/update_profile");
      var request = http.MultipartRequest('POST', url);

      // Add customer_id to form data
      request.fields['customer_id'] = customerId;

      // Add profile image to form data
      var multipartFile = await http.MultipartFile.fromPath(
        'profile_image',
        imageFile.path,
        filename: basename(imageFile.path),
      );
      request.files.add(multipartFile);

      // Send request
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody.body);
        if (jsonData['status'] == "true") {
          final newImageUrl =
              "${jsonData['profile_image_path']}${jsonData['data']['profile_image']}";

          // Save the new image URL
          await prefs.setString("profile_image_url", newImageUrl);

          setState(() {
            imageUrl = newImageUrl;
            galleryFile = imageFile;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image updated successfully!'),
            ),
          );

          // Pop back to profile page
          Navigator.pop(context);
        } else {
          throw Exception('API returned false status');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Upload Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> getImage(ImageSource img, BuildContext context) async {
    final pickedFile = await picker.pickImage(source: img);
    if (pickedFile != null) {
      log("${pickedFile.name}");
      setState(() {
        galleryFile = File(pickedFile.path);
      });

      widget.onApplyFilter("Image selected: ${pickedFile.path}");

      // Upload the image immediately after selection
      await updateProfileImage(galleryFile!, context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        title: const Text("Photo Picker"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Circle Avatar Preview
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        galleryFile != null
                            ? FileImage(galleryFile!)
                            : (imageUrl != null
                                ? NetworkImage(imageUrl!) as ImageProvider
                                : const AssetImage('assets/default_user.png')),
                  ),
                  const SizedBox(height: 30),
                  Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Upload your photo",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOptionCard(
                                icon: Icons.photo_library,
                                label: "Gallery",
                                onTap:
                                    () =>
                                        getImage(ImageSource.gallery, context),
                              ),
                              _buildOptionCard(
                                icon: Icons.photo_camera,
                                label: "Camera",
                                onTap:
                                    () => getImage(ImageSource.camera, context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUploading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isUploading ? null : onTap, // Disable tap when uploading
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade100,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green.shade800),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
