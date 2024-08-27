import 'package:sportifind/features/user/domain/entities/user_entity.dart';

class MessageEntity {
  UserEntity sender;
  String message;
  DateTime time;

  MessageEntity({
    required this.sender, 
    required this.message, 
    required this.time
  });
}