import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:sportifind/widgets/dropdown_button/general_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/stadium_form_dropdown.dart';

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
    this.fillColor = Colors.white,
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
      final response =
          await http.get(Uri.parse('https://vapi.vnappmob.com/api/province'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        setState(() {
          for (var item in data) {
            final String provinceName =
                eraseType(removeDiacritics(item['province_name'] as String));
            final String provinceId = item['province_id'] as String;
            _cities.add(provinceName);
            widget.citiesNameAndId[provinceName] = provinceId;
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

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'stadium form') {
      return StadiumFormDropdown(
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
