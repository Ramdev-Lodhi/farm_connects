// sell_state.dart
import 'package:flutter/cupertino.dart';

import '../../widgets/snackbar_helper.dart';

abstract class RentStates {
  void showSnackbar(BuildContext context) {

  }
}
class RentFormInitial extends RentStates {
  RentFormInitial();
}
class RentFormLoading extends RentStates {
  RentFormLoading();
}
class RentFormSubmitting extends RentStates {
  RentFormSubmitting();
}

class RentMultiFormSubmitting extends RentStates {}
class RentImageLoading extends RentStates {}
class RentLoading extends RentStates {}

class RentFormSuccess extends RentStates {
  final String message;

  RentFormSuccess(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Success', message, isError: false);
  }
}

class RentFormError extends RentStates {
  final String error;
  RentFormError(this.error);
  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Error', error, isError: true);

  }
}