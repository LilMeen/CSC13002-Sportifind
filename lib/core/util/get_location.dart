import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sportifind/core/entities/location.dart';

Location getLocation (double latitude, double longitude, String city, String district, String address) {
    const String apiKey = 'AIzaSyByB64x8WOemsLdnmypzU-sKNBTJeLS3Nw';
    final String searchText = '$latitude, $longitude';
    http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$searchText&key=$apiKey'),
    ).then((response) {
      if (response.statusCode == 200) {
        final searchRes = json.decode(response.body);

        if (searchRes['results'].isEmpty) {
          return Location(
            name: '',
            address: address,
            district: district,
            city: city,
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
          address: address,
          district: district,
          city: city,
        );
      } else {
        return Location(
          name: '',
          fullAddress: '',
          latitude: 0.0,
          longitude: 0.0,
          address: address,
          district: district,
          city: city,
        );
      }
    });
    throw UnimplementedError();
  }