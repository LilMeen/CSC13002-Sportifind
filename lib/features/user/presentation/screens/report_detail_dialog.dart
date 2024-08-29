// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/user/domain/entities/report_entity.dart';
import 'package:sportifind/features/user/domain/usecases/delete_report.dart';

extension DateHelpers on DateTime {
  String toShortDateString() {
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  }
}

class ReportDetailDialog extends StatelessWidget {
  final ReportEntity report;

  const ReportDetailDialog({
    super.key, 
    required this.report,
  });

  Future<void> deleteReport(BuildContext context) async {
  bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text('Confirm Deletion', style: SportifindTheme.normalTextBlack),),
        content: Text('Are you sure you want to delete this report?', style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); 
                },
                child: Text('Cancel', style: SportifindTheme.smallTextBluePurple),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); 
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
      await UseCaseProvider.getUseCase<DeleteReport>().call(
        DeleteReportParams(reportId: report.id),
      );
      Navigator.of(context).pop(); // Close the screen or dialog after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete report.'),
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('From ${report.reporter.name}', style: SportifindTheme.normalTextBlack),
      content: SizedBox(
        width: 200,
        height: 170, 
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Date: ${report.timestamp.toDate().toShortDateString()}', style: SportifindTheme.normalTextBlack),
              Text('Report: ${report.reportedUser.name}', style: SportifindTheme.normalTextBlack),
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
                  controller: TextEditingController(text: report.reason),
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
  }
}


