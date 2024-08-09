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
      params.stadiums,
      params.searchText,
      params.selectedCity,
      params.selectedDistrict
    );
  }
}

class SearchStadiumParams {
  final List<Stadium> stadiums;
  final String searchText;
  final String selectedCity;
  final String selectedDistrict;

  SearchStadiumParams(
    this.stadiums,
    this.searchText,
    this.selectedCity,
    this.selectedDistrict
  );
}