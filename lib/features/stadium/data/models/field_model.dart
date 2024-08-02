import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/stadium/domain/entities/field.dart';

class FieldModel extends Field {
  FieldModel({
    required super.id,
    required super.numberId,
    required super.type,
    required super.price,
    required super.status,
  });

  factory FieldModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data()!;

    return FieldModel(
      id: snapshot.id,
      numberId: data['number_id'],
      type: data['type'],
      price: data['price'],
      status: data['status'],
    );
  }
}
