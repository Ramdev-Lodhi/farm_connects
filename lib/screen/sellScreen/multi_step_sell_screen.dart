import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/palette.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';
import '../../cubits/sell_cubit/sell_states.dart';
import '../../widgets/customDropdown.dart';

class MultiStepSellScreen extends StatefulWidget {
  @override
  _MultiStepSellScreenState createState() => _MultiStepSellScreenState();
}

class _MultiStepSellScreenState extends State<MultiStepSellScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List<XFile>? _images;
  String? _selectedbrand;
  String? _selectedmodel;
  String? _selectedyear;
  String? _selectedengin;
  String? _selectedtyre;
  String? _selecteddriven;

  final List<String> brand = ['Location 1', 'Location 2', 'Location 3'];
  final List<String> modelname = ['Name 1', 'Name 2', 'Name 3'];
  final List<String> year = ['Condition 1', 'Condition 2', 'Condition 3'];
  final List<String> engines = ['Engine 1', 'Engine 2', 'Engine 3'];
  final List<String> tyre = ['Mobile 1', 'Mobile 2', 'Mobile 3'];
  final List<String> driven = ['RC 1', 'RC 2', 'RC 3'];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellCubit, SellFormState>(
      listener: (context, state) {
        if (state is SellFormSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Submission Successful")));
        } else if (state is SellFormError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Sell Tractor"),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepTapped: (step) {
                      setState(() {
                        _currentStep = step;
                      });
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      // Returning an empty container to remove the default controls.
                      return SizedBox.shrink();
                    },
                    steps: [
                      Step(
                        label: Text('Tractor Type',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        title: Text(""),
                        content: Column(
                          children: [
                            CustomDropdown(
                              hint: "Select State",
                              items: brand,
                              value: _selectedbrand,
                              onChanged: (value) {
                                setState(() => _selectedbrand = value);
                              },
                              label: "Brand",
                            ),
                            SizedBox(height: ScreenUtil().setHeight(16)),
                            CustomDropdown(
                              value: _selectedmodel,
                              hint: 'Select Model Name',
                              items: modelname,
                              onChanged: (value) =>
                                  setState(() => _selectedmodel = value),
                              label: "Model",
                            ),
                            SizedBox(height: 20),
                            CustomDropdown(
                              value: _selectedyear,
                              hint: 'Select Year',
                              items: year,
                              onChanged: (value) =>
                                  setState(() => _selectedyear = value),
                              label: "Year",
                            ),
                          ],
                        ),
                        isActive: _currentStep == 0,
                        state: _currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        label: Text("Condition State",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        title: Text(""),
                        content: Column(
                          children: [
                            CustomDropdown(
                              value: _selectedengin,
                              hint: 'Select Engies Condition',
                              items: engines,
                              onChanged: (value) =>
                                  setState(() => _selectedengin = value),
                             label:" Engies Condition",
                            ),

                            SizedBox(height: 20),
                            CustomDropdown(
                              value: _selectedtyre,
                              hint: 'Select Tyre Condition',
                              items: tyre,
                              onChanged: (value) =>
                                  setState(() => _selectedtyre = value),
                            label: 'Tyre Condition',
                            ),
                            SizedBox(height: 20),
                            CustomDropdown(
                              value: _selecteddriven,
                              hint: 'Select Hours Driven',
                              items: driven,
                              onChanged: (value) =>
                                  setState(() => _selecteddriven = value),
                             label: "Hours Driven",
                            ),
                          ],
                        ),
                        isActive: _currentStep == 1,
                        state: _currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        label: Text("Image",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        title: Text(""),
                        content: state is SellFormSubmitting
                            ? CircularProgressIndicator()
                            : Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      var status =
                                          await Permission.storage.request();
                                      if (status.isGranted) {
                                        final ImagePicker _picker =
                                            ImagePicker();
                                        final List<XFile>? pickedImages =
                                            await _picker.pickMultiImage();
                                        if (pickedImages != null &&
                                            pickedImages.length <= 4) {
                                          setState(() {
                                            _images = pickedImages;
                                          });
                                        } else if (pickedImages != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Select a maximum of 4 images")));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Storage permission is required")));
                                      }
                                    },
                                    child: Text("Pick Images"),
                                  ),
                                  SizedBox(height: 10),
                                  _images != null && _images!.isNotEmpty
                                      ? Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children: _images!
                                              .map((image) => Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Image.file(
                                                        File(image.path),
                                                        fit: BoxFit.cover),
                                                  ))
                                              .toList(),
                                        )
                                      : Text("No images selected"),
                                ],
                              ),
                        isActive: _currentStep == 2,
                        state: _currentStep == 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ],
                  ),
                ),
                // Custom Navigation Buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel Button
                      ElevatedButton(
                        onPressed: () {
                          if (_currentStep > 0) {
                            setState(() => _currentStep -= 1);
                          }
                        },
                        child: Text("Cancel"),

                      ),
                      // Continue Button
                      ElevatedButton(
                        onPressed: () {
                          // if (_formKey.currentState!.validate()) {
                            if (_currentStep == 0) {
                              if (_selectedbrand != null &&
                                  _selectedmodel != null &&
                                  _selectedyear != null) {
                                setState(() => _currentStep += 1);
                              } else {
                                // CustomSnackbar.snackbar('Error', 'Please select all fields', Icons.error);
                                }
                            } else if (_currentStep == 1) {
                              if (_selectedengin != null &&
                                  _selectedtyre != null &&
                                  _selecteddriven != null) {
                                setState(() => _currentStep += 1);
                              } else {
                                // CustomSnackbar.snackbar(
                                //     'Error', 'Please select all fields',
                                //     Icons.error);
                              }
                            } else if (_currentStep == 2) {
                              if (_images != null && _images!.isNotEmpty) {
                                // print('Selected Location: $_selectedbrand');
                                // print('Selected Name: $_selectedmodel');
                                // print('Selected Mobile: $_selectedyear');
                                // for (var image in _images!) {
                                //   print('Image Path: ${image.path}');
                                // }

                                SellCubit.get(context).submitmultifrom(
                                  selectedBrand: _selectedbrand!,
                                  selectedModel: _selectedmodel!,
                                  selectedYear: _selectedyear!,
                                  selectedEngine: _selectedengin!,
                                  selectedTyre: _selectedtyre!,
                                  selectedDriven: _selecteddriven!,
                                  images: _images!,
                                );
                              } else {
                                // CustomSnackbar.snackbar(
                                //     'Error', 'Please upload photos',
                                //     Icons.error);

                              }
                            }
                          // }
                        },
                        child: _currentStep == 2 ? Text("Submit") : Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
