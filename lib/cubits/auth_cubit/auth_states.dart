import 'package:flutter/material.dart';
import '../../widgets/loadingIndicator.dart';
import '../../widgets/snackbar_helper.dart';

abstract class Authstates {
  void showSnackbar(BuildContext context) {

  }
}

class LoginInitialState extends Authstates {}

class LoginLoadingState extends Authstates {

}

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

class SendOtpLoadingState extends Authstates {}

class SendOtpSuccessState extends Authstates {
  final String otpHash;
  SendOtpSuccessState(this.otpHash);
  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Success', 'OTP sent successfully',
        isError: false);
  }
}

class SendOtpErrorState extends Authstates {
  final String error;
  SendOtpErrorState(this.error);
  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Error', this.error,
        isError: true);
  }
}

class VerifyOtpLoadingState extends Authstates {}
class VerifyOtpSuccessState extends Authstates {
  final String message;

  VerifyOtpSuccessState(this.message);

  // @override
  // void showSnackbar(BuildContext context) {
  //   showCustomSnackbar('Success', message, isError: false);
  // }
}
class VerifyOtpErrorState extends Authstates {
  final String error;
  VerifyOtpErrorState(this.error);

}