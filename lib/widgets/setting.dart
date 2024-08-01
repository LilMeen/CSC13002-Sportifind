import 'package:flutter/material.dart';
import 'package:sportifind/features/auth/presentations/screens/sign_in_screen.dart';
import 'package:sportifind/widgets/setting_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(SignInScreen.route());
  }

  Future<void> deleteUserData() async {
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      await userDoc.delete();
    }
  }

  void deleteAccount(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); 
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      try {
        await deleteUserData();

        await user!.delete();

        signOut(context);
      } catch (e) {
        print("Error deleting user: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete account: $e"),
          ),
        );
      }
    }
  }

  void confirmSignOut(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return SignInScreen();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Setting'),
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
          Expanded(child: Container()), // Spacer to push buttons to the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    confirmSignOut(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent, 
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                        width: 6,
                        color: Colors.tealAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity, 
                    height: 30, 
                    child: Center(
                      child: Text('Sign out',
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    deleteAccount(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, 
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    side: const BorderSide(
                        width: 6, color: Colors.red), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity, 
                    height: 30, 
                    child: Center(
                      child: Text('Delete Account',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
