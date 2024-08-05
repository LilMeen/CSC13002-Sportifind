import 'package:sportifind/features/stadium/domain/entities/field.dart';

class FieldModel {
  final String id;
  final String numberId;
  final String type;
  final double price;
  final bool status;

  FieldModel({
    required this.id,
    required this.numberId,
    required this.type,
    required this.price,
    required this.status,
  });

  factory FieldModel.fromMap(Map<String, dynamic> map) {
    return FieldModel(
      id: map['id'] ?? '',
      numberId: map['numberId'] ?? '',
      type: map['type'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      status: map['status'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numberId': numberId,
      'type': type,
      'price': price,
      'status': status,
    };
  }

  Field toEntity() {
    return Field(
      id: id,
      numberId: numberId,
      type: type,
      price: price,
      status: status,
    );
  }

  factory FieldModel.fromEntity(Field entity) {
    return FieldModel(
      id: entity.id,
      numberId: entity.numberId,
      type: entity.type,
      price: entity.price,
      status: entity.status,
    );
  }
}