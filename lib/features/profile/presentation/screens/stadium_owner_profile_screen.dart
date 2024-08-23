import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_stadium_owner.dart';
import 'package:sportifind/features/profile/presentation/screens/edit_stadium_owner_profile_screen.dart';
import 'package:sportifind/features/profile/presentation/screens/setting_screen.dart';
import 'package:sportifind/features/profile/presentation/widgets/information_menu.dart';
import 'dart:io';

class StadiumOwnerProfileScreen extends StatefulWidget {
  const StadiumOwnerProfileScreen({super.key});

  @override
  StadiumOwnerProfileScreenState createState() => StadiumOwnerProfileScreenState();
}

class StadiumOwnerProfileScreenState extends State<StadiumOwnerProfileScreen> {
  StadiumOwnerEntity? stadiumOwner;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStadiumOwner();
  }

  Future<void> fetchStadiumOwner() async {
    try {
      stadiumOwner = await UseCaseProvider.getUseCase<GetStadiumOwner>()
          .call(
            GetStadiumOwnerParams(id: FirebaseAuth.instance.currentUser!.uid),
          )
          .then((value) => value.data!);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      throw ("Error fetching stadium owner data");
    }
  }

  String getType(String type, Map<String, dynamic> data) {
    switch (type) {
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

    setState(() {
      stadiumOwner!.avatar = File(imageUrl);
    });
  }

  Future<void> _pickImageFromCamera() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picture != null) {
      image = picture;
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
    setState(() {
      stadiumOwner!.avatar = File(imageUrl);
    });
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Pick from Gallery',
                    style: SportifindTheme.normalTextBlack),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text('Take a Picture',
                    style: SportifindTheme.normalTextBlack),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: SportifindTheme.sportifindFeatureAppBarBluePurple),
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
      body: Padding(
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
                        child: stadiumOwner!.avatar.path == ''
                            ? const Image(
                                image: AssetImage("lib/assets/no_avatar.png"),
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              )
                            : Image.network(
                                stadiumOwner!.avatar.path,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
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
                Text(stadiumOwner!.name,
                    style:
                        SportifindTheme.normalTextBlack.copyWith(fontSize: 16)),
                Text(stadiumOwner!.email,
                    style:
                        SportifindTheme.normalTextBlack.copyWith(fontSize: 16)),
                const SizedBox(height: 15),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditStadiumOwnerInformationScreen
                              (stadiumOwner: stadiumOwner!),
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
                InformationMenu(textContent: stadiumOwner!.phone, icon: "phone"),
                InformationMenu(
                    textContent:
                        "${stadiumOwner!.location.district}, ${stadiumOwner!.location.city} City",
                    icon: "location"),
                InformationMenu(textContent: stadiumOwner!.dob, icon: "dob"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
