import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:sportifind/features/profile/presentation/screens/setting_screen.dart';
import 'package:sportifind/features/profile/presentation/widgets/hexagon.dart';
import 'package:sportifind/features/profile/presentation/widgets/information_menu.dart';
import 'dart:io';
import 'package:sportifind/features/profile/presentation/widgets/rating.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  PlayerEntity? player;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlayer();
  }

  Future<void> fetchPlayer() async {
    try {
      player = await UseCaseProvider.getUseCase<GetPlayer>()
          .call(
            GetPlayerParams(id: FirebaseAuth.instance.currentUser!.uid),
          )
          .then((value) => value.data!);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      throw ("Error fetching player data");
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
      player!.avatar = File(imageUrl);
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
      player!.avatar = File(imageUrl);
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

    // Default ratings with all values set to 0
    List<Rating> defaultRatings = [
      Rating('PACE', player!.stats.pace),
      Rating('SHOOT', player!.stats.shoot),
      Rating('PASS', player!.stats.pass),
      Rating('DRI', player!.stats.drive),
      Rating('DEF', player!.stats.def),
      Rating('PHY', player!.stats.physic),
    ];

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
        automaticallyImplyLeading: false,
      ),
      backgroundColor: SportifindTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
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
                          child: player!.avatar.path == ''
                              ? const Image(
                                  image: AssetImage("lib/assets/no_avatar.png"),
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                )
                              : Image.network(
                                  player!.avatar.path,
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
                  Text(player!.name,
                      style:
                          SportifindTheme.normalTextBlack.copyWith(fontSize: 16)),
                  Text(player!.email,
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
                            builder: (context) =>
                                EditInformationScreen(player: player!),
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
                  InformationMenu(textContent: player!.phone, icon: "phone"),
                  InformationMenu(
                      textContent:
                          "${player!.location.district}, ${player!.location.city} City",
                      icon: "location"),
                  InformationMenu(textContent: player!.dob, icon: "dob"),
                  const Divider(),
                  InformationMenu(
                      textContent: player!.height != ''
                          ? "${player!.height} m"
                          : "No information",
                      icon: "height"),
                  InformationMenu(
                      textContent: player!.weight != ''
                          ? "${player!.weight} kg"
                          : "No information",
                      icon: "weight"),
                  InformationMenu(
                    textContent: player!.preferredFoot == 'right'
                        ? "Right footed"
                        : player!.preferredFoot == 'left'
                            ? "Left footed"
                            : "No information",
                    icon: "foot",
                  ),
                  const SizedBox(height: 20),
                  Hexagon(
                    screenWidth: MediaQuery.of(context).size.width,
                    ratings: defaultRatings,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
