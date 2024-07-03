import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart';

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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white,
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

List<QueryDocumentSnapshot> searchAndSortDocuments(
    List<QueryDocumentSnapshot> documents,
    String searchText,
    List<String> fields) {
  String handleFieldType(String str, String field) {
    if (field == 'email') {
      final atIndex = str.indexOf('@');
      if (atIndex != -1) {
        return str.substring(0, atIndex).toLowerCase();
      }
    }
    return str.toLowerCase();
  }

  final processedSearchText = handleFieldType(searchText, 'email');

  final List<Map<String, dynamic>> documentsWithSimilarity = [];

  for (var doc in documents) {
    double highestSimilarity = 0.0;
    bool containsSearchText = false;

    for (final field in fields) {
      final rawFieldValue = doc[field]?.toString() ?? '';
      final fieldValue = handleFieldType(rawFieldValue, field);
      final similarity = StringSimilarity.compareTwoStrings(processedSearchText, fieldValue);

      if (similarity > highestSimilarity) {
        highestSimilarity = similarity;
      }

      if (fieldValue.contains(processedSearchText)) {
        containsSearchText = true;
      }
    }

    if (highestSimilarity >= 0.3 || containsSearchText) {
      documentsWithSimilarity
          .add({'document': doc, 'similarity': highestSimilarity});
    }
  }

  documentsWithSimilarity
      .sort((a, b) => b['similarity'].compareTo(a['similarity']));

  final sortedDocuments = documentsWithSimilarity
      .map((entry) => entry['document'] as QueryDocumentSnapshot)
      .toList();

  return sortedDocuments;
}
