import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:farm_connects/constants/palette.dart';
import 'package:get/get.dart';
import '../../controller/loginC.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final LoginController = Get.put(LoginC());
  bool isSignupScreen = false;
  bool isMale = true;
  bool isRememberMe = false;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();

  // Controllers for Signup
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController pincode = TextEditingController();
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
    signinEmailController.dispose();
    signinPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (isSignupScreen) {
      if (_formKey.currentState!.validate()) {
        LoginController.Signup(
          username.text.trim(),
          int.parse(phone.text.trim()),
          address.text.trim(),
          int.parse(pincode.text.trim()),
          password.text.trim(),
        );
      }
    } else {
      if (_signinFormKey.currentState!.validate()) {
        LoginController.Signin(
          signinEmailController.text.trim(),
          signinPasswordController.text.trim(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery
        .of(context)
        .viewInsets
        .bottom != 0;
    final topPosition = isSignupScreen
        ? (keyboardOpen ? 50 : 150)
        : (keyboardOpen ? 150 : 150);
    final heightPosition = isSignupScreen
        ? (keyboardOpen ? 450 : 500)
        : (keyboardOpen ? 340 : 320);

    return Scaffold(
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
                              text:
                              isSignupScreen ? " Farm Connects," : " Back,",
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 40,
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
                    Expanded(child: Form(
                        key: _formKey, child: buildSignupSection())),
                  if (!isSignupScreen)
                    Expanded(child: Form(
                        key: _signinFormKey, child: buildSigninSection())),
                  SizedBox(
                    height: 25,
                  ),

                ],
              ),
            ),
          ),
          buildBottomHalfContainer(false),
          Positioned(
            top: MediaQuery
                .of(context)
                .size
                .height - 100,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(isSignupScreen
                    ? "Or Signup with"
                    : "Or Signin with"),
                Container(
                  margin:
                  EdgeInsets.only(right: 20, left: 20, top: 15),
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
  }

  TextButton buildTextButton(IconData icon, String title,
      Color backgroundColor) {
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

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(
            FontAwesomeIcons.envelope,
            "example@gmail.com",
            false,
            TextInputType.text,
            signinEmailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
              //   return 'Please enter a valid 10-digit phone number';
              // }
              return null;
            },
          ),
          buildTextField(
            FontAwesomeIcons.lock,
            "**********",
            true,
            TextInputType.text,
            signinPasswordController,
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
                        isRememberMe = !isRememberMe;
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
// Google Sign-In Button
//           SizedBox(height: 10),
//           ElevatedButton.icon(
//             onPressed: () {
//               // Trigger Google sign-in process here
//               // LoginController.signInWithGoogle();
//             },
//             icon: Icon(FontAwesomeIcons.google, color: Colors.white),
//             label: Text("Sign in with Google"),
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.red[400],
//               // Text color
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//             ),
//           ),
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
            buildTextField(
              FontAwesomeIcons.user,
              "User Name",
              false,
              TextInputType.text,
              username,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            buildTextField(
              FontAwesomeIcons.phone,
              "Phone",
              false,
              TextInputType.number,
              phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
            buildTextField(
              FontAwesomeIcons.addressCard,
              "Address",
              false,
              TextInputType.text,
              address,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            buildTextField(
              FontAwesomeIcons.locationPin,
              "Pincode",
              false,
              TextInputType.number,
              pincode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your pincode';
                } else if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                  return 'Please enter a valid 6-digit pincode';
                }
                return null;
              },
            ),
            buildTextField(
              FontAwesomeIcons.lock,
              "Password",
              true,
              TextInputType.text,
              password,
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
            // Google Sign-Up Button
            // SizedBox(height: 10),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // Trigger Google sign-up process here
            //     // LoginController.signUpWithGoogle();
            //   },
            //   icon: Icon(FontAwesomeIcons.google, color: Colors.white),
            //   label: Text("Sign up with Google"),
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: Colors.white,
            //     backgroundColor: Colors.red[400],
            //     // Text color
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      TextInputType inputType, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
        validator: validator,
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    final keyboardOpen = MediaQuery
        .of(context)
        .viewInsets
        .bottom != 0;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 600),
      curve: Curves.bounceInOut,
      // Dynamically adjust the 'top' position based on signup or signin and keyboard state
      top: isSignupScreen
          ? (keyboardOpen ? 460 : 610) // Move up when the keyboard is open
          : (keyboardOpen ? 450 : 430),
      right: 0,
      left: screenWidth * 0.4,
      // Responsive left positioning (30% of screen width)
      child: Center(
        child: GestureDetector(
          onTap: _submitForm, // Call the form submission method directly

          child: !showShadow
              ? Container(
            height: screenWidth * 0.1, // Adjust height based on screen width
            width: screenWidth * 0.35, // Adjust width based on screen width
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

