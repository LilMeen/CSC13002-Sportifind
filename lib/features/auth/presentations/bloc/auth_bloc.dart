// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
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
import 'package:sportifind/home/admin_home_screen.dart';
import 'package:sportifind/features/auth/presentations/screens/role_screen.dart';
import 'package:sportifind/home/player_home_screen.dart';
import 'package:sportifind/home/stadium_owner_home_screen.dart';



class AuthBloc {
  BuildContext context;
  AuthBloc(this.context);

  void signIn(String email, String password) async {
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
  

  void signInWithGoogle() async {
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


  void signUp(String email, String password, String reenterPassword) async {
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


  void signOut() async{
    await UseCaseProvider.getUseCase<SignOut>().call(
      NoParams()
    );
  }


  void forgotPassword(String email) async {
    await UseCaseProvider.getUseCase<ForgotPassword>().call(
      ForgotPasswordParams(
        email: email,
      )
    );
  }


  void setRole(String role) async{
    await UseCaseProvider.getUseCase<SetRole>().call(
      SetRoleParams(
        role: role,
      )
    );
    Navigator.of(context).pushReplacement(BasicInfoScreen.route());
  }


  void setBasicInfo (
    String name,
    String dob,
    String gender,
    String city,
    String district,
    String address,
    String phone
  ) async {
    await UseCaseProvider.getUseCase<SetBasicInfo>().call(
      SetBasicInfoParams(
        name: name,
        dob: dob,
        gender: gender,
        city: city,
        district: district,
        address: address,
        phone: phone,
      )
    );
  }
}