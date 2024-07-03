import 'package:flutter/material.dart';
import 'package:sportifind/widgets/setting_menu.dart';
import 'package:sportifind/screens/player/profile/profile_screen.dart';


class SettingScreen extends StatelessWidget{
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(
                    height: "174",
                    weight: "67",
                    foot: "right",
                    right_foot: false,
                  ),
                ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Setting',
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 33, 33, 33),
        elevation: 0.0,
      ),
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      body: Column(
        children: [
          SettingMenu(
                title: "Help & Feedback",
                onPress: () {},
                endIcon: true,
                textColor: Colors.white,
          ),
          const SizedBox(height: 10),
          SettingMenu(
                title: "Policy",
                onPress: () {},
                endIcon: true,
                textColor: Colors.white,
          ),
          const SizedBox(height: 10),
          SettingMenu(
                title: "About us",
                onPress: () {},
                endIcon: true,
                textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

