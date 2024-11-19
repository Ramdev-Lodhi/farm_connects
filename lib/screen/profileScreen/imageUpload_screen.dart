import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farm_connects/cubits/profile_cubit/profile_states.dart';
import '../../config/network/local/cache_helper.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../widgets/loadingIndicator.dart';

class ImageDialog extends StatefulWidget {
  final ProfileCubits profileCubit;
  ImageDialog({required this.profileCubit});
  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubits, ProfileState>(
      listener: (context, state) {

        if (state is ProfileImageLaodingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is ProfileImageErrorState) {
          setState(() {
            _isLoading = false;
          });
        }else{
          _isLoading = false;
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        Color textColor = cubit.isDark ? Colors.white : Colors.black;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 350,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoading
                    ? Center(child: LoadingIndicator(size: 100))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                      : Image.network(widget.profileCubit.profileModel.data?.image
                     ?? CacheHelper.getData(key: 'image'),
                        // 'https://res.cloudinary.com/farmconnects/image/upload/v1728409875/user_kzxegi.jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 100),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showImageSourceDialog(),
                  icon: Icon(Icons.photo_camera_sharp),
                  label: Text("Select Photo", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            height: 210.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10.h),
                Text("Select Profile Image", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _selectedImage = File(image.path);
                      });
                      widget.profileCubit.updateProfileImage(image);
                    }
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.photo_library, color: Colors.white),
                  label: Text("Select from Gallery",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.black12,
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        _selectedImage = File(image.path);
                      });
                      widget.profileCubit.updateProfileImage(image);
                    }
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  label: Text("Take a Photo",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.black12,
                  height: 10,
                ),
                // Use Spacer to push the button down
                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 0), // Set bottom margin to 0
                  child: SizedBox(
                    width: 150, // Set the desired width here
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          Text("Close", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF202A44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
