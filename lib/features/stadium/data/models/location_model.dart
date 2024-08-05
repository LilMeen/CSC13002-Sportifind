
import 'package:sportifind/features/stadium/domain/entities/location.dart';

class LocationModel {
  final String name;
  final String city;
  final String district;
  final String address;
  final double latitude;
  final double longitude;
  final String fullAddress;

  LocationModel({
    required this.name,
    required this.city,
    required this.district,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      fullAddress: map['fullAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'district': district,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
    };
  }

  Location toEntity() {
    return Location(
      name: name,
      city: city,
      district: district,
      address: address,
      latitude: latitude,
      longitude: longitude,
      fullAddress: fullAddress,
    );
  }

  factory LocationModel.fromEntity(Location entity) {
    return LocationModel(
      name: entity.name,
      city: entity.city,
      district: entity.district,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      fullAddress: entity.fullAddress,
    );
  }
}