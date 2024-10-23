import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../layout/home_layout.dart';
import '../../models/login_model.dart';

import '../../screen/authScreen/login_signup.dart';
import '../auth_cubit/auth_states.dart';

class AuthCubits extends Cubit<Authstates> {


  AuthCubits() : super(LoginInitialState());

  static AuthCubits get(context) => BlocProvider.of(context);
  late LoginModel loginModel;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> Signup(String name, int phone, String address, int pincode,
      String password, String email) async {
    emit(SignupLoadingState());
    String fullUrl = '${DioHelper.dio.options.baseUrl}$SIGN_UP';
    print('Signup URL: $fullUrl');

    DioHelper.postData(
      method: SIGN_UP, // Use SIGN_UP here
      data: {
        "name": name,
        "mobile": phone,
        "city": address,
        "pincode": pincode,
        "password": password,
        "email": email
      },
      lang: 'en',
    ).then((value) {
      print(value.data['message']);
      if(value.data['message']=="User already exists."){
        Get.snackbar(
          'Signup Failed',
          'This user is already registered.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }else{

        Get.offAll(() => LoginSignupScreen());
      }

    }).catchError((error) {
      print('error : ' + error.toString());
    });
  }

  Future<void> Signin(String email, String password) async {
    emit(LoginLoadingState());
    // print('Login URL: $email');
    // print('Login URL: $password');
    // Log the URL before making the request
    String fullUrl = '${DioHelper.dio.options.baseUrl}$LOGIN';
    print('Login URL: $fullUrl');
    DioHelper.postData(
      method: LOGIN,
      data: {
        "email": email,
        "password": password,
      },
      lang: 'en',
    ).then((value) {
      print(value);
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel.data?.image);
      if (loginModel.status) {
        CacheHelper.saveData(key: 'token', value: loginModel.data?.token ?? "");
        CacheHelper.saveData(key: 'image', value: loginModel.data?.image ?? "");
        CacheHelper.saveData(key: 'name', value: loginModel.data?.name ?? "");
        CacheHelper.saveData(key: 'email', value: loginModel.data?.email ?? "");
        Get.offAll(() => HomeLayout());
      }
      // print(loginModel.data?.token);
    }).catchError((error) {
      print('error : ' + error.toString());
    });
  }
  Future<void> signInWithGoogle() async {
    emit(LoginLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        emit(LoginErrorState('Google sign-in aborted.'));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Send the token to your backend for verification and login
      String token = googleAuth.idToken ?? '';
      // Call your backend login function with the token
      await _loginWithGoogleToken(token);
    } catch (error) {
      print('Google sign-in error: $error');
      emit(LoginErrorState(error.toString())); // Emit an error state if needed
    }
  }

  Future<void> _loginWithGoogleToken(String token) async {
    String fullUrl = _buildUrl(GOOGLE_LOGIN); // Update this with your Google login endpoint
    print('Google Login URL: $fullUrl');

    try {
      final response = await DioHelper.postData(
        method: GOOGLE_LOGIN,
        data: {
          "token": token,
        },
        lang: 'en',
      );

      loginModel = LoginModel.fromJson(response.data);
      print(loginModel.data?.image);
      if (loginModel.status) {
        await CacheHelper.saveData(key: 'token', value: loginModel.data?.token ?? "");
        await CacheHelper.saveData(key: 'image', value: loginModel.data?.image ?? "");
        await CacheHelper.saveData(key: 'name', value: loginModel.data?.name ?? "");
        await CacheHelper.saveData(key: 'email', value: loginModel.data?.email ?? "");
        Get.offAll(() => HomeLayout());
      }
    } catch (error) {
      print('Google login error: $error');
      emit(LoginErrorState(error.toString())); // Emit an error state if needed
    }
  }

  String _buildUrl(String endpoint) {
    return '${DioHelper.dio.options.baseUrl}$endpoint';
  }
}
