import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/admin/report_detail_dialog.dart';
import 'package:intl/intl.dart'; // Import intl package

extension DateHelpers on DateTime {
  String toShortDateString() {
    return DateFormat('dd/MM/yyyy').format(this); // Use DateFormat for custom date format
  }
}

class ViewReportList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('reports')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var reports = snapshot.data!.docs;

              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  var report = reports[index];
                  var reporterId = report['reporterId'];
                  var reportedUserId = report['reportedUserId'];
                  var reason = report['reason'];
                  var timestamp = report['timestamp'].toDate();

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(reporterId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return Container();
                      }

                      var userName = userSnapshot.data!['name'];
                      String displayName = userName.split(' ').take(10).join(' ');
                      if (userName.split(' ').length > 10) {
                        displayName += '...';
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: SportifindTheme.bluePurple, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'From $displayName',
                                    overflow: TextOverflow.ellipsis,
                                    style: SportifindTheme.normalTextBlack
                                  ),
                                ),
                                InkWell(
                                  child: Text(
                                    'View Details',                                  
                                    style: SportifindTheme.viewProfileDetails ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ReportDetailDialog(
                                        reporterId: reporterId,
                                        reportedUserId: reportedUserId,
                                        reason: reason,
                                        timestamp: timestamp,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            subtitle: Text('Date: ${DateFormat('dd/MM/yyyy').format(timestamp)}', style: SportifindTheme.normalTextSmokeScreen),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
