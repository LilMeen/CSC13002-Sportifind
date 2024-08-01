import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference teamsCollection =
      FirebaseFirestore.instance.collection('teams');

}