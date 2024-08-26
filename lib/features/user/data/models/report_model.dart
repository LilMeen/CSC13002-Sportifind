import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/user/data/datasources/user_remote_data_source.dart';
import 'package:sportifind/features/user/domain/entities/report_entity.dart';

class ReportModel {
  final String id;
  final String reason;
  final String reporterId;
  final String reportedUserId;
  final Timestamp timestamp;

  ReportModel({
    required this.id,
    required this.reason,
    required this.reporterId,
    required this.reportedUserId,
    required this.timestamp,
  });

  // REMOTE DATA SOURCE
  final UserRemoteDataSource userRemoteDataSource = UserRemoteDataSourceImpl();

  // DATA CONVERSION
  factory ReportModel.fromFirestore(DocumentSnapshot reportDoc) {
    Map<String, dynamic> data = reportDoc.data() as Map<String, dynamic>;

    return ReportModel(
      id: reportDoc.id,
      reason: data['reason'] ?? '',
      reporterId: data['reporterId'] ?? '',
      reportedUserId: data['reportedUserId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reason': reason,
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'timestamp': timestamp,
    };
  }

  factory ReportModel.fromEntity(ReportEntity reportEntity) {
    return ReportModel(
      id: reportEntity.id,
      reason: reportEntity.reason,
      reporterId: reportEntity.reporter.id,
      reportedUserId: reportEntity.reportedUser.id,
      timestamp: reportEntity.timestamp,
    );
  }

  Future<ReportEntity> toEntity() async {
    return ReportEntity(
      id: id,
      reason: reason,
      reporter: await userRemoteDataSource.getUser(reporterId).then((value) => value.toEntity()),
      reportedUser: await userRemoteDataSource.getUser(reportedUserId).then((value) => value.toEntity()),
      timestamp: timestamp,
    );
  }
}