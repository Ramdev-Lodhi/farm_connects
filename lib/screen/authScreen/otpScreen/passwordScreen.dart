import 'package:farm_connects/screen/authScreen/otpScreen/LoginScreen_withOTP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../cubits/auth_cubit/auth_cubit.dart';

class PasswordScreen extends StatefulWidget {
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController _phoneOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validatePhoneOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone/Email is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }


  void _submitForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      String phoneOrEmail = _phoneOrEmailController.text.trim();
      String password = _passwordController.text.trim();

      if (isValidEmail(phoneOrEmail)) {
        String email = phoneOrEmail;
        print("Logging in with Email: $email");
        BlocProvider.of<AuthCubits>(context).SigninWithPassword(
          email,
          password,
        );
      } else if (isValidPhone(phoneOrEmail)) {
        String mobile = phoneOrEmail;
        BlocProvider.of<AuthCubits>(context).SigninWithPassword(
          mobile,
          password,
        );
        print("Logging in with Mobile: $mobile");
      } else {
        print("Invalid Phone/Email format");
      }
    } else {
      print("Validation failed");
    }
  }
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return phone.length >= 10 && phone.length <= 15 && int.tryParse(phone) != null;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'User Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _phoneOrEmailController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number or Email Address',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 20.sp),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validatePhoneOrEmail,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 20.sp),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  onFieldSubmitted: (_) => _submitForm(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forget Password',
                        style: TextStyle(color: Colors.red, fontSize: 15.sp),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey, thickness: 1.0)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Or'),
                    ),
                    Expanded(child: Divider(color: Colors.grey, thickness: 1.0)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Get.offAll(() => OTPScreen());
                  },
                  child: Text(
                    'Login Using OTP',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(143, 130, 244, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

