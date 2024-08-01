import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportifind/core/models/result.dart';

class SetBasicInfo implements UseCase<void, SetBasicInfoParams> {
  final AuthRepository repository;

  SetBasicInfo(this.repository);

  @override
  Future<Result<void>> call(SetBasicInfoParams params) async {
    return await repository.setBasicInfo(
      params.name,
      params.dob,
      params.gender,
      params.city,
      params.district,
      params.address,
      params.phone,
    );
  }
}

class SetBasicInfoParams {
  final String name;
  final String dob;
  final String gender;
  final String city;
  final String district;
  final String address;
  final String phone;

  SetBasicInfoParams({
    required this.name,
    required this.dob,
    required this.gender,
    required this.city,
    required this.district,
    required this.address,
    required this.phone,
  });
}
