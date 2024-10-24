// sell_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../screen/sellScreen/multi_step_sell_screen.dart';
import '../sell_cubit/sell_States.dart';
import 'package:flutter/material.dart';

class SellCubit extends Cubit<SellFormState> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  SellCubit() : super(SellFormInitial());
  static SellCubit get(context) => BlocProvider.of(context);
  @override
  Future<void> close() {
    locationController.dispose();
    nameController.dispose();
    mobileController.dispose();
    return super.close();
  }

  void submitForm() {
    emit(SellFormSubmitting());

    final location = locationController.text;
    final name = nameController.text;
    final mobile = mobileController.text;

    if (location.isEmpty || name.isEmpty || mobile.isEmpty) {
      emit(SellFormError('All fields are required'));
    } else {
      emit(SellFormSuccess(
        location: location,
        name: name,
        mobile: mobile,
      ));
      Get.to(SubmissionPage(location: '$location',name:'$name',mobile: '$mobile',));
    }
  }
}
