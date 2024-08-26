import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/user/data/datasources/user_remote_data_source.dart';
import 'package:sportifind/features/user/data/models/report_model.dart';
import 'package:sportifind/features/user/data/models/user_model.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/features/user/domain/entities/report_entity.dart';
import 'package:sportifind/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  final ProfileRemoteDataSource profileRemoteDataSource;
  final TeamRemoteDataSource teamRemoteDataSource;
  final MatchRemoteDataSource matchRemoteDataSource;
  final StadiumRemoteDataSource stadiumRemoteDataSource;

  UserRepositoryImpl({
    required this.userRemoteDataSource,
    required this.profileRemoteDataSource,
    required this.teamRemoteDataSource,
    required this.matchRemoteDataSource,
    required this.stadiumRemoteDataSource,
  });


  // USER
  @override
  Future<Result<UserEntity>> getUser(String id) async {
    UserEntity userEntity =  await userRemoteDataSource.getUser(id).then((value) => value.toEntity());
    return Result.success(userEntity);
  }

  @override
  Future<Result<List<UserEntity>>> getAllUsers() async {
    List<UserEntity> userEntityList = [];
    List<UserModel> usersModel = await userRemoteDataSource.getAllUsers();
    for (var user in usersModel) {
      UserEntity userEntity = await user.toEntity();
      userEntityList.add(userEntity);
    }
    return Result.success(userEntityList);
  }

  @override
  Future<Result<void>> deleteUser(UserEntity user) async {
    ProfileRepositoryImpl profileRepositoryImpl = ProfileRepositoryImpl(
      profileRemoteDataSource: profileRemoteDataSource,
      teamRemoteDataSource: teamRemoteDataSource,
      matchRemoteDataSource: matchRemoteDataSource,
      stadiumRemoteDataSource: stadiumRemoteDataSource,
    );
    if (user.role == 'player'){
      await profileRepositoryImpl.deletePlayer(user.id);
    }
    else if (user.role == 'stadium_owner'){
      await profileRemoteDataSource.deleteStadiumOwner(user.id);
    }
    else {
      await userRemoteDataSource.deleteUser(user.id);
    }
    return Result.success(null);
  }

  // REPORT
  @override
  Future<Result<ReportEntity>> getReport(String id) async {
    ReportEntity reportEntity = await userRemoteDataSource.getReport(id).then((value) => value.toEntity());
    return Result.success(reportEntity);
  }

  @override
  Future<Result<List<ReportEntity>>> getAllReports() async {
    List<ReportEntity> reportEntityList = [];
    List<ReportModel> reportsModel = await userRemoteDataSource.getAllReports();
    for (var report in reportsModel) {
      ReportEntity reportEntity = await report.toEntity();
      reportEntityList.add(reportEntity);
    }
    return Result.success(reportEntityList);
  }

  @override
  Future<Result<List<ReportEntity>>> getReportByReporterId(String userId) async {
    List<ReportEntity> reportEntityList = [];
    List<ReportModel> reportsModel = await userRemoteDataSource.getReportByReporterId(userId);
    for (var report in reportsModel) {
      ReportEntity reportEntity = await report.toEntity();
      reportEntityList.add(reportEntity);
    }
    return Result.success(reportEntityList);
  }

  @override
  Future<Result<List<ReportEntity>>> getReportByReportedUserId(String userId) async {
    List<ReportEntity> reportEntityList = [];
    List<ReportModel> reportsModel = await userRemoteDataSource.getReportByReportedUserId(userId);
    for (var report in reportsModel) {
      ReportEntity reportEntity = await report.toEntity();
      reportEntityList.add(reportEntity);
    }
    return Result.success(reportEntityList);
  }

  @override
  Future<Result<void>> deleteReport(String reportId) async {
    await userRemoteDataSource.deleteReport(reportId);
    return Result.success(null);
  }
}