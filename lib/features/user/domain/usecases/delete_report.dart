import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/user/domain/repositories/user_repository.dart';

class DeleteReport implements UseCase<void, DeleteReportParams> {
  final UserRepository userRepository;

  DeleteReport(this.userRepository);

  @override
  Future<Result<void>> call(DeleteReportParams params) async {
    return await userRepository.deleteReport(params.reportId);
  }
}

class DeleteReportParams {
  final String reportId;

  DeleteReportParams({required this.reportId});
}