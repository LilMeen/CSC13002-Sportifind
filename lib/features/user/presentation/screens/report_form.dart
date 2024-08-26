// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class ReportDialog extends StatefulWidget {
  final String reportedUserId;

  const ReportDialog({super.key, required this.reportedUserId});

  @override
  ReportDialogState createState() => ReportDialogState();
}

class ReportDialogState extends State<ReportDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  Future<void> submitReport(String reason, String reportedUserId) async {
    try {
      // Get the current user's ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not signed in");
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Map<String, dynamic> reportData = {
        'reason': reason,
        'reporterId': user.uid,
        'reportedUserId': reportedUserId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      QuerySnapshot adminSnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      for (var doc in adminSnapshot.docs) {
        await firestore
            .collection('users')
            .doc(doc.id)
            .collection('reports')
            .add(reportData);
      }
    } catch (e) {
      throw Exception('Failed to report user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('You are reporting this user', style: SportifindTheme.normalTextBlack),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _reasonController,
          decoration: InputDecoration(hintText: 'Your reason', hintStyle: SportifindTheme.smallTextBlack),
          maxLines: 1,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Reason cannot be empty';
            }
            if (value.trim().split(RegExp(r'\s+')).length > 50) {
              return 'Reason cannot exceed 100 words';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        Row(
          children: <Widget>[
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                side: BorderSide.none,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Close',
                style: SportifindTheme.normalTextWhite.copyWith(fontSize: 14))
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String reason = _reasonController.text;
                  await submitReport(reason, widget.reportedUserId);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SportifindTheme.bluePurple,
                side: BorderSide.none,
                //shape: const StadiumBorder(),
              ),
              child: Text('Send',
              style: SportifindTheme.normalTextWhite.copyWith(fontSize: 14))
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
