import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:uuid/uuid.dart';
//import 'package:intl/intl.dart';

//final formattedTime = DateFormat.Hm();

const uuid = Uuid();

class StadiumData {
  final String id;
  final String name;
  final String owner;
  final LocationInfo location;
  final String openTime;
  final String closeTime;
  final String phone;
  final double price;
  final int fields;

  StadiumData({
    required this.name,
    required this.owner,
    required this.location,
    required this.openTime,
    required this.closeTime,
    required this.phone,
    required this.price,
    required this.fields,
  }) : id = uuid.v4();

  StadiumData.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        owner = snapshot['owner'],
        location = LocationInfo(
          address: snapshot['address'],
          district: snapshot['district'],
          city: snapshot['city'],
          latitude: 10.762622 + snapshot['name'].length / 20,
          longitude: 106.660172+ snapshot['address'].length / 40,
        ),
        openTime = snapshot['open_time'],
        closeTime = snapshot['close_time'],
        phone = snapshot['phone_number'],
        price = snapshot['price_per_hour'],
        fields = snapshot['number_of_fields'];

  get avatar =>
      'https://bizweb.dktcdn.net/100/017/070/files/kich-thuoc-san-bong-da-1-jpeg.jpg?v=1671246300021';

  get images => [
        'https://sonsanepoxy.vn/wp-content/uploads/2023/08/kich-thuoc-san-bong-da-1.jpg',
        'https://www.sanbongro.com.vn/uploads/supply/2019/01/07/thi_cong_san_bong_da_mini_5_nguoi_tiet_kiem.jpg',
        'https://yousport.vn/Media/Articles/080321051105526/nhung-mat-san-bong-da-pho-bien-nhat-hien-nay-banner.jpg'
      ];
}
