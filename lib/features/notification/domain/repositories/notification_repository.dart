import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';

abstract interface class NotificationRepository {
  Future<Result<void>>                      updateNotificationAsRead(NotificationEntity notificationData);
  Future<Result<List<NotificationEntity>>>  getNotificationData();

  Future<Result<void>>                      inviteMatchRequest(senderId, receiverId, matchId);
  Future<Result<void>>                      joinMatchRequest(senderId, receiverId, matchId);
  Future<Result<void>>                      matchRequestAccepted(senderId, receiverId, matchId, status);
  Future<Result<void>>                      matchRequestDenied(senderId, receiverId, matchId);

  Future<Result<void>>                      sendUserRequest(userId, teamId);
  Future<Result<void>>                      sendTeamRequest(userId, teamId);
  Future<Result<void>>                      requestAccepted(userId, teamId);
  Future<Result<void>>                      requestDeniedFromTeam(userId, teamId);
  Future<Result<void>>                      requestDeniedFromUser(userId, teamId);

  Future<Result<void>>                      removePlayerFromTeam(userId, teamId, type);
}