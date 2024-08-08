import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/stadium/domain/entities/field.dart';

class FieldModel {
  final String id;
  final int numberId;
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

  factory FieldModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FieldModel(
      id: doc.id,
      numberId: data['numberId'] ?? 0,
      type: data['type'] ?? '',
      price: data['price_per_hour'] ?? 0,
      status: data['status'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'numberId': numberId,
      'type': type,
      'price_per_hour': price,
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