import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/widgets/custom_form_dropdown.dart';
import 'package:sportifind/core/widgets/general_dropdown.dart';

class CityDropdown extends StatefulWidget {
  final String selectedCity;
  final ValueChanged<String?> onChanged;
  final Color fillColor;
  final String type;
  final Map<String, String> citiesNameAndId;

  const CityDropdown({
    super.key,
    required this.selectedCity,
    required this.onChanged,
    required this.citiesNameAndId,
    this.fillColor = SportifindTheme.whiteSmoke,
    this.type = 'genearal',
  });

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  List<String> _cities = [];
  static List<String> _citiesCache = [];
  static Map<String, String> _citiesNameAndIdCache = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_citiesCache.isEmpty || _citiesNameAndIdCache.isEmpty) {
      _fetchCities();
    } else {
      setState(() {
        _cities = _citiesCache;
        widget.citiesNameAndId.addAll(_citiesNameAndIdCache);
      });
    }
  }

  String eraseType(String input) {
    final List<String> typesToRemove = [
      'Thanh pho ',
      'Tinh ',
    ];

    for (String type in typesToRemove) {
      input = input.replaceAll(type, '').trim();
    }

    return input.replaceAll(RegExp(r'\s+'), ' ');
  }


Future<void> _fetchCities() async {
  setState(() {
    _isLoading = true;
  });
  try {
    final response = await http.get(
      Uri.parse('https://provinces.open-api.vn/api/?depth=1'),
    );

    if (response.statusCode == 200) {
      final String utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(utf8Body);

      setState(() {
        for (var item in data) {
          final String cityName = eraseType(removeDiacritics(item['name'] as String));
          final String cityId = item['code'].toString(); // 'code' is the city's ID
          _cities.add(cityName);
          widget.citiesNameAndId[cityName] = cityId;
        }
        _citiesCache = _cities;
        _citiesNameAndIdCache = widget.citiesNameAndId;
      });
    } else {
      throw Exception('Failed to fetch cities');
    }
  } catch (error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
///////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'custom form') {
      return CustomFormDropdown(
        selectedValue: widget.selectedCity,
        hint: 'Select city',
        items: _cities,
        onChanged: widget.onChanged,
        fillColor: widget.fillColor,
        isLoading: _isLoading,
        validatorText: 'Please select the city',
      );
    }
    return GeneralDropdown(
      selectedValue: widget.selectedCity,
      hint: 'Select city',
      items: _cities,
      onChanged: widget.onChanged,
      fillColor: widget.fillColor,
      isLoading: _isLoading,
    );
  }
}
