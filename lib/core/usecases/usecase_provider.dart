import 'package:sportifind/core/usecases/usecase.dart';
import 'package:get_it/get_it.dart';

class UseCaseProvider {
  static T getUseCase<T extends UseCase>() {
    return GetIt.I<T>();
  }
}