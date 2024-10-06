abstract class Authstates {}

class LoginInitialState extends Authstates {}

class LoginLoadingState extends Authstates {}

class LoginSuccessState extends Authstates {
  final String message;

  LoginSuccessState(this.message);
}

class LoginErrorState extends Authstates {
  final String message;

  LoginErrorState(this.message);
}


class SignupLoadingState extends Authstates {}

class SignupSuccessState extends Authstates {
  final String message;
  SignupSuccessState(this.message);
}

class SignupErrorState extends Authstates {
  final String error;
  SignupErrorState(this.error);
}