import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/widgets/dropdown_button/general_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/custom_form_dropdown.dart';

class DistrictDropdown extends StatefulWidget {
  final String selectedCity;
  final String selectedDistrict;
  final ValueChanged<String?> onChanged;
  final Map<String, String> citiesNameAndId;
  final Color fillColor;
  final String type;

  const DistrictDropdown({
    super.key,
    required this.selectedCity,
    required this.citiesNameAndId,
    required this.selectedDistrict,
    required this.onChanged,
    this.fillColor = SportifindTheme.whiteSmoke,
    this.type = 'general',
  });

  @override
  State<DistrictDropdown> createState() => _DistrictDropdownState();
}

class _DistrictDropdownState extends State<DistrictDropdown> {
  List<String> _districts = [];
  bool _isLoading = false;
  Map<String, String> aaa = {};

  @override
  void didUpdateWidget(covariant DistrictDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCity != widget.selectedCity) {
      _fetchDistricts(widget.selectedCity);
    }
  }

  String eraseType(String input) {
    final List<String> typesToRemove = [
      'Huyen ',
      'Quan ',
      'Thi xa ',
      'Thanh pho ',
    ];

    for (String type in typesToRemove) {
      input = input.replaceAll(type, '').trim();
    }

    return input.replaceAll(RegExp(r'\s+'), ' ');
  }

  Future<void> _fetchDistricts(String city) async {
    setState(() {
      _isLoading = true;
      _districts.clear();
    });

    if (city.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          'https://vapi.vnappmob.com/api/province/district/${widget.citiesNameAndId[city]}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        setState(() {
          _districts = data
              .map((item) =>
                  eraseType(removeDiacritics(item['district_name'] as String)))
              .toList();
        });
      } else {
        throw Exception('Failed to fetch districts');
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
    if (widget.type == 'custom form') {
      return CustomFormDropdown(
        selectedValue: widget.selectedDistrict,
        hint: 'Select district',
        items: _districts,
        onChanged: widget.onChanged,
        fillColor: widget.fillColor,
        isLoading: _isLoading,
        validatorText: 'Please select the district',
      );
    }

    return GeneralDropdown(
      selectedValue: widget.selectedDistrict,
      hint: 'Select district',
      items: _districts,
      onChanged: widget.onChanged,
      fillColor: widget.fillColor,
      isLoading: _isLoading,
    );
  }
}
