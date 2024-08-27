import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:sportifind/features/notification/data/models/notification_model.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;

  NotificationRepositoryImpl({required this.notificationRemoteDataSource});

  @override
  Future<Result<void>> updateNotificationAsRead(NotificationEntity notificationData) async {
    await notificationRemoteDataSource.updateNotificationAsRead(NotificationModel.fromEntity(notificationData));
    return Result.success(null);
  }

  @override
  Future<Result<List<NotificationEntity>>> getNotificationData() async {
    final notificationData = await notificationRemoteDataSource.getNotificationData();
    return Result.success(notificationData.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Result<void>> inviteMatchRequest(senderId, receiverId, matchId) async {
    await notificationRemoteDataSource.inviteMatchRequest(senderId, receiverId, matchId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> joinMatchRequest(senderId, receiverId, matchId) async {
    await notificationRemoteDataSource.joinMatchRequest(senderId, receiverId, matchId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> matchRequestAccepted(senderId, receiverId, matchId, status) async {
    await notificationRemoteDataSource.matchRequestAccepted(senderId, receiverId, matchId, status);
    return Result.success(null);
  }

  @override
  Future<Result<void>> matchRequestDenied(senderId, receiverId, matchId) async {
    await notificationRemoteDataSource.matchRequestDenied(senderId, receiverId, matchId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> sendUserRequest(userId, teamId) async {
    await notificationRemoteDataSource.sendUserRequest(userId, teamId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> sendTeamRequest(userId, teamId) async {
    await notificationRemoteDataSource.sendTeamRequest(userId, teamId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> requestAccepted(userId, teamId) async {
    await notificationRemoteDataSource.requestAccepted(userId, teamId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> requestDeniedFromTeam(userId, teamId) async {
    await notificationRemoteDataSource.requestDeniedFromTeam(userId, teamId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> requestDeniedFromUser(userId, teamId) async {
    await notificationRemoteDataSource.requestDeniedFromUser(userId, teamId);
    return Result.success(null);
  }

  @override
  Future<Result<void>> removePlayerFromTeam(userId, teamId, type) async {
    await notificationRemoteDataSource.removePlayerFromTeam(userId, teamId, type);
    return Result.success(null);
  }

  @override
  Future<Result<void>> deleteMatch(senderId, receiverId, matchId) async {
    await notificationRemoteDataSource.deleteMatch(senderId, matchId);
    return Result.success(null);
  }
}