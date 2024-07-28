import 'package:cloud_firestore/cloud_firestore.dart';

class FieldData {
  final String id;
  final int numberId;
  final String type;
  final double price;
  final bool status;

  FieldData({
    required this.id,
    required this.numberId,
    required this.type,
    required this.price,
    required this.status,
  });

  FieldData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        numberId = snapshot['numberId'],
        type = snapshot['type'],
        price = snapshot['price_per_hour'],
        status = snapshot['status'];
}
