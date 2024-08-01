import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/di/injection_container.dart';
class UseCaseProvider {
  static T getUseCase<T extends UseCase>() {
    return sl<T>();
  }
}