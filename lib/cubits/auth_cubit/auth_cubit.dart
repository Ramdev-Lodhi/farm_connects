import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../layout/home_layout.dart';
import '../../models/login_model.dart';
import '../../screen/authScreen/login_signup.dart';
import '../../widgets/snackbar_helper.dart';
import '../auth_cubit/auth_states.dart';

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
      print('error : ' + error.toString());
    });
  }

  Future<void> Signin(String email, String password) async {
    emit(LoginLoadingState());
    isLoading = true;
    print("LoginLoadingState emitted");
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
      print(loginModel.status);
      if (loginModel.status) {
        CacheHelper.saveData(key: 'token', value: loginModel.data?.token ?? "");
        CacheHelper.saveData(key: 'image', value: loginModel.data?.image ?? "");
        CacheHelper.saveData(key: 'name', value: loginModel.data?.name ?? "");
        CacheHelper.saveData(key: 'email', value: loginModel.data?.email ?? "");
        isLoading = false;
        emit(LoginSuccessState("User login successful."));
        showCustomSnackbar('Login Success', 'User login successful.',
            isError: false);
        Get.offAll(() => HomeLayout());
      } else {
        isLoading = false;
        emit(LoginErrorState(loginModel.message ?? 'Login failed.'));
        showCustomSnackbar(
            'Login Failed', 'Username and password incorrect Please try again.',
            isError: true);
        // print("login Failed. Please try again.");
      }
    }).catchError((error) {
      isLoading = false;
      emit(LoginErrorState(error.toString()));
      showCustomSnackbar(
          'Login Failed', 'Username and password incorrect Please try again.',
          isError: true);
      print('error : ' + error.toString());
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
      final response = await DioHelper.postData(
        method: "google",
        data: {
          "token": token,
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
        emit(LoginSuccessState("Google login successful."));
        Get.offAll(() => HomeLayout());
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
}
