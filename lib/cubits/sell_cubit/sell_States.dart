import 'package:flutter/cupertino.dart';

import '../../widgets/snackbar_helper.dart';

abstract class SellFormState {
  void showSnackbar(BuildContext context) {

  }
}

class SellFormInitial extends SellFormState {
  SellFormInitial();
}

class SellFormLoading extends SellFormState {
  SellFormLoading();
}

class SellFormSubmitting extends SellFormState {
  SellFormSubmitting();
}

class SellMultiFormSubmitting extends SellFormState {}

class SellImageLoading extends SellFormState {}

class SellLoading extends SellFormState {
}

class SellFormSuccess extends SellFormState {
  final String message;

  SellFormSuccess(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Success', message, isError: false);
  }
}

class SellFormError extends SellFormState {
  final String error;

  SellFormError(this.error);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Error', error, isError: true);
  }
}

class SellScreenLoading extends SellFormState {}

class SellScreenSuccess extends SellFormState {}

class SellScreenError extends SellFormState {}