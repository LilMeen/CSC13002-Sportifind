
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';

class ReportEntity {
  final String id;
  final String reason;
  final UserEntity reporter;
  final UserEntity reportedUser;
  final Timestamp timestamp;

  ReportEntity({
    required this.id,
    required this.reason,
    required this.reporter,
    required this.reportedUser,
    required this.timestamp,
  });
}