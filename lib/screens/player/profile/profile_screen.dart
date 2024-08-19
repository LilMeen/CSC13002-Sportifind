import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/widgets/setting.dart';
import 'package:sportifind/widgets/information_menu.dart';
import 'package:sportifind/screens/player/profile/widgets/hexagon_stat.dart';
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
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
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
        if (data['preferred_foot'] != null) {
          return data['preferred_foot'] ? 'Right footed' : 'Left footed';
        } else {
          return '';
        }
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
          final ratings =
              statsList.map((stat) => Rating.fromMap(stat)).toList();
          return ratings
              .map((rating) => '${rating.name}: ${rating.value}')
              .join(', ');
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
          color: SportifindTheme.bluePurple,
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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  XFile? image;
  UploadTask? uploadTask;

  Future<void> _pickImageFromGallery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picture != null) {
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

    await storageRef.putFile(File(image!.path));
    final imageUrl = await storageRef.getDownloadURL();

    firestore.collection('users').doc(userId).update({
      'avatarImage': imageUrl,
    });
  }

  Future<void> _pickImageFromCamera() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picture != null) {
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
    await storageRef.putFile(File(image!.path));
    final imageUrl = await storageRef.getDownloadURL();

    firestore.collection('users').doc(userId).update({
      'avatarImage': imageUrl,
    });
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
                  title: Text('Pick from Gallery', style: SportifindTheme.normalTextBlack),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded),
                  title: Text('Take a Picture', style: SportifindTheme.normalTextBlack),
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
    // Default ratings with all values set to 0
    List<Rating> defaultRatings = [
      const Rating('PACE', 0),
      const Rating('SHOOT', 0),
      const Rating('PASS', 0),
      const Rating('DRI', 0),
      const Rating('DEF', 0),
      const Rating('PHY', 0),
    ];
    print('hehe');

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: SportifindTheme.sportifindFeatureAppBarBluePurple),
        centerTitle: true,
        backgroundColor: SportifindTheme.backgroundColor,
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
            icon: Icon(Icons.settings, color: SportifindTheme.bluePurple),
          ),
        ],
      ),
      backgroundColor: SportifindTheme.backgroundColor,
      body: FutureBuilder<DocumentSnapshot>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.data() == null) {
            return const Center(child: Text('No data available'));
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          print(userData['avatarImage']);

          List<Rating> ratings = defaultRatings;
          if (userData['stats'] is Map) {
            //print(userData['stats']);
            final statsMap = userData['stats'] as Map<String, dynamic>;
            ratings = statsMap.entries
                .map((entry) => Rating.fromMapEntry(entry))
                .toList();
          }

          return Padding(
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
                            child: userData['avatarImage'] == null
                                ? const Image(
                                    image: AssetImage(
                                        "lib/assets/google_logo.png"),
                                  )
                                : Image.network(userData['avatarImage']),
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
                              color: SportifindTheme.bluePurple,
                            ),
                            child: IconButton(
                              onPressed: () => _showImagePickerOptions(context),
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: SportifindTheme.backgroundColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(userData['name'] ?? 'Name',
                        style: SportifindTheme.normalTextBlack
                            .copyWith(fontSize: 16)),
                    Text(userData['email'] ?? 'Email',
                        style: SportifindTheme.normalTextBlack
                            .copyWith(fontSize: 16)),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EditInformationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SportifindTheme.bluePurple,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: Text('Edit',
                            style: SportifindTheme.normalTextWhite
                                .copyWith(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 5),
                    InformationMenu(
                        textContent: userData['phone'] ?? "Phone",
                        icon: "phone"),
                    InformationMenu(
                        textContent: (userData['district'] != null &&
                                userData['city'] != null)
                            ? "District ${userData['district']}, ${userData['city']} City"
                            : "Address",
                        icon: "location"),
                    InformationMenu(
                        textContent: userData['dob'] ?? "Date of Birth",
                        icon: "dob"),
                    const Divider(),
                    InformationMenu(
                        textContent: userData['height'] != null
                            ? "${userData['height']} m"
                            : "No information",
                        icon: "height"),
                    InformationMenu(
                        textContent: userData['weight'] != null
                            ? "${userData['weight']} kg"
                            : "No information",
                        icon: "weight"),
                    InformationMenu(
  textContent: userData['preferred_foot'] == true
      ? "Right footed"
      : userData['preferred_foot'] == false
          ? "Left footed"
          : "No information",
  icon: "foot",
),
                    const SizedBox(height: 50),
                    Hexagon(
                      screenWidth: MediaQuery.of(context).size.width,
                      ratings: ratings,
                    ),
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
