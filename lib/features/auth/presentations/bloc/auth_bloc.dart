import 'package:flutter/widgets.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/show_snackbar.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in.dart';


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
  }

  void signInWithGoogle() async {

  }

  void signUp(String email, String password, String reenterPassword) async {
    if (password != reenterPassword){
      showSnackBar(context, "Re-entered password does not match.");
      return;
    }
    await UseCaseProvider.getUseCase<SignIn>().call(
      SignInParams(
        email: email,
        password: password,
      )
    );
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