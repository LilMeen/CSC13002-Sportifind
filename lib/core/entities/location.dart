class Location {
  final String name;
  final String address;
  final String district;
  final String city;
  final double latitude;
  final double longitude;
  final String fullAddress;

  const Location({
    this.name = '',
    this.address = '',
    this.district = '',
    this.city = '',
    this.latitude = 0,
    this.longitude = 0,
    this.fullAddress = '',
  });

  Location copyWith({
    String? name,
    String? address,
    String? district,
    String? city,
    double? latitude,
    double? longitude,
    String? fullAddress,
  }) {
    return Location(
      name: name ?? this.name,
      address: address ?? this.address,
      district: district ?? this.district,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }
}