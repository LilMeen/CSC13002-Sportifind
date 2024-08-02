import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class SearchStadium implements UseCase<List<Stadium>, SearchStadiumParams> {
  final StadiumRepository repository;
  SearchStadium(this.repository);

  @override
  Future<Result<List<Stadium>>> call(SearchStadiumParams params) async {
    return repository.performStadiumSearch(
      stadiums: params.stadiums,
      searchText: params.searchText,
      selectedCity: params.selectedCity,
      selectedDistrict: params.selectedDistrict,
    );
  }
}

class SearchStadiumParams {
  final List<Stadium> stadiums;
  final String searchText;
  final String selectedCity;
  final String selectedDistrict;

  SearchStadiumParams({
    required this.stadiums,
    required this.searchText,
    required this.selectedCity,
    required this.selectedDistrict,
  });
}