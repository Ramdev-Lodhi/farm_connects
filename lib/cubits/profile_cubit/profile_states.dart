import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/snackbar_helper.dart';

abstract class ProfileState {

  void showSnackbar(BuildContext context) {

  }
}

class ProfileInitialState extends ProfileState {}
class GetProfileDataLoadingSate extends ProfileState {}
class ProfileSuccessState extends ProfileState {

}
class ProfileErrorState extends ProfileState {}

class ProfileUpdateInitial extends ProfileState {}

class ProfileUpdateLoading extends ProfileState {}
class ProfileImageUpdatedState extends ProfileState {}
class ProfileImageErrorState extends ProfileState {}
class ProfileImageLaodingState extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  ProfileUpdateSuccess(this.message);

  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Success', message, isError: false);
  }
}

class ProfileUpdateError extends ProfileState {
  final String error;
  ProfileUpdateError(this.error);
  @override
  void showSnackbar(BuildContext context) {
    showCustomSnackbar('Error', error, isError: true);

  }
}


