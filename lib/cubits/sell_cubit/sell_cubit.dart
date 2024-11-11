// sell_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../cubits/sell_cubit/sell_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../screen/sellScreen/multi_step_sell_screen.dart';
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
      Get.to(MultiStepSellScreen());
    }
  }
  void submitmultifrom({
    required String selectedBrand,
    required String selectedModel,
    required String selectedYear,
    required String selectedEngine,
    required String selectedTyre,
    required String selectedDriven,
    required List<XFile> images,
  }) {
    emit(SellFormSubmitting());

    // Print the form data
    print('Selected Brand: $selectedBrand');
    print('Selected Model: $selectedModel');
    print('Selected Year: $selectedYear');
    print('Selected Engine: $selectedEngine');
    print('Selected Tyre: $selectedTyre');
    print('Selected Driven: $selectedDriven');
    for (var image in images) {
      print('Image Path: ${image.path}');
    }

    // Add your form submission logic here, if needed.

    emit(SellFormSuccess(
      location: locationController.text,
      name: nameController.text,
      mobile: mobileController.text,
    ));
  }
}