import 'package:flutter/material.dart';
import 'package:sportifind/widgets/setting.dart';
import 'package:sportifind/widgets/information_menu.dart';
import 'package:sportifind/screens/player/profile/widgets/hexagon_stat.dart';
import 'package:sportifind/screens/player/profile/edit_information.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.height, required this.weight, required this.foot, required this.right_foot});
  final String height;
  final String weight;
  final String foot;
  final bool right_foot;

  String getType(String type) {
    switch (type) {
      case "height":
        return height;
      case "weight":
        return weight;
      case "foot":
        return foot;
      default:
        return "nothing"; // Default icon if no match is found
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
 
  Widget buildSection(String type) {
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
            Text(getType(type))
          ]),
        ),
      ),
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
                  builder: (context) => const SettingScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
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
                        child: const Image(
                          image: AssetImage("lib/assets/google_logo.png"),
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
                          color: Colors.tealAccent,
                        ),
                        child: IconButton(
                          onPressed: () {},
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
                const Text('Admin', style: TextStyle(color: Colors.white)),
                const Text('admin@mail.com', style: TextStyle(color: Colors.white)),
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
                const InformationMenu(textContent: "0123456789", icon: "phone"),
                const InformationMenu(
                    textContent: "Ho Chi Minh city", icon: "location"),
                const InformationMenu(textContent: "12/05/2004", icon: "dob"),
                const SizedBox(height: 15),
                Row(
                  children: [
                    buildSection("height"),
                    const SizedBox(width: 15),
                    buildSection("weight"),
                    const SizedBox(width: 15),
                    buildSection("foot"),
                  ],
                ),
                const SizedBox(height: 20),
                Hexagon(screenWidth: MediaQuery.of(context).size.width),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



