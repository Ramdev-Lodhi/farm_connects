import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farm_connects/cubits/profile_cubit/profile_cubits.dart';
import 'package:farm_connects/config/network/local/cache_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/profile_cubit/profile_states.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../config/network/remote/dio.dart';
import '../../models/login_model.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/snackbar_helper.dart';
import '../../config/location/location_permission.dart';
import '../../cubits/auth_cubit/auth_states.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../layout/home_layout.dart';
import '../otpScreen/LoginScreen_withOTP.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedState;
  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedVillage;
  List<District> districts = [];
  List<SubDistrict> filteredSubDistricts = [];
  List<String> filteredVillages = [];
  String? _name;
  String? _email;
  String? _mobile;
  String? _pincode;
  String? pincode;
  String? _password;
  String? _checkpassword;
  String? _cpassword;
  bool mobileverified = false;
  bool isOTPSent = false;
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _isCPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    loadDistricts();
    // fetchPincode();
    BlocProvider.of<ProfileCubits>(context).loadStates();

    var profileData = ProfileCubits.get(context).profileModel.data;
    if (profileData != null) {
      _name = profileData.name ?? CacheHelper.getData(key: 'name') ;
      _email =  profileData.email ?? CacheHelper.getData(key: 'email') ;
      _mobile = profileData.mobile;
      _checkpassword =profileData.password;
      _password= '';
      if (_mobile != null && _mobile == profileData.mobile) {
        mobileverified = true;
      }
      selectedState =  profileData.state != null ? profileData.state : CacheHelper.getData(key: 'state') ;
      selectedDistrict = profileData.district != null ? profileData.district : CacheHelper.getData(key: 'district');
      selectedSubDistrict =profileData.sub_district != null ? profileData.sub_district : CacheHelper.getData(key: 'subDistrict');
      selectedVillage = profileData.village != null ? profileData.village : CacheHelper.getData(key: 'village') != ''
          ? CacheHelper.getData(key: 'village')
          : 'No villages';
      _pincode =profileData.pincode != null ? profileData.pincode :  CacheHelper.getData(key: 'pincode');

    } else {
      print("Profile data is null");
    }
  }

  Future<void> loadDistricts() async {
    if (selectedState != null) {
      districts = await BlocProvider.of<ProfileCubits>(context)
          .loadDistricts(selectedState!);
      setState(() {});
    }
  }

  void _saveProfile() {
    // print('Name: $_name, Email: $_email, Mobile: $_mobile,Password: $_password');
    // print('State: $selectedState, District: $selectedDistrict, Sub-District: $selectedSubDistrict, Village: $selectedVillage, Pincode: $_pincode');

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var profileCubit = ProfileCubits.get(context);
      if (selectedState != null &&
          selectedDistrict != null &&
          selectedSubDistrict != null &&
          selectedVillage != null) {
        if (mobileverified) {
          profileCubit.updateInformation(
            _name!,
            _email!,
            _mobile!,
            selectedState!,
            selectedDistrict!,
            selectedSubDistrict!,
            selectedVillage!,
            _pincode!,
            _password!,
          );
        } else {
          showCustomSnackbar('Alert', 'Mobile Number is not verified!',
              isError: true);
        }
      } else {
        showCustomSnackbar('Alert', 'Please select all fields!', isError: true);
      }
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final response = await DioHelper.postData(
          method: "send-otp", data: {'phone': '+91' + phoneNumber});
      if (response.data['status']) {
        setState(() {
          isOTPSent = true;
        });
      } else {
        throw Exception('Failed to send OTP: ${response.data['message']}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error sending OTP: $error')));
    } finally {
      setState(() {
        isLoading = false; // End loading
      });
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String otpCode) async {
    setState(() {
      isLoading = true;
    });
    try {
      print('mobile:$phoneNumber and otp :$otpCode');
      final response = await DioHelper.postData(
          method: "verify-otp",
          data: {'phone': '+91' + phoneNumber, 'otp': otpCode});
      var loginModel = LoginModel.fromJson(response.data);
      print('response:$response and loginModel :${loginModel.status}');
      if (loginModel.status) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error verifying OTP: $error')));
      return false;
    } finally {
      setState(() {
        isLoading = false; // End loading
      });
    }
  }

  // Future<void> fetchPincode() async {
  //     pincode = await LocationHelper.fetchLocationDetails();
  //     print("Fetched pincode: $pincode");
  //     setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubits, ProfileState>(
      listener: (context, state) {
        if (state is ProfileState && state.showSnackbar != null) {
          state.showSnackbar(context);
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var profileCubit = ProfileCubits.get(context);

        Color textColor = cubit.isDark ? Colors.white : Colors.black;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Material(
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.2),
              child: AppBar(
                backgroundColor: Colors.blue,
                title: Text('Update Information',
                    style: TextStyle(color: textColor, fontSize: 15)),
                actions: [
                  TextButton(
                    onPressed:() {
                      Get.offAll(()=>HomeLayout());
                    },
                    child: Text('Skip',
                        style: TextStyle(color: textColor, fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    initialValue: _name,
                    label: 'Name',
                    onSaved: (value) => _name = value,
                    onChanged:(value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  _buildTextField(
                    initialValue: profileCubit.profileModel.data?.email,
                    label: 'Email',
                    onSaved: (value) => _email = value,
                    onChanged:(value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              initialValue:
                                  profileCubit.profileModel.data?.mobile,
                              decoration: InputDecoration(
                                labelText: 'Mobile',
                                labelStyle: TextStyle(
                                  fontWeight:
                                      FontWeight.bold, // Makes the label bold
                                ),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                suffixIcon: mobileverified &&
                                        _mobile ==
                                            profileCubit
                                                .profileModel.data?.mobile
                                    ? Icon(Icons.verified, color: Colors.green)
                                    : Icon(Icons.cancel, color: Colors.red),
                              ),
                              onSaved: (value) => _mobile = value,
                              onChanged: (value) {
                                _mobile = value;
                                if (_mobile !=
                                    profileCubit.profileModel.data?.mobile) {
                                  mobileverified = false;
                                }
                                if (value.length == 10 && !isOTPSent) {
                                  sendOTP(
                                      value); // Call sendOTP when mobile number is valid
                                }
                              },
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Please enter your Mobile'
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        ElevatedButton(
                          onPressed: () {
                            if (_mobile != null && _mobile!.length == 10) {
                              _showOTPDialog();
                              sendOTP(_mobile!);
                            } else {
                              showCustomSnackbar('Error',
                                  'Please enter a valid mobile number.',
                                  isError: true);
                            }
                          },
                          child: Text(
                            'OTP',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),
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
                            .firstWhere(
                                (district) => district.district == value)
                            .subDistricts;
                      });
                    },
                    label: "District",
                  ),
                  SizedBox(height: ScreenUtil().setHeight(16)),
                  CustomDropdown(
                    hint: "Select Sub-District",
                    items:
                        filteredSubDistricts.map((s) => s.subDistrict).toList(),
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
                      onChanged:(value) {
                        setState(() {
                          _pincode = value;
                        });
                      },
                  ),
                if(_checkpassword == null)
                  _buildPasswordTextField(
                    initialValue: _password,
                    label: 'Password',
                    suffixIcon: _buildPasswordSuffixIcon(),
                    onSaved: (value) => _password = value,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    obscureText: _isPasswordVisible,
                  ),
                  if(_checkpassword == null)
                  _buildPasswordTextField(
                    initialValue: _cpassword,
                    label: 'Confirm Password',
                    suffixIcon: _buildCPasswordSuffixIcon(),
                    onSaved: (value) => _cpassword = value,
                    onChanged: (value) {
                      setState(() {
                        _cpassword = value;
                      });
                    },
                    obscureText: _isCPasswordVisible,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              AuthCubits.get(context).signOut();
                              CacheHelper.removeData(key: 'token');
                              CacheHelper.removeData(key: 'image');
                              CacheHelper.removeData(key: 'name');
                              CacheHelper.removeData(key: 'email');
                              CacheHelper.removeData(key: 'state');
                              CacheHelper.removeData(key: 'district' );
                              CacheHelper.removeData(key: 'subDistrict');
                              CacheHelper.removeData(key: 'village');
                              CacheHelper.removeData(key: 'pincode');
                             Get.offAll(()=>OTPScreen());
                            },
                            child:
                            Text("Logout", style: TextStyle(color: Colors.white)),
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
                            onPressed: _saveProfile,
                            child:
                            Text("Next", style: TextStyle(color: Colors.white)),
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

                ],
              ),
            ),
          ),
        );
      },
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

  Widget _buildPasswordTextField({
    required String? initialValue,
    required String label,
    required FormFieldSetter<String> onSaved,
    required Widget suffixIcon, // Change this to Widget
    ValueChanged<String>? onChanged,
    TextInputType keyboardType = TextInputType.emailAddress,
    required bool obscureText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon, // Use the Widget directly here
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        ),
        onSaved: onSaved,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: !obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          } else if (label=='Confirm Password' && value != _password) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }


  Widget _buildPasswordSuffixIcon() {
    return IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.black,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    );
  }
  Widget _buildCPasswordSuffixIcon() {
    return IconButton(
      icon: Icon(
        _isCPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.black,
      ),
      onPressed: () {
        setState(() {
          _isCPasswordVisible = !_isCPasswordVisible;
        });
      },
    );
  }

  Future<void> _showOTPDialog() async {
    String? otpCode;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            onChanged: (value) {
              otpCode = value; // Capture OTP code
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter the OTP'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (otpCode != null && otpCode?.length == 6) {
                  print('mobile:$_mobile and otp :$otpCode');
                  bool isVerified = await verifyOTP(_mobile!, otpCode!);
                  if (isVerified) {
                    mobileverified = true;
                    Navigator.of(context).pop();
                    showCustomSnackbar('Success', 'OTP Verified!',
                        isError: false);
                  } else {
                    mobileverified = false;
                    showCustomSnackbar('Error',
                        'Your OTP is invalid or has expired. Please try again.',
                        isError: true);
                  }
                } else {
                  showCustomSnackbar('Error', 'Please enter a valid OTP.',
                      isError: true);
                }
              },
              child: Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
