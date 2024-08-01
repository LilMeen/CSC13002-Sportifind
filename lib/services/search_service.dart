import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:string_similarity/string_similarity.dart';

class SearchService {
  List<QueryDocumentSnapshot> searchAndSortDocuments(
    List<QueryDocumentSnapshot> documents,
    String searchText,
    List<String> fields,
  ) {
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
        final similarity =
            StringSimilarity.compareTwoStrings(processedSearchText, fieldValue);

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

  List<T> searchTextMatch<T>(
      String searchText, List<T> items, String Function(T) getName) {
    List<T> matchedItems = [];

    for (var item in items) {
      final itemText = getName(item).toLowerCase();
      final similarity = StringSimilarity.compareTwoStrings(
          searchText.toLowerCase(), itemText);

      if (similarity >= 0.3 || itemText.contains(searchText.toLowerCase())) {
        matchedItems.add(item);
      }
    }

    matchedItems.sort((a, b) {
      final similarityA = StringSimilarity.compareTwoStrings(
          searchText.toLowerCase(), getName(a).toLowerCase());
      final similarityB = StringSimilarity.compareTwoStrings(
          searchText.toLowerCase(), getName(b).toLowerCase());
      return similarityB
          .compareTo(similarityA); // Sort in descending order of similarity
    });

    return matchedItems;
  }

  List<T> searchingNameAndLocation<T>({
    required List<T> listItems,
    required String searchText,
    required String selectedCity,
    required String selectedDistrict,
    required String Function(T) getNameOfItem,
    required LocationInfo Function(T) getLocationOfItem,
  }) {
    List<T> searchedItems = searchTextMatch(
      searchText,
      listItems,
      getNameOfItem,
    );

    searchedItems = searchedItems.where((item) {
      final matchCity =
          selectedCity.isEmpty || getLocationOfItem(item).city == selectedCity;
      final matchDistrict = selectedDistrict.isEmpty ||
          getLocationOfItem(item).district == selectedDistrict;
      return matchCity && matchDistrict;
    }).toList();

    return searchedItems;
  }
}
