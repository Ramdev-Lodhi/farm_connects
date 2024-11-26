import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farm_connects/cubits/profile_cubit/profile_cubits.dart';
import '../../cubits/profile_cubit/profile_states.dart';
import '../../cubits/home_cubit/home_cubit.dart';


class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _password;
  String? _cpassword;
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _isCPasswordVisible = false;

  @override
  void initState() {
    super.initState();
      _password='';
  }


  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var profileCubit = ProfileCubits.get(context);
          profileCubit.changePassword(
            _password!
          );
    }
  }





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
                title: Text('Change Password',textAlign: TextAlign.center,
                    style: TextStyle(color: textColor, fontSize: 15,)),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(height: 8.0),
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
                      SizedBox(height: 20.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _saveProfile();
                          },
                          child: Text("Change Password", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
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



  Widget _buildPasswordTextField({
    required String? initialValue,
    required String label,
    required FormFieldSetter<String> onSaved,
    required Widget suffixIcon, // Change this to Widget
    ValueChanged<String>? onChanged,
    TextInputType keyboardType = TextInputType.emailAddress,
    required bool obscureText,
  }) {
      HomeCubit cubit = HomeCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        style: TextStyle(color:cubit.isDark ? Colors.white : Colors.black ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold,color:cubit.isDark ? Colors.white : Colors.black ),
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
    HomeCubit cubit = HomeCubit.get(context);
    return IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color:cubit.isDark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    );
  }
  Widget _buildCPasswordSuffixIcon() {
    HomeCubit cubit = HomeCubit.get(context);
    return IconButton(
      icon: Icon(
        _isCPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: cubit.isDark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _isCPasswordVisible = !_isCPasswordVisible;
        });
      },
    );
  }
}