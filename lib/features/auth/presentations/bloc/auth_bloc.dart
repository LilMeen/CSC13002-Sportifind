import 'package:flutter/widgets.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/show_snackbar.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_up.dart';
import 'package:sportifind/screens/admin/admin_home_screen.dart';
import 'package:sportifind/screens/auth/role_screen.dart';
import 'package:sportifind/screens/player/player_home_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium_owner_home_screen.dart';



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
      print(result.message);
      showSnackBar(context, result.message);
    }
    else {
      if (result.message == "admin") {
        AdminHomeScreen.route();
      }
      else if (result.message == "player") {
        PlayerHomeScreen.route();
      }
      else if (result.message == "stadium_owner") {
        StadiumOwnerHomeScreen.route();
      }
    }
  }
  

  void signInWithGoogle() async {
    await UseCaseProvider.getUseCase<SignInWithGoogle>().call(
      NoParams()
    );

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
      print(result.message);
      showSnackBar(context, result.message);
    } else {
      Navigator.of(context).pushReplacement(RoleScreen.route());
    }
  }

  void signOut(){

  }

  void forgotPassword(String email) {

  }

  void setRole(String role){

  }

  void setBasicInfo(
    String name,
    String dob,
    String gender,
    String city,
    String district,
    String address,
    String phone
  ){

  }
}