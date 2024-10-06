import 'dart:ffi';

import '../../cubits/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../constants//palette.dart';
import '../../controller/loginC.dart';
import '../../cubits/auth_cubit/auth_states.dart';
import '../../widgets/bulidtextfied.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = false;
  bool isRememberMe = false;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();

  // Controllers for Signup
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Controllers for Signin
  final TextEditingController signinEmailController = TextEditingController();
  final TextEditingController signinPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    username.dispose();
    phone.dispose();
    address.dispose();
    pincode.dispose();
    password.dispose();
    email.dispose();
    signinEmailController.dispose();
    signinPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (isSignupScreen) {
      if (_formKey.currentState!.validate()) {
        context.read<AuthCubits>().Signup(
            username.text.trim(),
            int.parse(phone.text.trim()),
            address.text.trim(),
            int.parse(pincode.text.trim()),
            password.text.trim(),
            email.text.trim());
      }
    } else {
      if (_signinFormKey.currentState!.validate()) {
        if (!isRememberMe) {
          // Show a message if Remember Me is not checked
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Please check 'Remember Me' if you want to stay logged in."),
            ),
          );
          return; // Prevent submission if checkbox is not checked
        }
        context.read<AuthCubits>().Signin(
              signinEmailController.text.trim(),
              signinPasswordController.text.trim(),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubits(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body:
              BlocConsumer<AuthCubits, Authstates>(listener: (context, state) {
            if (state is LoginErrorState || state is SignupErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state is LoginErrorState
                        ? state.message
                        : (state as SignupErrorState).error)),
              );
            }
          }, builder: (context, state) {
            final keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
            final topPosition = isSignupScreen
                ? (keyboardOpen ? 50 : 150)
                : (keyboardOpen ? 150 : 300);
            final heightPosition = isSignupScreen
                ? (keyboardOpen ? 450 : 500)
                : (keyboardOpen ? 340 : 320);

            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Palette.backgroundColor,
              body: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/farmlogin.jpg"),
                              fit: BoxFit.fill)),
                      child: Container(
                        padding: EdgeInsets.only(top: 90, left: 20),
                        color: Color(0xFF75e688).withOpacity(.50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Welcome to",
                                  style: TextStyle(
                                    fontSize: 25,
                                    letterSpacing: 2,
                                    color: Colors.yellow[700],
                                  ),
                                  children: [
                                    TextSpan(
                                      text: isSignupScreen
                                          ? " Farm Connects,"
                                          : " Back,",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow[700],
                                      ),
                                    )
                                  ]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              isSignupScreen
                                  ? "Signup to Continue"
                                  : "Signin to Continue",
                              style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  buildBottomHalfContainer(true),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.bounceInOut,
                    top: topPosition.toDouble(),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.bounceInOut,
                      // height: heightPosition.toDouble(),
                      height: heightPosition.toDouble(),
                      // isSignupScreen ? 500 : 380,
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5),
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignupScreen = false;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: !isSignupScreen
                                              ? Palette.activeColor
                                              : Palette.textColor1),
                                    ),
                                    if (!isSignupScreen)
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: Colors.orange,
                                      )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignupScreen = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "SIGNUP",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSignupScreen
                                              ? Palette.activeColor
                                              : Palette.textColor1),
                                    ),
                                    if (isSignupScreen)
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: Colors.orange,
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (isSignupScreen)
                            Expanded(
                                child: Form(
                                    key: _formKey,
                                    child: buildSignupSection())),
                          if (!isSignupScreen)
                            Expanded(
                                child: Form(
                                    key: _signinFormKey,
                                    child: buildSigninSection())),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  buildBottomHalfContainer(false),
                  Positioned(
                    top: MediaQuery.of(context).size.height - 100,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Text(isSignupScreen
                            ? "Or Signup with"
                            : "Or Signin with"),
                        Container(
                          margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildTextButton(FontAwesomeIcons.facebookF,
                                  "Facebook", Palette.facebookColor),
                              buildTextButton(FontAwesomeIcons.google,
                                  "  Google      ", Palette.googleColor),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(width: 1, color: Colors.grey),
          // minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BuildTextField(
              icon: FontAwesomeIcons.user,
              hintText: "User Name",
              isPassword: false,
              inputType: TextInputType.text,
              controller: username,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            BuildTextField(
              icon: FontAwesomeIcons.envelope,
              hintText: "example@gmail.com",
              isPassword: false,
              inputType: TextInputType.text,
              controller: email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            BuildTextField(
              icon: FontAwesomeIcons.phone,
              hintText: "Phone",
              isPassword: false,
              inputType: TextInputType.number,
              controller: phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
            BuildTextField(
              icon: FontAwesomeIcons.addressCard,
              hintText: "city",
              isPassword: false,
              inputType: TextInputType.text,
              controller: address,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            BuildTextField(
              icon: FontAwesomeIcons.locationPin,
              hintText: "Pincode",
              isPassword: false,
              inputType: TextInputType.number,
              controller: pincode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your pincode';
                } else if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                  return 'Please enter a valid 6-digit pincode';
                }
                return null;
              },
            ),
            BuildTextField(
              icon: FontAwesomeIcons.lock,
              hintText: "Password",
              isPassword: true,
              inputType: TextInputType.text,
              controller: password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "By pressing 'Submit' you agree to our ",
                    style: TextStyle(color: Palette.textColor2),
                    children: [
                      TextSpan(
                        text: "term & conditions",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          BuildTextField(
            icon: FontAwesomeIcons.envelope,
            hintText: "example@gmail.com",
            isPassword: false,
            inputType: TextInputType.text,
            controller: signinEmailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          BuildTextField(
            icon: FontAwesomeIcons.lock,
            hintText: "**********",
            isPassword: true,
            inputType: TextInputType.text,
            controller: signinPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = value ?? false; // Handle null case
                      });
                    },
                  ),
                  Text("Remember me",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1))
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text("Forgot Password?",
                    style: TextStyle(fontSize: 12, color: Palette.textColor1)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 600),
      curve: Curves.bounceInOut,
      // Dynamically adjust the 'top' position based on signup or signin and keyboard state
      top: isSignupScreen
          ? (keyboardOpen ? 460 : 610) // Move up when the keyboard is open
          : (keyboardOpen ? 450 : 580),
      right: 0,
      left: screenWidth * 0.4,
      // Responsive left positioning (30% of screen width)
      child: Center(
        child: GestureDetector(
          onTap: _submitForm, // Call the form submission method directly

          child: !showShadow
              ? Container(
                  height:
                      screenWidth * 0.1, // Adjust height based on screen width
                  width:
                      screenWidth * 0.35, // Adjust width based on screen width
                  decoration: BoxDecoration(
                    color: Palette.activeColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1.5,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isSignupScreen ? "SIGN UP" : "LOG IN",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              : Container(
                  height: screenWidth * 0.1,
                  width: screenWidth * 0.35,
                  decoration: BoxDecoration(
                    color: Palette.activeColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1.5,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isSignupScreen ? "SIGN UP" : "LOG IN",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
