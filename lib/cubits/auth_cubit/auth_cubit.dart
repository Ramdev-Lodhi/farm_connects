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

  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email'],
  //   // clientId: "475762921924-9g8freueutt0cekkso8d4t7ooi9hpad4.apps.googleusercontent.com",
  // );
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // clientId: "475762921924-9g8freueutt0cekkso8d4t7ooi9hpad4.apps.googleusercontent.com.apps.googleusercontent.com",
  );
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
      print('Google User: $googleUser');
      if (googleUser == null) {
        emit(LoginErrorState('Google sign-in aborted.'));
        return;
      }

      // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // final String? idToken = googleAuth.idToken;

      // if (idToken == null) {
      //   emit(LoginErrorState('Failed to retrieve ID token.'));
      //   return;
      // }

      // Pass the entire googleUser data to your backend
      await _loginWithGoogleUser(googleUser);
    } catch (error) {
      emit(LoginErrorState('Google sign-in error: ${error.toString()}'));
      print('Google sign-in error: ${error.toString()}');
    }
  }

  Future<void> _loginWithGoogleUser(GoogleSignInAccount googleUser) async {
    try {
      // Extract relevant data from googleUser
      final userData = {
        "id": googleUser.id,
        "name": googleUser.displayName,
        "email": googleUser.email,
        "image": googleUser.photoUrl,
      };

      final response = await DioHelper.postData(
        method: GOOGLE_LOGIN,
        data: userData,
      );

      loginModel = LoginModel.fromJson(response.data);
      if (loginModel.status) {
        await CacheHelper.saveData(key: 'token', value: loginModel.data?.token ?? "");
        await CacheHelper.saveData(key: 'image', value: loginModel.data?.image ?? "");
        await CacheHelper.saveData(key: 'name', value: loginModel.data?.name ?? "");
        await CacheHelper.saveData(key: 'email', value: loginModel.data?.email ?? "");
        Get.offAll(() => HomeLayout());
      } else {
        emit(LoginErrorState('Login failed, please try again.'));
      }
    } catch (error) {
      emit(LoginErrorState('Google login error: $error'));
      print('Google login error: $error');
    }
  }

  // Future<void> signInWithGoogle() async {
  //   emit(LoginLoadingState());
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     print('Google User: $googleUser');
  //     if (googleUser == null) {
  //       // User cancelled the sign-in
  //       emit(LoginErrorState('Google sign-in aborted.'));
  //       return;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     // Ensure that idToken is retrieved
  //     final String? idToken = googleAuth.idToken;
  //     print('Google Auth ID Token: $idToken');
  //     if (idToken == null) {
  //       emit(LoginErrorState('Failed to retrieve ID token.'));
  //       print('Failed to retrieve ID token.');
  //       return;
  //     }
  //
  //     // Pass the idToken to your backend
  //     await _loginWithGoogleToken(idToken);
  //   } catch (error) {
  //     emit(LoginErrorState('Google sign-in error: ${error.toString()}'));
  //     print('Google sign-in error: ${error.toString()}');
  //   }
  // }
  //
  // Future<void> _loginWithGoogleToken(String token) async {
  //   // final String fullUrl = _buildUrl(GOOGLE_LOGIN);
  //   try {
  //     final response = await DioHelper.postData(
  //       method: GOOGLE_LOGIN,
  //       data: {
  //         "token": token,
  //       },
  //     );
  //
  //     loginModel = LoginModel.fromJson(response.data);
  //     if (loginModel.status) {
  //       await CacheHelper.saveData(key: 'token', value: loginModel.data?.token ?? "");
  //       await CacheHelper.saveData(key: 'image', value: loginModel.data?.image ?? "");
  //       await CacheHelper.saveData(key: 'name', value: loginModel.data?.name ?? "");
  //       await CacheHelper.saveData(key: 'email', value: loginModel.data?.email ?? "");
  //       Get.offAll(() => HomeLayout());
  //     } else {
  //       emit(LoginErrorState('Login failed, please try again.'));
  //     }
  //   } catch (error) {
  //     emit(LoginErrorState('Google login error: $error'));
  //     print('Google login error: $error');
  //   }
  // }
}
