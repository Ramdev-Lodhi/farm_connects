import 'dart:io';
import 'package:farm_connects/screen/sellScreen/sell_imageUpload.dart';
import 'package:farm_connects/widgets/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/sell_cubit/sell_States.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/loadingIndicator.dart';

class MultiStepSellScreen extends StatefulWidget {
  final String location;
  final String name;
  final String mobile;

  MultiStepSellScreen({
    required this.location,
    required this.name,
    required this.mobile,
  });

  @override
  _MultiStepSellScreenState createState() => _MultiStepSellScreenState();
}

class _MultiStepSellScreenState extends State<MultiStepSellScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _currentStep = 0;
  final TextEditingController priceController = TextEditingController();
  XFile? _images;
  String? _selectedbrand;
  String? _selectedmodel;
  String? _selectedyear;
  String? _selectedengin;
  String? _selectedtyre;
  String? _selecteddriven;
  String? _selectedmodelName;
  String? _selectedModelHP;
  String? _selectedRC = 'Yes';

  List<String> year = [];
  final List<String> engines = [
    '0-25%(Poor)',
    '26-50%(Average)',
    '51-75%(Good)',
    '76-100%(Very Good)'
  ];
  final List<String> tyre = [
    '0-25%(Poor)',
    '26-50%(Average)',
    '51-75%(Good)',
    '76-100%(Very Good)'
  ];
  final List<String> driven = [
    'Less than 1000',
    '1001-2000',
    '2001-3000',
    '3001-4000',
    '4001-5000'
  ];

  List<String> brandList = [];
  List<String> modelNameList = [];

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    year = List.generate(2024 - 1995 + 1, (index) => (1995 + index).toString());
    loadModel();
  }

  Future<void> loadModel() async {
    if (_selectedbrand != null) {
      await BlocProvider.of<SellCubit>(context).getModel(_selectedbrand!);
      modelNameList = SellCubit.get(context)
              .sellDataModel
              ?.data
              .models
              .map((model) => "${model.name} (${model.hpCategory})")
              .toList() ??
          [];
      setState(() {});
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SellImageSourceDialog(
          onImagesSelected: (XFile images) {
            setState(() {
              _images = images; // Save the selected images
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellCubit, SellFormState>(
      listener: (context, state) {
        if (state is SellFormState && state.showSnackbar != null) {
          state.showSnackbar(context);
        }
        if (state is SellImageLoading || state is SellFormLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is SellFormLoading) {
          setState(() {
            _isLoading = false;
          });
        } else {
          _isLoading = false;
        }
      },
      builder: (context, state) {
        brandList = HomeCubit.get(context)
                .homeDataModel
                ?.data
                .brands
                .map((brand) => brand.name)
                .toList() ??
            [];

        return Scaffold(
          body: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
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
                          return SizedBox
                              .shrink(); // Custom controls (empty container)
                        },
                        steps: [
                          Step(
                            label: Text('Tractor Type',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            title: Text(""),
                            content: Column(
                              children: [
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Text("Which Tractor Do You Own",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                CustomDropdown(
                                  hint: "Select Brand",
                                  items: brandList,
                                  value: _selectedbrand,
                                  onChanged: (value) {
                                    setState(() => _selectedbrand = value);
                                    loadModel();
                                  },
                                  label: "Brand",
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                CustomDropdown(
                                  value: _selectedmodel,
                                  hint: 'Select Model Name',
                                  items: modelNameList,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedmodel = value;
                                      final selectedModel = SellCubit.get(
                                              context)
                                          .sellDataModel
                                          ?.data
                                          .models
                                          .firstWhere((model) =>
                                              "${model.name} (${model.hpCategory})" ==
                                              _selectedmodel);

                                      if (selectedModel != null) {
                                        _selectedmodelName = selectedModel.name;
                                        _selectedModelHP =
                                            selectedModel.hpCategory;
                                      }
                                    });
                                  },
                                  label: "Model",
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
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
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Text("Share Tractor Conditions With Buyers",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                CustomDropdown(
                                  value: _selectedengin,
                                  hint: 'Select Engine Condition',
                                  items: engines,
                                  onChanged: (value) =>
                                      setState(() => _selectedengin = value),
                                  label: "Engine Condition",
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                CustomDropdown(
                                  value: _selectedtyre,
                                  hint: 'Select Tyre Condition',
                                  items: tyre,
                                  onChanged: (value) =>
                                      setState(() => _selectedtyre = value),
                                  label: 'Tyre Condition',
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
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
                            content: Column(
                              children: [
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Text("Upload Tractor Images",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                ElevatedButton.icon(
                                  onPressed: _showImageSourceDialog,
                                  icon: Icon(Icons.photo_camera_sharp),
                                  label: Text("Select Photos",
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                _images != null
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.file(
                                          File(_images!.path),
                                          // Display the selected image
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            elevation: 4.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.image_outlined,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    "Please select images of the tractor to proceed.You can Select Four image at a time",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Text("Do you Have RC?",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio<String>(
                                      value: 'Yes',
                                      groupValue: _selectedRC,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRC = value;
                                        });
                                      },
                                    ),
                                    Text("Yes"),
                                    Radio<String>(
                                      value: 'No',
                                      groupValue: _selectedRC,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRC = value;
                                        });
                                      },
                                    ),
                                    Text("No"),
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Text("Enter Price Of your Tractor",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  controller: priceController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.currency_rupee,
                                        color: Palette.iconColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    hintText: "Enter the Price of Tractor",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                )
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_currentStep > 0) {
                                    setState(() => _currentStep -= 1);
                                  } else {
                                    Get.back();
                                  }
                                },
                                child: Text("Cancel",
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(2)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_currentStep == 0) {
                                    if (_selectedbrand != null &&
                                        _selectedmodel != null &&
                                        _selectedyear != null) {
                                      setState(() => _currentStep += 1);
                                    } else {
                                      showCustomSnackbar(
                                          'Alert', 'All Fields are required',
                                          isError: true);
                                    }
                                  } else if (_currentStep == 1) {
                                    if (_selectedengin != null &&
                                        _selectedtyre != null &&
                                        _selecteddriven != null) {
                                      setState(() => _currentStep += 1);
                                    } else {
                                      showCustomSnackbar(
                                          'Alert', 'All Fields are required',
                                          isError: true);
                                    }
                                  } else if (_currentStep == 2) {
                                    if (_images != null) {
                                      List<String> locationParts =
                                          widget.location.split(', ');
                                      String state = locationParts[0];
                                      String city = locationParts.length > 1
                                          ? locationParts[1]
                                          : '';
                                      var sellCubit = SellCubit.get(context);
                                      sellCubit.InsertSellData(
                                        _selectedyear!,
                                        _selectedbrand!,
                                        _selecteddriven!,
                                        _selectedModelHP!,
                                        _selectedmodelName!,
                                        _selectedtyre!,
                                        _selectedengin!,
                                        state,
                                        city,
                                        _selectedRC,
                                        widget.name,
                                        widget.mobile,
                                        priceController.text,
                                        _images! as XFile,
                                      );
                                    } else {
                                      showCustomSnackbar(
                                          'Alert', 'Select the Images',
                                          isError: true);
                                    }
                                  }
                                },
                                child: _currentStep == 2
                                    ? Text("Submit",
                                        style: TextStyle(color: Colors.white))
                                    : Text("Continue",
                                        style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(child: LoadingIndicator(size: 100)),
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
