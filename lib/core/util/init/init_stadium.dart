import 'package:cloud_firestore/cloud_firestore.dart';

void initStadium (String id) async {
  final stadiumsData = FirebaseFirestore.instance.collection('stadiums');
  await stadiumsData.doc(id).set({
    'name': '',
    'owner': '',
    'avatar': '',
    'images': [],
    'city': '',
    'district': '',
    'address': '',
    'open_time': '',
    'close_time': '',
    'phone_number': '',
    'longitude': 0.0,
    'latitude': 0.0,
  });
}