import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/widgets/dropdown_button/general_dropdown.dart';

class CityDropdown extends StatefulWidget {
  final String selectedCity;
  final ValueChanged<String?> onChanged;
  final Color fillColor;

  const CityDropdown({
    super.key,
    required this.selectedCity,
    required this.onChanged,
    this.fillColor = Colors.white,
  });

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  List<String> _cities = [];
  static final Map<String, List<String>> _cityCache = {};

  @override
  void initState() {
    super.initState();
    if (!_cityCache.containsKey('cities')) {
      _fetchCities();
    } else {
      setState(() {
        _cities = _cityCache['cities']!;
      });
    }
  }

  Future<void> _fetchCities() async {
    final citySnapshot =
        await FirebaseFirestore.instance.collection('location').get();
    final cities =
        citySnapshot.docs.map((doc) => doc['city'] as String).toList();
    _cityCache['cities'] = cities;
    setState(() {
      _cities = cities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GeneralDropdown(
      selectedValue: widget.selectedCity,
      hint: 'Select city',
      items: _cities,
      onChanged: widget.onChanged,
      fillColor: widget.fillColor,
    );
  }
}
