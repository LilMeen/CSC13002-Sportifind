import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getAdminReports(String adminUserId) {
    return _firestore
        .collection('users')
        .doc(adminUserId)
        .collection('reports')
        .get();
  }

  Future<DocumentSnapshot?> getUser(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc;
    } else {
      return null;
    }
  }

  Future<void> deleteReport(String reporterId, String reportedUserId,
      String reason, Timestamp timestamp) async {
    try {
      QuerySnapshot adminSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      for (var adminDoc in adminSnapshot.docs) {
        QuerySnapshot reportsSnapshot = await _firestore
            .collection('users')
            .doc(adminDoc.id)
            .collection('reports')
            .where('reporterId', isEqualTo: reporterId)
            .where('reportedUserId', isEqualTo: reportedUserId)
            .where('reason', isEqualTo: reason)
            .where('timestamp', isEqualTo: timestamp)
            .get();

        for (var reportDoc in reportsSnapshot.docs) {
          await _firestore
              .collection('users')
              .doc(adminDoc.id)
              .collection('reports')
              .doc(reportDoc.id)
              .delete();
        }
      }
    } catch (e) {
      print("Error deleting report: $e");
      throw e;
    }
  }
}

extension DateHelpers on DateTime {
  String toShortDateString() {
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  }
}

class ReportDetailDialog extends StatelessWidget {
  final String reporterId;
  final String reportedUserId;
  final String reason;
  final DateTime timestamp;
  final FirestoreService firestoreService = FirestoreService();

  ReportDetailDialog({
    required this.reporterId,
    required this.reportedUserId,
    required this.reason,
    required this.timestamp,
  });

  Future<void> deleteReport(BuildContext context) async {
    try {
      await firestoreService.deleteReport(
          reporterId, reportedUserId, reason, Timestamp.fromDate(timestamp));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete report.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot?>(
      future: firestoreService.getUser(reporterId),
      builder: (context, reporterSnapshot) {
        if (reporterSnapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
            title: Text('Loading...'),
            content: Center(child: CircularProgressIndicator()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              side: BorderSide(color: SportifindTheme.bluePurple, width: 2),
            ),
          );
        }

        if (!reporterSnapshot.hasData || !reporterSnapshot.data!.exists) {
          return AlertDialog(
            title: const Text('Reporter not found'),
            content: const Text('The reporter details could not be found.'),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              side: BorderSide(color: SportifindTheme.bluePurple, width: 2),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Close'),
              ),
            ],
          );
        }

        var reporterName = reporterSnapshot.data!['name'];

        return AlertDialog(
          title: Text('From $reporterName', style: SportifindTheme.normalTextBlack),
          content: SizedBox(
            width: 200,
            height: 170, 
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Date: ${timestamp.toLocal().toShortDateString()}', style: SportifindTheme.normalTextBlack),
                  FutureBuilder<DocumentSnapshot?>(
                    future: firestoreService.getUser(reportedUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Text('User not found.');
                      }

                      var reportedUserName = snapshot.data!['name'];

                      return Text('Report: $reportedUserName', style: SportifindTheme.normalTextBlack);
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 300, 
                    height: 100, 
                    decoration: BoxDecoration(
                      color:
                          Colors.grey[200], 
                      border:  Border(
                        bottom: BorderSide(
                          color: SportifindTheme.bluePurple, 
                          width: 2, 
                        ),
                      ),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: reason),
                      readOnly: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none, 
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0), 
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          actions: <Widget>[
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text('Close', style: SportifindTheme.normalTextBlack),
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      deleteReport(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: SportifindTheme.bluePurple),
                    child: Text('Delete',
                         style: SportifindTheme.normalTextBlack),
                    ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }
}

