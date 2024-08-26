import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/user/domain/entities/report_entity.dart';
import 'package:sportifind/features/user/domain/usecases/get_all_report.dart';
import 'package:sportifind/features/user/presentation/screens/report_detail_dialog.dart'; // Import intl package

extension DateHelpers on DateTime {
  String toShortDateString() {
    return DateFormat('dd/MM/yyyy').format(this); // Use DateFormat for custom date format
  }
}

class ViewReportList extends StatelessWidget {
  const ViewReportList({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FutureBuilder<List<ReportEntity>>(
            future: UseCaseProvider.getUseCase<GetAllReport>().call(NoParams()).then((value) =>value.data ?? []),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final reports = snapshot.data ?? [];
              
              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  final timestamp = report.timestamp.toDate();   

                  var userName = report.reporter.name;
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
                                  builder: (context) => ReportDetailDialog(report: report),
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
          )
        ),
      ),         
    );
  }
}