import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/widgets/setting.dart';
import 'package:sportifind/widgets/information_menu.dart';
import 'package:sportifind/screens/player/profile/edit_information.dart';
import 'package:sportifind/screens/player/profile/widgets/rating.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot> userDataFuture;

  //final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    userDataFuture = getUserData();
  }

  Future<DocumentSnapshot> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      throw Exception('User not logged in');
    }
  }

  String getType(String type, Map<String, dynamic> data) {
    switch (type) {
      case "height":
        return data['height'] ?? '';
      case "weight":
        return data['weight'] ?? '';
      case "foot":
        return data['foot'] ?? '';
      case "address":
        return data['address'] ?? '';
      case "city":
        return data['city'] ?? '';
      case "district":
        return data['district'] ?? '';
      case "dob":
        return data['dob'] ?? '';
      case "email":
        return data['email'] ?? '';
      case "gender":
        return data['gender'] ?? '';
      case "name":
        return data['name'] ?? '';
      case "password":
        return data['password'] ?? '';
      case "phone":
        return data['phone'] ?? '';
      case "role":
        return data['role'] ?? '';
      case "stat":
        if (data['stat'] is List) {
          final statsList = data['stat'] as List;
          final ratings = statsList.map((stat) => Rating.fromMap(stat)).toList();
          return ratings.map((rating) => '${rating.name}: ${rating.value}').join(', ');
        } else {
          return '';
        }
      default:
        return "nothing"; // Default text if no match is found
    }
  }

  IconData getIcon(String type) {
    switch (type) {
      case "height":
        return Icons.height;
      case "weight":
        return Icons.scale;
      case "foot":
        return Icons.front_hand;
      default:
        return Icons.home; // Default icon if no match is found
    }
  }

  Widget buildSection(String type, Map<String, dynamic> data) {
    return Expanded(
      child: Container(
        width: 10,
        decoration: BoxDecoration(
          color: Colors.tealAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Icon(getIcon(type), color: Colors.black),
            Text(getType(type, data))
          ]),
        ),
      ),
    );
  }

  Future<File> get getImageFileFromAssets async {
    final byteData = await rootBundle.load('lib/assets/logo/google_logo.png');
    final tempDir = await getTemporaryDirectory();

    final tempFile = File('${tempDir.path}/your_image.jpg');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    return tempFile;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  XFile? image;
  UploadTask? uploadTask;

  Future<void> _pickImageFromGallery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(picture != null){
      image = picture;
      setState(() {});
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance
      .ref()
      .child('users')
      .child(userId)
      .child('avatar')
      .child('avatar.jpg');

    uploadTask = storageRef.putFile(File(image!.path));
  }

  Future<void> _pickImageFromCamera() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.camera);

    if(picture != null){
      image = picture;
      setState(() {});
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance
      .ref()
      .child('users')
      .child(userId)
      .child('avatar')
      .child('avatar.jpg');

    uploadTask = storageRef.putFile(File(image!.path));
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick from Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Picture'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImageFromCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      body: FutureBuilder<DocumentSnapshot>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
            return const Center(child: Text('No data available'));
          }

          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;


          return 
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: image == null ? const Image(image: AssetImage("lib/assets/google_logo.png"),)
                              : Image.file(File(image!.path)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.tealAccent,
                              ),
                              child: IconButton(
                                onPressed: () => _showImagePickerOptions(context),
                                icon: const Icon(
                                  Icons.create_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(userData['name'] ?? 'Name', style: const TextStyle(color: Colors.white)),
                      Text(userData['email'] ?? 'Email', style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditInformationScreen(),
                              ),
                            );
                          },
                          child: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      InformationMenu(textContent: userData['phone'] ?? "Phone", icon: "phone"),
                      InformationMenu(textContent: userData['address'] ?? "address", icon: "location"),
                      InformationMenu(textContent: userData['dob'] ?? "Date of Birth", icon: "dob"),
                      const SizedBox(height: 15),  
                    ],
                  ),
                ),
              ),
            );    
        },
        
      ),
    );
  }
}