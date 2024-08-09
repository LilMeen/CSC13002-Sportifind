import 'package:flutter/material.dart';
import 'package:sportifind/widgets/setting_menu.dart';
import 'package:sportifind/screens/auth/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

Future<void> deleteUserData() async {
  if (user != null) {
    final userId = user!.uid;

    try {
      // Updating matches collection
      final matchesDocs = await FirebaseFirestore.instance
          .collection('matches')
          .where('stadiumOwner', isEqualTo: userId)
          .get();
      for (final doc in matchesDocs.docs) {
        await doc.reference.update({'stadiumOwner': FieldValue.delete()});
      }

      // Updating stadiums collection
      final stadiumsDocs = await FirebaseFirestore.instance
          .collection('stadiums')
          .where('owner', isEqualTo: userId)
          .get();
      for (final doc in stadiumsDocs.docs) {
        await doc.reference.update({'owner': FieldValue.delete()});
      }

      // Updating teams collection
      final teamsAsCaptain = await FirebaseFirestore.instance
          .collection('teams')
          .where('captain', isEqualTo: userId)
          .get();
      for (final doc in teamsAsCaptain.docs) {
        await doc.reference.update({'captain': FieldValue.delete()});
      }

      final teamsAsMember = await FirebaseFirestore.instance
          .collection('teams')
          .where('members', arrayContains: userId)
          .get();
      for (final doc in teamsAsMember.docs) {
        await doc.reference.update({
          'members': FieldValue.arrayRemove([userId])
        });
      }

      // Updating reports subcollection within users with admin role
      final adminUsers = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      for (final admin in adminUsers.docs) {
        final adminReports = await admin.reference
            .collection('reports')
            .where('reportedUserId', isEqualTo: userId)
            .get();
        for (final doc in adminReports.docs) {
          await doc.reference.update({'reportedUserId': FieldValue.delete()});
        }

        final reporterReports = await admin.reference
            .collection('reports')
            .where('reporterId', isEqualTo: userId)
            .get();
        for (final doc in reporterReports.docs) {
          await doc.reference.update({'reporterId': FieldValue.delete()});
        }
      }

      // Delete user document
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      await userDoc.delete();

    } catch (e) {
      print("Error updating Firestore: $e");

      if (e is FirebaseException && e.code == 'failed-precondition') {
        print("Index required for query is missing. Please create the required index in Firestore.");
        throw Exception("Firestore index is missing. Please create the required index.");
      } else {
        throw Exception("Failed to update Firestore: $e");
      }
    }
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

  if (confirmed == true) {
    try {
      await deleteUserData();

      // Deleting the user from Firebase Authentication
      await user!.delete();

      // Sign out the user
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
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SettingMenu(
            title: "Help & Feedback",
            onPress: () {},
            endIcon: true,
            textColor: Colors.black,
          ),
          const SizedBox(height: 10),
          SettingMenu(
            title: "Policy",
            onPress: () {},
            endIcon: true,
            textColor: Colors.black,
          ),
          const SizedBox(height: 10),
          SettingMenu(
            title: "About us",
            onPress: () {},
            endIcon: true,
            textColor: Colors.black,
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
                    backgroundColor: Color.fromARGB(255, 24, 24, 207), 
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                        width: 6,
                        color: Color.fromARGB(255, 24, 24, 207)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity, 
                    height: 30, 
                    child: Center(
                      child: Text('Sign out',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
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
