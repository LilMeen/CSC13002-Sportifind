import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/widgets/dropdown_button/general_dropdown.dart';


class DistrictDropdown extends StatefulWidget {
  final String selectedCity;
  final String selectedDistrict;
  final ValueChanged<String?> onChanged;
  final Color fillColor;

  const DistrictDropdown({
    super.key,
    required this.selectedCity,
    required this.selectedDistrict,
    required this.onChanged,
    this.fillColor = Colors.white,
  });

  @override
  State<DistrictDropdown> createState() => _DistrictDropdownState();
}

class _DistrictDropdownState extends State<DistrictDropdown> {
  List<String> _districts = [];

  @override
  void didUpdateWidget(covariant DistrictDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCity != widget.selectedCity) {
      _fetchDistricts(widget.selectedCity);
    }
  }

  Future<void> _fetchDistricts(String city) async {
    if (city.isEmpty) {
      setState(() {
        _districts.clear();
      });
      return;
    }
    final cityDoc = await FirebaseFirestore.instance
        .collection('location')
        .where('city', isEqualTo: city)
        .limit(1)
        .get();
    if (cityDoc.docs.isNotEmpty) {
      final districtSnapshot = await FirebaseFirestore.instance
          .collection('location')
          .doc(cityDoc.docs.first.id)
          .collection('district')
          .get();
      setState(() {
        _districts =
            districtSnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GeneralDropdown(
      selectedValue: widget.selectedDistrict,
      hint: 'Select district',
      items: _districts,
      onChanged: widget.onChanged,
      fillColor: widget.fillColor,
    );
  }
}
