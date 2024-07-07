import 'package:flutter/material.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'dart:async';
import 'package:sportifind/search/search.dart';
import 'package:sportifind/widgets/card/stadium_card.dart';
import 'package:sportifind/widgets/dropdown_button/city_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/district_dropdown.dart';

class StadiumSearchScreen extends StatefulWidget {
  final int gridCol;
  final double gridRatio;
  final List<StadiumData> stadiums;
  final List<OwnerData> owners;

  const StadiumSearchScreen({
    super.key,
    required this.gridCol,
    required this.gridRatio,
    required this.stadiums,
    required this.owners,
  });

  @override
  State<StadiumSearchScreen> createState() => _StadiumSearchScreenState();
}

class _StadiumSearchScreenState extends State<StadiumSearchScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _selectedCity = '';
  String _selectedDistrict = '';
  List<StadiumData> filteredStadiums = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchText = _searchController.text;
    filteredStadiums = widget.stadiums;
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = _searchController.text;
        _performSearch();
      });
    });
  }

  void _performSearch() {
    filteredStadiums = searchingStadiums(
      stadiums: widget.stadiums,
      searchText: _searchText,
      selectedCity: _selectedCity,
      selectedDistrict: _selectedDistrict,
    );
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
                            _performSearch();
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
                            _performSearch();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: filteredStadiums.isEmpty
                    ? const Center(child: Text('No stadiums found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.gridCol,
                          childAspectRatio: widget.gridRatio,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: filteredStadiums.length,
                        itemBuilder: (ctx, index) {
                          final stadium = filteredStadiums[index];
                          String ownerName = 'Unknonw';

                          for (var i = 0; i < widget.owners.length; ++i) {
                            if (widget.owners[i].id == stadium.owner) {
                              ownerName = widget.owners[i].name;
                              break;
                            }
                          }
                          
                          return StadiumCard(
                            stadium: stadium,
                            ownerName: ownerName,
                          );
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
