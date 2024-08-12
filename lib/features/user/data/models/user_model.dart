import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String role;
  final String dob;
  final String gender;
  final String phone;
  final String city;
  final String district;
  final String address;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.role,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.city,
    required this.district,
    required this.address,
  });

  factory UserModel.fromFirestore(DocumentSnapshot userDoc) {
    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

    return UserModel(
      id: userDoc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      avatar: data['avatarImage'] ?? '',
      role: data['role'] ?? '',
      dob: data['dob'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'avatarImage': avatar,
      'role': role,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'city': city,
      'district': district,
      'address': address,
    };
  }

  Future<UserEntity> toEntity() async {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      avatar: File(avatar),
      role: role,
      dob: dob,
      gender: gender,
      phone: phone,
      location: Location(city: city, district: district, address: address),
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar.path,
      role: entity.role,
      dob: entity.dob,
      gender: entity.gender,
      phone: entity.phone,
      city: entity.location.city,
      district: entity.location.district,
      address: entity.location.address,
    );
  }
}

