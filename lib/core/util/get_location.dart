import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sportifind/core/entities/location.dart';
import 'package:location/location.dart' as loc;

const String apiKey = 'AIzaSyByB64x8WOemsLdnmypzU-sKNBTJeLS3Nw';

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

    return Location(
      name: searchRes['results'][0]['name'],
      fullAddress: searchRes['results'][0]['formatted_address'],
      latitude: searchLocation['lat'],
      longitude: searchLocation['lng'],
    );
  } else {
    return const Location(
      name: '',
      fullAddress: '',
      latitude: 0.0,
      longitude: 0.0,
    );
  }
}

Future<Location?> findLatAndLngFull(
  String address, String district, String city) async {
  String searchText = '$address, $district, $city';
  Location? searchLocation = await findLocation(searchText);

  if (searchLocation != null) {
    return Location(
      name: searchLocation.name,
      fullAddress: searchLocation.fullAddress,
      address: address,
      district: district,
      city: city,
      latitude: searchLocation.latitude,
      longitude: searchLocation.longitude,
    );
  }
  return null;
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

    return Location(
      name: searchRes['results'][0]['name'],
      fullAddress: searchRes['results'][0]['formatted_address'],
      latitude: searchLocation['lat'],
      longitude: searchLocation['lng'],
    );
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

        return Location(
          fullAddress: geocodeRes['results'][0]['formatted_address'],
          address: address,
          district: district,
          city: city,
          latitude: currentLocation.latitude!,
          longitude: currentLocation.longitude!,
        );
      }
    } else {
      return Location(
          latitude: currentLocation.latitude!,
          longitude: currentLocation.longitude!);
    }

    return null;
  }