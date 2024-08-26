import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/user/domain/repositories/user_repository.dart';

class GetReport implements UseCase<void, GetReportParams> {
  final UserRepository userRepository;

  GetReport( this.userRepository);

  @override
  Future<Result<void>> call(GetReportParams params) async {
    return await userRepository.getReport(params.reportId);
  }
}

class GetReportParams {
  final String reportId;

  GetReportParams({required this.reportId});
}