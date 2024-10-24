import 'package:flutter/material.dart';
import '../../widgets/snackbar_helper.dart';

abstract class Authstates {
  void showSnackbar(BuildContext context) {

  }
}

class LoginInitialState extends Authstates {}

class LoginLoadingState extends Authstates {}

class LoginSuccessState extends Authstates {
  final String message;

  LoginSuccessState(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Login Successful', message, isError: false);
  }
}

class LoginErrorState extends Authstates {
  final String message;

  LoginErrorState(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Login Failed', message, isError: true);
    print("emitcalling");
  }
}

class SignupLoadingState extends Authstates {}

class SignupSuccessState extends Authstates {
  final String message;

  SignupSuccessState(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Signup Successful', message, isError: false);
  }
}

class SignupErrorState extends Authstates {
  final String error;

  SignupErrorState(this.error);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Signup Failed', error, isError: true);
  }
}
