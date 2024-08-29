// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/widgets/app_bar/flutter_app_bar_blue_purple.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_out.dart';
import 'package:sportifind/features/auth/presentations/screens/sign_in_screen.dart';
import 'package:sportifind/features/profile/presentation/widgets/setting_menu.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

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

      if (e is FirebaseException && e.code == 'failed-precondition') {
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
        title: Center(
          child: Text('Confirm Deletion', style: SportifindTheme.normalTextBlack),),
        content: Text('Are you sure you want to delete this account?', style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Dismiss the dialog and return false
                },
                child: Text('Cancel', style: SportifindTheme.smallTextBluePurple),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Dismiss the dialog and return true
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                ),
                child: Text('Delete', style: SportifindTheme.normalTextWhite.copyWith(fontSize: 14)),
              ),
            ],
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
      await UseCaseProvider.getUseCase<SignOut>().call(NoParams());
      
      Navigator.of(context).pushReplacement(SignInScreen.route());
    } catch (e) {
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
        title: Center(
          child: Text('Confirm Sign Out', style: SportifindTheme.normalTextBlack),),
        content: Text('Are you sure you want to sign out?', style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Dismiss the dialog and return false
                },
                child: Text('Cancel', style: SportifindTheme.smallTextBluePurple),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Dismiss the dialog and return true
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SportifindTheme.bluePurple, 
                ),
                child: Text('Sign out', style: SportifindTheme.normalTextWhite.copyWith(fontSize: 14)),
              ),
            ],
          ),
        ],
      );
      },
    );

    if (confirmed) {
      await UseCaseProvider.getUseCase<SignOut>().call(NoParams());
      
      Navigator.of(context).pushReplacement(SignInScreen.route());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SignInScreen();
    }

    return Scaffold(
      appBar: const FeatureAppBarBluePurple(title: "Setting"),
      backgroundColor: SportifindTheme.backgroundColor,
      body: Column(
        children: [
          const SettingMenu(
            title: "Help & Feedback",
            endIcon: true,
            textColor: Colors.black,
          ),
          const SizedBox(height: 10),
          const SettingMenu(
            title: "Policy",
            endIcon: true,
            textColor: Colors.black,
          ),
          const SizedBox(height: 10),
          const SettingMenu(
            title: "About us",
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
                    backgroundColor: const Color.fromARGB(255, 24, 24, 207), 
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
