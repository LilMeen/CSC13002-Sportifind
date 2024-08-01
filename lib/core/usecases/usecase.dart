import 'package:sportifind/core/models/result.dart';

abstract interface class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

class NoParams {}
