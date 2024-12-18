import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:sportifind/api_key.dart';
import 'dart:convert';
import 'package:sportifind/core/entities/location.dart';
import 'package:location/location.dart' as loc;

const String apiKey = GOOGLE_MAPS_API_KEY;

Future<Location> getLocation (String searchText) async{
  http.Response response = http.Response('', 200);
  response = await http.get(
    Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$searchText&key=$apiKey'),
  );

  if (response.statusCode == 200) {
    final searchRes = json.decode(response.body);
    if (searchRes['results'].isEmpty) {
      return const Location(
        name: '',
        fullAddress: '',
        latitude: 0.0,
        longitude: 0.0,
      );
    }

    final searchLocation = searchRes['results'][0]['geometry']['location'];

    Location returnLocation = const Location();
    return returnLocation.copyWith(
      name: searchRes['results'][0]['name'],
      fullAddress: searchRes['results'][0]['formatted_address'],
      latitude: searchLocation['lat'],
      longitude: searchLocation['lng'],
    );
  } else {
    return const Location();
  }
}

Future<Location?> findLatAndLng(String district, String city) async {
  String searchText = '$district, $city';
  Location? searchLocation = await findLocation(searchText);

  if (searchLocation != null) {
    Location returnLocation = const Location();
    returnLocation = returnLocation.copyWith(
      name: searchLocation.name,
      fullAddress: searchLocation.fullAddress,
      district: district,
      city: city,
      latitude: searchLocation.latitude,
      longitude: searchLocation.longitude,
    );
    return returnLocation;
  }
  return Location(
    district: district,
    city: city,
  );
}

Future<Location> findLatAndLngFull(
  String address, String district, String city) async {
  String searchText = '$address, $district, $city';
  Location? searchLocation = await findLocation(searchText);

  if (searchLocation != null) {
    Location returnLocation = const Location();
    returnLocation = returnLocation.copyWith(
      name: searchLocation.name,
      fullAddress: searchLocation.fullAddress,
      address: address,
      district: district,
      city: city,
      latitude: searchLocation.latitude,
      longitude: searchLocation.longitude,
    );
    return returnLocation;
  }
  return Location(
    address: address,
    district: district,
    city: city,
  );
}


Future<Location?> findLocation(String searchText) async {
  final response = await http.get(
    Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$searchText&key=$apiKey'),
  );

  if (response.statusCode == 200) {
    final searchRes = json.decode(response.body);

    if (searchRes['results'].isEmpty) {
      return null;
    }

    final searchLocation = searchRes['results'][0]['geometry']['location'];
    Location returnLocation = const Location();
    returnLocation = returnLocation.copyWith(
      name: searchRes['results'][0]['name'],
      fullAddress: searchRes['results'][0]['formatted_address'],
      latitude: searchLocation['lat'],
      longitude: searchLocation['lng'],
    );
    return returnLocation;
  } else {
    return null;
  }
}

Future<Location?> getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    loc.LocationData currentLocation = await location.getLocation();

    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentLocation.latitude},${currentLocation.longitude}&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final geocodeRes = json.decode(response.body);

      if (geocodeRes['results'].isNotEmpty) {
        final addressComponents =
            geocodeRes['results'][0]['address_components'];

        String address = '';
        String district = '';
        String city = '';

        for (var component in addressComponents) {
          var types = component['types'];
          if (types.contains('street_number') ||
              types.contains('route') ||
              types.contains('neighborhood')) {
            address += '${component['long_name']}, ';
          } else if (types.contains('administrative_area_level_2')) {
            district = component['long_name'];
          } else if (types.contains('locality')) {
            city = component['long_name'];
          }
        }

        if (address.isNotEmpty) {
          address = address.substring(0, address.length - 2);
        }

        Location returnLocation = const Location();
        returnLocation = returnLocation.copyWith(
          fullAddress: geocodeRes['results'][0]['formatted_address'],
          address: address,
          district: district,
          city: city,
          latitude: currentLocation.latitude!,
          longitude: currentLocation.longitude!,
        );
        return returnLocation;
      }
    } else {
      return Location(
          latitude: currentLocation.latitude!,
          longitude: currentLocation.longitude!);
    }

    return null;
  }

double calculateDistance(Location loc1, Location loc2) {
  const double R = 6371; // Radius of the Earth in kilometers
  double dLat = _degToRad(loc2.latitude - loc1.latitude);
  double dLon = _degToRad(loc2.longitude - loc1.longitude);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(loc1.latitude)) *
          cos(_degToRad(loc2.latitude)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _degToRad(double deg) {
  return deg * (pi / 180);
}

void sortByDistance<T>(List<T> items, Location markedLocation,
    Location Function(T) getItemLocation) {
  items.sort((a, b) {
    double distanceA = calculateDistance(markedLocation, getItemLocation(a));
    double distanceB = calculateDistance(markedLocation, getItemLocation(b));
    return distanceA.compareTo(distanceB);
  });
}

