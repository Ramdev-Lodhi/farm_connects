import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/snackbar_helper.dart';

abstract class LocationState {

  void showSnackbar(BuildContext context) {

  }
}

class LocationInitialState extends LocationState {}
class GetLocationDataLoadingSate extends LocationState {}
class LocationSuccessState extends LocationState {

}
class LocationErrorState extends LocationState {}

class LocationUpdateInitial extends LocationState {}

class LocationUpdateLoading extends LocationState {}

class LocationUpdateSuccess extends LocationState {
  final String message;

  LocationUpdateSuccess(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Success', message, isError: false);
  }
}

class LocationUpdateError extends LocationState {
  final String error;
  LocationUpdateError(this.error);
  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Error', error, isError: true);
  }
}


