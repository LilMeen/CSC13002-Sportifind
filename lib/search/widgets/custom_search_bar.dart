import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.searchController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: SportifindTheme.normalTextSmokeScreen,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        filled: true,
        fillColor: SportifindTheme.whiteSmoke,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: searchController.clear,
              )
            : null,
      ),
    );
  }
}

