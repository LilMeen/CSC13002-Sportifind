import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/user/domain/entities/report_entity.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';

abstract interface class UserRepository {
  
  // USER
  Future<Result<UserEntity>> getUser(String id);
  Future<Result<List<UserEntity>>> getAllUsers();
  Future<Result<void>> deleteUser(UserEntity user);

  // REPORT
  Future<Result<ReportEntity>> getReport(String id);
  Future<Result<List<ReportEntity>>> getAllReports();
  Future<Result<List<ReportEntity>>> getReportByReporterId(String userId);
  Future<Result<List<ReportEntity>>> getReportByReportedUserId(String userId);
  Future<Result<void>> deleteReport(String reportId);
}