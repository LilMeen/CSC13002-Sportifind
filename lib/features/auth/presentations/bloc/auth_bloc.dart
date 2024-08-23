// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/show_snackbar.dart';
import 'package:sportifind/features/auth/domain/usecases/forgot_password.dart';
import 'package:sportifind/features/auth/domain/usecases/set_basic_info.dart';
import 'package:sportifind/features/auth/domain/usecases/set_role.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_out.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_up.dart';
import 'package:sportifind/features/auth/presentations/screens/basic_info_screen.dart';
import 'package:sportifind/features/profile/domain/usecases/get_current_profile.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/home/admin_home_screen.dart';
import 'package:sportifind/features/auth/presentations/screens/role_screen.dart';
import 'package:sportifind/home/player_home_screen.dart';
import 'package:sportifind/home/stadium_owner_home_screen.dart';



class AuthBloc {
  BuildContext context;
  AuthBloc(this.context);

  Future<void> signIn(String email, String password, {bool rememberMe = false}) async {
    final result = await UseCaseProvider.getUseCase<SignIn>().call(
      SignInParams(
        email: email,
        password: password,
      )
    );
    if (result.isSuccess == false){
      showSnackBar(context, result.message);
    }
    else {
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);
      }

      if (result.message == "admin") {
        Navigator.of(context).pushReplacement(AdminHomeScreen.route());
      }
      else if (result.message == "player") {
        Navigator.of(context).pushReplacement(PlayerHomeScreen.route());
      }
      else if (result.message == "stadium_owner") {
        Navigator.of(context).pushReplacement(StadiumOwnerHomeScreen.route());
      }
    }
  }
  

  Future<void> signInWithGoogle() async {
    final result = await UseCaseProvider.getUseCase<SignInWithGoogle>().call(
      NoParams()
    );

    if (result.isSuccess == false){
      showSnackBar(context, result.message);
    }
    else {
      if (result.message == "player") {
        Navigator.of(context).pushReplacement(PlayerHomeScreen.route());
      }
      else if (result.message == "stadium_owner") {
        Navigator.of(context).pushReplacement(StadiumOwnerHomeScreen.route());
      }
      else {
        Navigator.of(context).pushReplacement(RoleScreen.route());
      }
    }

  }

  Future<bool> checkStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');

    if (storedEmail != null && storedPassword != null) {
      signIn(storedEmail, storedPassword);
      return true;
    }
    return false;
  }

  Future<void> signUp(String email, String password, String reenterPassword) async {
    if (password != reenterPassword){
      showSnackBar(context, "Re-entered password does not match.");
      return;
    }
    final result = await UseCaseProvider.getUseCase<SignUp>().call(
      SignUpParams(
        email: email,
        password: password,
      )
    );
    if (result.isSuccess == false){
      showSnackBar(context, result.message);
    } else {
      Navigator.of(context).pushReplacement(RoleScreen.route());
    }
  }


  Future<void> signOut() async{
    await UseCaseProvider.getUseCase<SignOut>().call(
      NoParams()
    );
  }


  Future<void> forgotPassword(String email) async {
    await UseCaseProvider.getUseCase<ForgotPassword>().call(
      ForgotPasswordParams(
        email: email,
      )
    );
  }


  Future<void> setRole(String role) async{
    await UseCaseProvider.getUseCase<SetRole>().call(
      SetRoleParams(
        role: role,
      )
    );
    Navigator.of(context).pushReplacement(BasicInfoScreen.route());
  }


  Future<void> setBasicInfo ({
    required String name,
    required String dob,
    required String gender,
    required String city,
    required String district,
    required String address,
    required String phone
  }) async {
    await UseCaseProvider.getUseCase<SetBasicInfo>().call(
      SetBasicInfoParams(
        name: name,
        phone: phone,
        dob: dob,
        address: address,
        gender: gender,
        city: city,
        district: district,
      ),
    );
    UserEntity user = await UseCaseProvider.getUseCase<GetCurrentProfile>().call(
      NoParams(),
    ).then((value) => value.data!);
    if (user.role == 'player') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlayerHomeScreen())
      );
    } else if (user.role == 'stadium_owner') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StadiumOwnerHomeScreen())
      );
    }
  } 
}

  