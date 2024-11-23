import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/location/location_permission.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../layout/home_layout.dart';
import '../../models/login_model.dart';
import '../../screen/authScreen/login_signup.dart';
import '../../screen/authScreen/otpScreen/LoginScreen_withOTP.dart';
import '../../widgets/snackbar_helper.dart';
import '../auth_cubit/auth_states.dart';
import '../profile_cubit/profile_cubits.dart';

class AuthCubits extends Cubit<Authstates> {
  AuthCubits() : super(LoginInitialState());

  static AuthCubits get(context) => BlocProvider.of(context);

  late LoginModel loginModel;
  bool isLoading = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        "475762921924-607vhtcp8u4hl3ime3r8mebeb6ehtsbq.apps.googleusercontent.com",
  );

  Future<bool> validateToken(String token) async {
    if (token.isEmpty) {
      _clearCachedData();
      return false;
    }

    try {
      final response = await DioHelper.getData(
        method: 'token_check',
        token: token,
      );
      print(response.data);
      if (response.data['status'] == true) {
        return true;
      }
    } catch (error) {
      print("Error validating token: $error");
    }

     _clearCachedData();
    await _googleSignIn.signOut();
    return false;
  }

  void _clearCachedData() {
    CacheHelper.removeData(key: 'token');
    CacheHelper.removeData(key: 'image');
    CacheHelper.removeData(key: 'name');
    CacheHelper.removeData(key: 'email');
    CacheHelper.removeData(key: 'state');
    CacheHelper.removeData(key: 'district');
    CacheHelper.removeData(key: 'subDistrict');
    CacheHelper.removeData(key: 'village');
    CacheHelper.removeData(key: 'pincode');
  }

  Future<void> Signup(String name, int phone, String address, int pincode,
      String password, String email) async {
    emit(SignupLoadingState());
    isLoading = true;
    DioHelper.postData(
      method: SIGN_UP,
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
      if (value.data['message'] == "User already exists.") {
        isLoading = false;
        emit(SignupErrorState("This user is already registered."));
        showCustomSnackbar('Signup Failed', 'This user is already registered.',
            isError: true);
      } else {
        isLoading = false;
        emit(SignupSuccessState("User registered successfully."));
        showCustomSnackbar('Signup Success', 'User registered successfully.',
            isError: false);
        Get.offAll(() => LoginSignupScreen());
      }
    }).catchError((error) {
      isLoading = false;
      emit(SignupErrorState(error.toString()));
    });
  }

  Future<void> Signin(String email, String password) async {
    emit(LoginLoadingState());
    isLoading = true;
    DioHelper.postData(
      method: LOGIN,
      data: {
        "email": email,
        "password": password,
      },
      lang: 'en',
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      if (loginModel.status) {
        CacheHelper.saveData(key: 'token', value: loginModel.data?.token ?? "");
        CacheHelper.saveData(key: 'image', value: loginModel.data?.image ?? "");
        CacheHelper.saveData(key: 'name', value: loginModel.data?.name ?? "");
        CacheHelper.saveData(key: 'email', value: loginModel.data?.email ?? "");
        isLoading = false;
        emit(LoginSuccessState("User login successful."));
        showCustomSnackbar('Login Success', 'User login successful.',
            isError: false);
        LocationHelper.fetchLocationDetails();
        Get.offAll(() => HomeLayout());
      } else {
        isLoading = false;
        emit(LoginErrorState(loginModel.message ?? 'Login failed.'));
        showCustomSnackbar(
            'Login Failed', 'Username and password incorrect Please try again.',
            isError: true);
      }
    }).catchError((error) {
      isLoading = false;
      emit(LoginErrorState(error.toString()));
      showCustomSnackbar(
          'Login Failed', 'Username and password incorrect Please try again.',
          isError: true);
    });
  }
  Future<void> SigninWithPassword(String phoneOrEmail , String password) async {
    emit(LoginLoadingState());
    isLoading = true;
    String? Firebase_Token = await FirebaseMessaging.instance.getToken();
    DioHelper.postData(
      method: 'loginpassword',
      data: {
        "phone_or_email": phoneOrEmail,
        "password": password,
        "deviceToken":Firebase_Token
      },
      lang: 'en',
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      if (loginModel.status) {
        CacheHelper.saveData(key: 'token', value: loginModel.data?.token ?? "");
        CacheHelper.saveData(key: 'image', value: loginModel.data?.image ?? "");
        CacheHelper.saveData(key: 'name', value: loginModel.data?.name ?? "");
        CacheHelper.saveData(key: 'email', value: loginModel.data?.email ?? "");
        emit(LoginSuccessState("User login successful."));

        // LocationHelper.fetchLocationDetails();
        // Get.offAll(() => HomeLayout());
      } else {
        emit(LoginErrorState('Username and password incorrect Please try again.'));
        // showCustomSnackbar(
        //     'Login Failed', 'Username and password incorrect Please try again.',
        //     isError: true);
      }
    }).catchError((error) {
      isLoading = false;
      emit(LoginErrorState(error.toString()));
      showCustomSnackbar(
          'Login Failed', 'Username and password incorrect Please try again.',
          isError: true);
    });
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    emit(LoginLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        emit(LoginErrorState('Google sign-in aborted.'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      String token = googleAuth.idToken ?? '';
      if (token.isEmpty) {
        isLoading = false;
        emit(LoginErrorState('Failed to obtain Google token.'));
        return;
      }

      await _loginWithGoogleToken(token);
    } catch (error) {
      isLoading = false;
      emit(LoginErrorState(error.toString()));
    }
  }

  Future<void> _loginWithGoogleToken(String token) async {
    try {
      String? Firebase_Token = await FirebaseMessaging.instance.getToken();
      final response = await DioHelper.postData(
        method: "google",
        data: {
          "token": token,
          "deviceToken":Firebase_Token
        },
      );

      loginModel = LoginModel.fromJson(response.data);
      if (loginModel.status) {
        await CacheHelper.saveData(
            key: 'token', value: loginModel.data?.token ?? "");
        await CacheHelper.saveData(
            key: 'image', value: loginModel.data?.image ?? "");
        await CacheHelper.saveData(
            key: 'name', value: loginModel.data?.name ?? "");
        await CacheHelper.saveData(
            key: 'email', value: loginModel.data?.email ?? "");
        isLoading = false;
        // LocationHelper.fetchLocationDetails();
        emit(LoginSuccessState("Google login successful."));
        // Get.offAll(() => HomeLayout());
      } else {
        isLoading = false;
        emit(LoginErrorState(loginModel.message ?? 'Login failed.'));
      }
    } catch (error) {
      isLoading = false;
      emit(LoginErrorState(error.toString()));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    // emit(LogoutState());
    // Get.offAll(() => LoginSignupScreen());
  }

  Future<void> sendOTP(String phoneNumber) async {
    emit(SendOtpLoadingState());
    String? Firebase_Token = await FirebaseMessaging.instance.getToken();
    try {
      final response = await DioHelper.postData(
        method: "send-otp",
        data: {'phone': phoneNumber},
      );
      print(response.data);

      if (response.data['status']) {
        await DioHelper.postData(
          method: NOTIFICATION,
          data: {
            'token': Firebase_Token,
            'title':"OTP",
            'body':"${response.data['data']['otp']} is your OTP for Farm Connects. Please do not share it with anyone."
          },
        );
        emit(SendOtpSuccessState(response.data['message']));
      } else {
        emit(SendOtpErrorState(response.data['message']));
      }
    } catch (error) {
      emit(SendOtpErrorState(error.toString()));
      return Future.error(error);
    }
  }

  Future<void> verifyOTP(
      String phoneNumber, String otpCode) async {
    emit(VerifyOtpLoadingState());
    try {
      String? Firebase_Token = await FirebaseMessaging.instance.getToken();
      final response = await DioHelper.postData(
        method: "verify-otp",
        data: {
          'phone': phoneNumber,
          'otp': otpCode,
          "deviceToken":Firebase_Token
        },
      );
      loginModel = LoginModel.fromJson(response.data);
      if (loginModel.status) {
        await CacheHelper.saveData(
            key: 'token', value: loginModel.data?.token ?? "");
        await CacheHelper.saveData(
            key: 'image', value: loginModel.data?.image ?? "");
        await CacheHelper.saveData(
            key: 'name', value: loginModel.data?.name ?? "");
        await CacheHelper.saveData(
            key: 'email', value: loginModel.data?.email ?? "");

        emit(VerifyOtpSuccessState("Login successful."));
        // LocationHelper.fetchLocationDetails();
        // Get.offAll(() => HomeLayout());
      } else {
        emit(VerifyOtpErrorState(loginModel.message ?? 'Login failed.'));
      }
    } catch (error) {
      emit(VerifyOtpErrorState(error.toString()));

    }
  }

  Future<void> Logout() async {
    emit(LogoutLoadingState());
    String token = CacheHelper.getData(key: 'token') ?? '';
    String? Firebase_Token = await FirebaseMessaging.instance.getToken();
    DioHelper.postData(
      method: 'logout',
      data: {
        "deviceToken":Firebase_Token
      },
      token: token,
      lang: 'en',
    ).then((value) async {
      if (value.data['status']) {
        await _googleSignIn.signOut();
        CacheHelper.removeData(key: 'token');
        CacheHelper.removeData(key: 'image');
        CacheHelper.removeData(key: 'name');
        CacheHelper.removeData(key: 'email');
        CacheHelper.removeData(key: 'state');
        CacheHelper.removeData(key: 'district');
        CacheHelper.removeData(key: 'subDistrict');
        CacheHelper.removeData(key: 'village');
        CacheHelper.removeData(key: 'pincode');
        Get.offAll(() => OTPScreen());
        emit(LogoutSuccessState("User logout successful."));
      } else {
        emit(LogoutErrorState('Logout Failed Please try again.'));
      }
    }).catchError((error) {
      emit(LogoutErrorState(error.toString()));
      showCustomSnackbar(
          'Logout Failed', 'Please try again.',
          isError: true);
    });
  }
}

