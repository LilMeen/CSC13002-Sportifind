import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class MarkAsRead implements UseCase<void, MarkAsReadParams> {
  final NotificationRepository repository;

  MarkAsRead(this.repository);

  @override
  Future<Result<void>> call(MarkAsReadParams params) async {
    return await repository.updateNotificationAsRead(params.notification);
  }
}

class MarkAsReadParams {
  final NotificationEntity notification;

  MarkAsReadParams({required this.notification});
}