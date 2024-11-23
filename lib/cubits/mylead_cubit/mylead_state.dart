import 'package:flutter/cupertino.dart';

import '../../widgets/snackbar_helper.dart';

abstract class MyleadState {
  void showSnackbar(BuildContext context) {

  }
}

class MyleadInitial extends MyleadState {
  MyleadInitial();
}

class MyleadLoading extends MyleadState {
  MyleadLoading();
}

class MyleadSubmitting extends MyleadState {
  MyleadSubmitting();
}



class MyleadSuccess extends MyleadState {
  final String message;

  MyleadSuccess(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Success', message, isError: false);
  }
}

class MyleadError extends MyleadState {
  final String error;

  MyleadError(this.error);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Error', error, isError: true);
  }
}
