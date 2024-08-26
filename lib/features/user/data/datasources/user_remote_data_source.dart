import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/user/data/models/report_model.dart';
import 'package:sportifind/features/user/data/models/user_model.dart';

abstract interface class UserRemoteDataSource {

  // USER
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getAllUsers();
  Future<void> deleteUser(String id);

  // REPORT
  Future<ReportModel> getReport(String id);
  Future<List<ReportModel>> getAllReports();
  Future<List<ReportModel>> getReportByReporterId(String userId);
  Future<List<ReportModel>> getReportByReportedUserId(String userId);
  Future<void> deleteReport(String reportId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource{
  
    /// GET USER
    /// Get user by id
    @override
    Future<UserModel> getUser(String id) async {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
      return UserModel.fromFirestore(userDoc);
    }
  
    /// GET ALL USERS
    /// Get all users
    @override
    Future<List<UserModel>> getAllUsers() async {
      final usersDocs = await FirebaseFirestore.instance.collection('users').get();
      return usersDocs.docs.map((userDoc) => UserModel.fromFirestore(userDoc)).toList();
    }
  
    /// DELETE USER
    /// Delete user
    @override
    Future<void> deleteUser(String id) async {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
    }


  
    /// GET REPORT
    /// Get report by id
    @override
    Future<ReportModel> getReport(String id) async {
      final reportDoc = await FirebaseFirestore.instance.collection('reports').doc(id).get();
      return ReportModel.fromFirestore(reportDoc);
    }
  
    /// GET ALL REPORTS
    /// Get all reports
    @override
    Future<List<ReportModel>> getAllReports() async {
      final reportsDocs = await FirebaseFirestore.instance.collection('reports').get();
      return reportsDocs.docs.map((reportDoc) => ReportModel.fromFirestore(reportDoc)).toList();
    }
  
    /// GET REPORT BY REPORTER ID
    /// Get all reports by reporter id
    @override
    Future<List<ReportModel>> getReportByReporterId(String userId) async {
      final reportsDocs = await FirebaseFirestore.instance.collection('reports').where('reporterId', isEqualTo: userId).get();
      return reportsDocs.docs.map((reportDoc) => ReportModel.fromFirestore(reportDoc)).toList();
    }
  
    /// GET REPORT BY REPORTED USER ID
    /// Get all reports by reported user id
    @override
    Future<List<ReportModel>> getReportByReportedUserId(String userId) async {
      final reportsDocs = await FirebaseFirestore.instance.collection('reports').where('reportedUserId', isEqualTo: userId).get();
      return reportsDocs.docs.map((reportDoc) => ReportModel.fromFirestore(reportDoc)).toList();
    }
  
    /// DELETE REPORT
    /// Delete report
    @override
    Future<void> deleteReport(String reportId) async {
      await FirebaseFirestore.instance.collection('reports').doc(reportId).delete();
    }
}