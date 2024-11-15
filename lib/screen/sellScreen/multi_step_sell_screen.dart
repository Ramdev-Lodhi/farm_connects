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

class _MultiStepSellScreenState extends State<MultiStepSellScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TabController? _tabController;
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
    _tabController = TabController(length: 3, vsync: this);
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

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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

  _saveProfile() {
    if (_images != null &&
        _selectedengin != null &&
        _selectedtyre != null &&
        _selecteddriven != null &&
        _selectedbrand != null &&
        _selectedmodel != null &&
        _selectedyear != null) {
// print(_images);
      List<String> locationParts = widget.location.split(', ');
      String state = locationParts[0];
      String city = locationParts.length > 1 ? locationParts[1] : '';
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
      showCustomSnackbar('Alert', 'Select All Fields ', isError: true);
    }
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
        return DefaultTabController(
          length: _tabController?.length ?? 3,
          child: Scaffold(
            body: Column(
              children: [
                // Top TabBar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    color: Palette.tabbarColor,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.black,
                      tabs: const [
                        Tab(text: 'Tractor Type'),
                        Tab(text: 'Condition of Tractor'),
                        Tab(text: 'Image Upload'),
                      ],
                    ),
                  ),
                ),
                // TabBarView for the content
                Expanded(
                  child: Stack(
                    children: [
                      TabBarView(
                        controller: _tabController,
                        children: [
                          _buildVerticalScrollableContent(
                              _buildTractorTypeSection(),
                              showNext: true),
                          _buildVerticalScrollableContent(
                              _buildConditionSection(),
                              showPrevious: true,
                              showNext: true),
                          _buildVerticalScrollableContent(_buildImageSection(),
                              showPrevious: true, showSubmit: true),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalScrollableContent(Widget child,
      {bool showPrevious = false,
      bool showNext = false,
      bool showSubmit = false}) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: child,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (showPrevious) SizedBox(width: 8.0),
            if (showPrevious)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_tabController!.index > 0) {
                      _tabController?.animateTo(_tabController!.index - 1);
                    }
                  },
                  child: Text('Previous', style: TextStyle(color: Colors.grey)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      side: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),
              ),
            SizedBox(width: 8.0),
            if (showNext)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_tabController!.index < _tabController!.length - 1) {
                      _tabController?.animateTo(_tabController!.index + 1);
                    }
                  },
                  child: Text('Next', style: TextStyle(color: Colors.blue)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      side: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
              ),
            SizedBox(width: 8.0),
            if (showSubmit)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _saveProfile();
                  },
                  child: Text('Submit', style: TextStyle(color: Colors.green)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      side: BorderSide(color: Colors.green, width: 1),
                    ),
                  ),
                ),
              ),
            if (showSubmit) SizedBox(width: 8.0),
          ],
        ),
        SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildTractorTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Which Tractor Do You Own",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),

        // Brand Dropdown
        CustomDropdown(
          hint: "Select Brand",
          items: brandList,
          value: _selectedbrand,
          onChanged: (value) {
            setState(() {
              _selectedbrand = value;
              loadModel(); // Call method to load models based on the selected brand
            });
          },
          label: "Brand",
        ),

        SizedBox(height: ScreenUtil().setHeight(20)),

        // Model Dropdown
        CustomDropdown(
          value: _selectedmodel,
          hint: 'Select Model Name',
          items: modelNameList,
          onChanged: (value) {
            setState(() {
              _selectedmodel = value;
              // Find the selected model based on the string
              final selectedModel = SellCubit.get(context)
                  .sellDataModel
                  ?.data
                  .models
                  .firstWhere(
                    (model) =>
                        "${model.name} (${model.hpCategory})" == _selectedmodel,
                  );

              // Update model-specific values if a valid model is found
              if (selectedModel != null) {
                _selectedmodelName = selectedModel.name;
                _selectedModelHP = selectedModel.hpCategory;
              }
            });
          },
          label: "Model",
        ),

        SizedBox(height: ScreenUtil().setHeight(20)),

        // Year Dropdown
        CustomDropdown(
          value: _selectedyear,
          hint: 'Select Year',
          items: year,
          onChanged: (value) {
            setState(() {
              _selectedyear = value;
            });
          },
          label: "Year",
        ),
      ],
    );
  }

  Widget _buildConditionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Share Tractor Conditions With Buyers",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        CustomDropdown(
          value: _selectedengin,
          hint: 'Select Engine Condition',
          items: engines,
          onChanged: (value) {
            setState(() => _selectedengin = value);
          },
          label: "Engine Condition",
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        CustomDropdown(
          value: _selectedtyre,
          hint: 'Select Tyre Condition',
          items: tyre,
          onChanged: (value) {
            setState(() => _selectedtyre = value);
          },
          label: 'Tyre Condition',
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        CustomDropdown(
          value: _selecteddriven,
          hint: 'Select Hours Driven',
          items: driven,
          onChanged: (value) {
            setState(() => _selecteddriven = value);
          },
          label: "Hours Driven",
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Do you have RC?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        Text(
          "Enter Price of your Tractor",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        TextFormField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: 'Tractor Price ',
            prefixIcon: Icon(Icons.currency_rupee),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        Text(
          "Upload Tractor Images",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _showImageSourceDialog,
                // You would need to define this method
                icon: Icon(Icons.photo_camera_sharp),
                label: Text(
                  "Select Photos",
                  style: TextStyle(color: Colors.white),
                ),
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
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        File(_images!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Please select images of the tractor to proceed. You can select up to four images at a time.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
