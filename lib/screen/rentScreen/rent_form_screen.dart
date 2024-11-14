import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/palette.dart'; // Ensure you have the palette constants
import '../../constants/styles/colors.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../cubits/rent_cubit/rent_cubit.dart';
import '../../cubits/rent_cubit/rent_states.dart';
import '../../models/home_data_model.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/loadingIndicator.dart';
import '../../widgets/snackbar_helper.dart';
import '../sellScreen/sell_imageUpload.dart'; // If applicable

class RentFormScreen extends StatefulWidget {
  @override
  State<RentFormScreen> createState() => _RentFormScreenState();
}

class _RentFormScreenState extends State<RentFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TabController? _tabController;

  final TextEditingController _priceController = TextEditingController();
  bool _isLoading = false;
  bool _rentedStatus = false;
  String? selectedState;
  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedVillage;
  String? _selectedService;
  String? _selectedPricetype;
  String? _price;
  XFile? _images;
  List<District> districts = [];
  List<SubDistrict> filteredSubDistricts = [];
  List<String> filteredVillages = [];
  String? _pincode;
  String? pincode;
  List<String> serviceList = [];
  List<String> priceTypeList = [
    'Hours',
    'Day',
    'Month',
    'Years',
    'Bigha',
    'Acre'
    'km'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadDistricts();
    _selectedService;
    _selectedPricetype;
    BlocProvider.of<ProfileCubits>(context).loadStates();
    var profileData = ProfileCubits.get(context).profileModel.data;
    if (profileData != null) {
      selectedState = profileData.state != null
          ? profileData.state
          : CacheHelper.getData(key: 'state');
      selectedDistrict = profileData.district != null
          ? profileData.district
          : CacheHelper.getData(key: 'district');
      selectedSubDistrict = profileData.sub_district != null
          ? profileData.sub_district
          : CacheHelper.getData(key: 'subDistrict');
      selectedVillage = profileData.village != null
          ? profileData.village
          : CacheHelper.getData(key: 'village') != ''
              ? CacheHelper.getData(key: 'village')
              : 'No villages';
      _pincode = profileData.pincode != null
          ? profileData.pincode
          : CacheHelper.getData(key: 'pincode');
    } else {
      print("Profile data is null");
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> loadDistricts() async {
    if (selectedState != null) {
      districts = await BlocProvider.of<ProfileCubits>(context)
          .loadDistricts(selectedState!);
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

  void _saveProfile() {
    print('Price:$_price per $_selectedPricetype');
    print(
        'State: $selectedState, District: $selectedDistrict, Sub-District: $selectedSubDistrict, Village: $selectedVillage, Pincode: $_pincode');
    if (selectedState != null &&
        selectedDistrict != null &&
        selectedSubDistrict != null &&
        selectedVillage != null && _selectedPricetype != null && _selectedService != null) {
      if(_images != null){
        var rentCubit = RentCubit.get(context);
        rentCubit.InsertRentData(
            selectedState!,
            selectedDistrict!,
            selectedSubDistrict!,
            selectedVillage!,
            _pincode!,
            _selectedService!,
            '${_price}  ${_selectedPricetype}'!,
            _images!);
      }else{
        showCustomSnackbar('Alert', 'Please select image!', isError: true);
      }
    } else {
      showCustomSnackbar('Alert', 'Please select all fields!', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RentCubit, RentStates>(
      listener: (context, state) {
        if (state is RentStates && state.showSnackbar != null) {
          state.showSnackbar(context);
        }
        if (state is RentFormLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
          _isLoading = false;
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: _tabController?.length ?? 2,
          child: Scaffold(
            body: Column(
              children: [
                // Top TabBar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:20),
                  child: Container(

                    color: Palette.tabbarColor,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.black,
                      tabs: const [
                        Tab(text: 'Address'),
                        Tab(text: 'Rent Data'),
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
                          _buildVerticalScrollableContent(_buildAddressSection(),
                              showNext: true),
                          _buildVerticalScrollableContent(_buildRentFormSection(),
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

  Widget _buildAddressSection() {
    var profileCubit = ProfileCubits.get(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CustomDropdown(
            hint: "Select State",
            items: profileCubit.stateNames,
            value: selectedState,
            onChanged: (value) {
              setState(() {
                selectedState = value;
                selectedDistrict = null;
                filteredSubDistricts = [];
              });
              loadDistricts();
            },
            label: "State",
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          CustomDropdown(
            hint: "Select District",
            items: districts.map((d) => d.district).toList(),
            value: selectedDistrict,
            onChanged: (value) {
              setState(() {
                selectedDistrict = value;
                selectedSubDistrict = null;
                filteredSubDistricts = districts
                    .firstWhere((district) => district.district == value)
                    .subDistricts;
              });
            },
            label: "District",
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          CustomDropdown(
            hint: "Select Sub-District",
            items: filteredSubDistricts.map((s) => s.subDistrict).toList(),
            value: selectedSubDistrict,
            onChanged: (value) {
              setState(() {
                selectedSubDistrict = value;
                filteredVillages = filteredSubDistricts
                    .firstWhere((s) => s.subDistrict == value)
                    .villages;
              });
            },
            label: "Sub-District",
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          CustomDropdown(
            hint: "Select Village",
            items: filteredVillages.isNotEmpty
                ? filteredVillages
                : ['No villages'],
            value: selectedVillage ?? 'No village selected',
            onChanged: (value) {
              setState(() {
                selectedVillage = value;
              });
            },
            label: "Village",
          ),
          SizedBox(height: ScreenUtil().setHeight(12)),
          _buildTextField(
            initialValue: _pincode,
            label: 'Pincode',
            onSaved: (value) => _pincode = value,
            onChanged: (value) {
              setState(() {
                _pincode = value;
              });
            },
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildTextField({
    String? initialValue,
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldSetter<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        ),
        onSaved: onSaved,
        onChanged: onChanged,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter your $label' : null,
      ),
    );
  }

  Widget _buildRentFormSection() {
    serviceList = HomeCubit.get(context)
            .homeDataModel
            ?.data
            .services
            .map((services) => services.service)
            .toList() ??
        [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.0),
        CustomDropdown(
          hint: "Select Services Type",
          items: serviceList,
          value: _selectedService,
          onChanged: (value) {
            setState(() => _selectedService = value);
          },
          label: "Service Type",
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  height: 48,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      prefixIcon: Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _price = value,
                    onChanged: (value) {
                      _price = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Price';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 8), // Add spacing between fields if needed
            Expanded(
              child: CustomDropdown(
                hint: "Select Price Type",
                items: priceTypeList,
                value: _selectedPricetype,
                onChanged: (value) {
                  setState(() => _selectedPricetype = value);
                },
                label: "Price Type",
              ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(20)),
            Text("Select Photos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: Icon(Icons.photo_camera_sharp),
              label:
                  Text("Select Photos", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            _images != null
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        File(_images!.path),
                        // Display the selected image
                        fit: BoxFit.cover,
                      ),
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
                                "Please select images of the Services to proceed.",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        )
        // SwitchListTile(
        //   title: Text('Rented Status'),
        //   value: _rentedStatus,
        //   onChanged: (value) {
        //     setState(() {
        //       _rentedStatus = value;
        //     });
        //   },
        // ),
      ],
    );
  }
}
