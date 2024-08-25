import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

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
      style: SportifindTheme.normalTextBlack,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: SportifindTheme.normalTextSmokeScreen,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: SportifindTheme.whiteSmoke,
        contentPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 18.0),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: SportifindTheme.smokeScreen),
                onPressed: searchController.clear,
              )
            : const Icon(Icons.search, color: SportifindTheme.smokeScreen),
      ),
    );
  }
}
