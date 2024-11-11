import 'dart:io';
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

  int _currentStep = 0;
  List<XFile>? _images;
  String? _selectedbrand;
  String? _selectedmodel;
  String? _selectedyear;
  String? _selectedengin;
  String? _selectedtyre;
  String? _selecteddriven;


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
  File? _selectedImage; // Declare this variable for the selected image.

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
              .map((model) => model.name)
              .toList() ??
          [];
      setState(() {});
    }
  }
  void _saveSellData(){
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   var SellCubits = SellCubit.get(context);
    //   SellCubits.InsertSellData(
    //       _selectedyear!,
    //       _selectedbrand!,
    //       _selecteddriven!,
    //       _selectedmodel!,
    //       _selectedtyre!,
    //       _selectedengin!,
    //       widget.location,
    //       widget.name,
    //       widget.mobile,
    //       _images! as XFile
    //
    //   );
    // }
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            height: 250.h, // Adjust height as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10.h),
                Text("Select Tractor Images", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Pick multiple images, but limit to 4
                    List<XFile>? images = await _picker.pickMultiImage();
                    if (images != null && images.length <= 4) {
                      setState(() {
                        _images = images; // Save images if 4 or fewer
                      });
                    } else if (images != null && images.length > 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("You can select only up to 4 images!")),
                      );
                    }
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.photo_library, color: Colors.white),
                  label: Text("Select from Gallery",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.black12,
                  height: 10,
                ),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     // Pick multiple images from camera
                //     List<XFile>? images = await _picker.pickMultiImage();
                //     if (images != null && images.length <= 4) {
                //       setState(() {
                //         _images = images; // Save images if 4 or fewer
                //       });
                //     } else if (images != null && images.length > 4) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text("You can select only up to 4 images!")),
                //       );
                //     }
                //     Navigator.pop(context);
                //   },
                //   icon: Icon(Icons.camera_alt, color: Colors.white),
                //   label: Text("Take Photos", style: TextStyle(color: Colors.white)),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12.0),
                //     ),
                //   ),
                // ),
                // Divider(
                //   thickness: 1.5,
                //   color: Colors.black12,
                //   height: 10,
                // ),
                // Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 0), // Set bottom margin to 0
                  child: SizedBox(
                    width: 150, // Set the desired width here
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          Text("Close", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF202A44),
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
        );
      },
    );
  }

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
        // Fetch the brand list from the cubit's state
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
                      return SizedBox
                          .shrink(); // Custom controls (empty container)
                    },
                    steps: [
                      Step(
                        label: Text('Tractor Type',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        title: Text(""),
                        content: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text("Which Tractor Do You Own",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: ScreenUtil().setHeight(16)),
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
                                SizedBox(height: ScreenUtil().setHeight(16)),
                                CustomDropdown(
                                  value: _selectedmodel,
                                  hint: 'Select Model Name',
                                  items: modelNameList,
                                  onChanged: (value) =>
                                      setState(() => _selectedmodel = value),
                                  label: "Model",
                                ),
                                SizedBox(height: ScreenUtil().setHeight(16)),
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
                          ),
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
                        content: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text("Share Tractor Conditions With Buyers",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: ScreenUtil().setHeight(16)),
                                CustomDropdown(
                                  value: _selectedengin,
                                  hint: 'Select Engine Condition',
                                  items: engines,
                                  onChanged: (value) =>
                                      setState(() => _selectedengin = value),
                                  label: "Engine Condition",
                                ),
                                SizedBox(height: ScreenUtil().setHeight(16)),
                                CustomDropdown(
                                  value: _selectedtyre,
                                  hint: 'Select Tyre Condition',
                                  items: tyre,
                                  onChanged: (value) =>
                                      setState(() => _selectedtyre = value),
                                  label: 'Tyre Condition',
                                ),
                                SizedBox(height: ScreenUtil().setHeight(16)),
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
                          ),
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
                                  Text("Upload Tractor Images",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: ScreenUtil().setHeight(16)),
                                  ElevatedButton.icon(
                                    onPressed: () => _showImageSourceDialog(),
                                    icon: Icon(Icons.photo_camera_sharp),
                                    label: Text("Select Photos",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // Display the selected images if any
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
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ))
                                              .toList(),
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
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPressed: () {
                              if (_currentStep == 0) {
                                if (_selectedbrand != null &&
                                    _selectedmodel != null &&
                                    _selectedyear != null) {
                                  setState(() => _currentStep += 1);
                                }
                              } else if (_currentStep == 1) {
                                if (_selectedengin != null &&
                                    _selectedtyre != null &&
                                    _selecteddriven != null) {
                                  setState(() => _currentStep += 1);
                                }
                              } else if (_currentStep == 2) {
                                if (_images != null && _images!.isNotEmpty) {

                                  _saveSellData;
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
          ),
        );
      },
    );
  }
}
