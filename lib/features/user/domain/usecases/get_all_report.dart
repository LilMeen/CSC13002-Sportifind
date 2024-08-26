import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/user/domain/entities/report_entity.dart';
import 'package:sportifind/features/user/domain/repositories/user_repository.dart';

class GetAllReport implements UseCase<List<ReportEntity>, NoParams> {
  final UserRepository userRepository;

  GetAllReport(
    this.userRepository
  );

  @override
  Future<Result<List<ReportEntity>>> call(NoParams params) async {
    return await userRepository.getAllReports();
  }
}