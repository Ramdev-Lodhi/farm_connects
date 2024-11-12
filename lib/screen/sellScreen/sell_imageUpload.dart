// File: lib/screen/sellScreen/sell_image_source_dialog.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellImageSourceDialog extends StatefulWidget {
  final Function(XFile images) onImagesSelected; // Callback for selected images

  SellImageSourceDialog({required this.onImagesSelected});

  @override
  _SellImageSourceDialogState createState() => _SellImageSourceDialogState();
}

class _SellImageSourceDialogState extends State<SellImageSourceDialog> {
  final ImagePicker _picker = ImagePicker();
  late XFile _images;

  Future<void> _pickImagesFromGallery() async {
    final XFile? selectedImages = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      setState(() {
        _images = selectedImages;
      });
      widget.onImagesSelected(_images!);
      Navigator.pop(context); // Close dialog after selection
    // } else if (selectedImages != null && selectedImages.length > 4) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("You can select only up to 4 images!")),
    //   );
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      setState(() {
        _images = selectedImage;
      });
      widget.onImagesSelected(_images!);
      Navigator.pop(context); // Close dialog after selection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: 250.0, // Adjust height as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10.0),
            Text("Select Tractor Images", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10.0),
            ElevatedButton.icon(
              onPressed: _pickImagesFromGallery,
              icon: Icon(Icons.photo_library, color: Colors.white),
              label: Text("Select from Gallery", style: TextStyle(color: Colors.white)),
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
              onPressed: _pickImageFromCamera,
              icon: Icon(Icons.camera_alt, color: Colors.white),
              label: Text("Take a Photo", style: TextStyle(color: Colors.white)),
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
            Container(
              margin: EdgeInsets.only(bottom: 0), // Set bottom margin to 0
              child: SizedBox(
                width: 150, // Set the desired width here
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text("Close", style: TextStyle(color: Colors.white)),
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
  }
}
