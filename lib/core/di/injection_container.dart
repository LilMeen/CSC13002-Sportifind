import 'package:sportifind/core/di/comp/auth_injection_container.dart';
import 'package:sportifind/core/di/comp/match_injection_container.dart';
import 'package:sportifind/core/di/comp/profile_injection_containder.dart';
import 'package:sportifind/core/di/comp/stadium_injection_container.dart';
import 'package:sportifind/core/di/comp/team_injection_container.dart';

void initializeDependencies () {
  initializeAuthDependencies();
  initializeMatchDependencies();
  initializeProfileDependencies();
  initializeStadiumDependencies();
  initializeTeamDependencies();
}