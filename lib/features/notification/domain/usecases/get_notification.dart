import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class GetNotification implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotification(this.repository);

  @override
  Future<Result<List<NotificationEntity>>> call(NoParams params) async {
    return await repository.getNotificationData();
  }
}