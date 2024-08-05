import 'package:sportifind/core/di/comp/auth_injection_container.dart';
import 'package:sportifind/core/di/comp/stadium_injection_container.dart';

void initializeDependencies () {
  initializeAuthDependencies();
  initializeStadiumDependencies();
}