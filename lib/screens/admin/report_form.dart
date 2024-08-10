import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDialog extends StatefulWidget {
  final String reportedUserId; // Add this to get the reported user's ID

  const ReportDialog({super.key, required this.reportedUserId});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
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

      print("Report submitted successfully");
    } catch (e) {
      print("Failed to submit report: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('You are reporting this user'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _reasonController,
          decoration: const InputDecoration(hintText: 'Your reason'),
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
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),)
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
                backgroundColor: Colors.greenAccent,
                side: BorderSide.none,
                //shape: const StadiumBorder(),
              ),
              child: const Text('Send',
              style: TextStyle(color: Colors.black),)
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
