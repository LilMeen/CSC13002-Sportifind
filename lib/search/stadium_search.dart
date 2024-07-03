import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:sportifind/search/search.dart';
import 'package:sportifind/widgets/dropdown_button/city_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/district_dropdown.dart';

class StadiumSearch extends StatefulWidget {
  final Stream<QuerySnapshot> stream;
  final GridView Function(List<DocumentSnapshot>) buildGridView;

  const StadiumSearch({
    super.key,
    required this.stream,
    required this.buildGridView,
  });

  @override
  State<StadiumSearch> createState() => _StadiumSearchState();
}

class _StadiumSearchState extends State<StadiumSearch> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _selectedCity = '';
  String _selectedDistrict = '';
  final List<String> _searchFields = ['name'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(
                  searchController: _searchController,
                  hintText: 'Stadium name',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CityDropdown(
                        selectedCity: _selectedCity,
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value ?? '';
                            _selectedDistrict = '';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: DistrictDropdown(
                        selectedCity: _selectedCity,
                        selectedDistrict: _selectedDistrict,
                        onChanged: (value) {
                          setState(() {
                            _selectedDistrict = value ?? '';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: widget.stream,
                  builder: (ctx, stadiumSnapshot) {
                    if (stadiumSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (stadiumSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${stadiumSnapshot.error}'));
                      //return const Center(child: Text('Something went wrong. Please try again later.'));
                    }

                    final stadiums = stadiumSnapshot.data!.docs;
                    var filteredStadiums = stadiums.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final matchesCity = _selectedCity.isEmpty ||
                          data['city'] == _selectedCity;
                      final matchesDistrict = _selectedDistrict.isEmpty ||
                          data['district'] == _selectedDistrict;
                      return matchesCity && matchesDistrict;
                    }).toList();
                    filteredStadiums = searchAndSortDocuments(
                        filteredStadiums, _searchText, _searchFields);

                    if (filteredStadiums.isEmpty) {
                      return const Center(child: Text('No stadiums found.'));
                    }

                    return widget.buildGridView(filteredStadiums);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
