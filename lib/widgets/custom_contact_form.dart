import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../config/network/local/cache_helper.dart';
import '../cubits/mylead_cubit/mylead_cubits.dart';
import '../cubits/rent_cubit/rent_cubit.dart';
import '../cubits/profile_cubit/profile_cubits.dart';

class CustomContactForm extends StatefulWidget {
  final dynamic product;

  const CustomContactForm({Key? key, required this.product}) : super(key: key);

  @override
  _CustomContactFormState createState() => _CustomContactFormState();
}

class _CustomContactFormState extends State<CustomContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? location;
  String? mobile;
  String? userId;
  DateTime? serviceFromDate;
  DateTime? serviceToDate;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with data from the product
    name = CacheHelper.getData(key: 'name') ?? "";
    location =
    '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}';
    mobile = ProfileCubits.get(context).profileModel.data?.mobile ?? "";
    userId = ProfileCubits.get(context).profileModel.data?.id ?? "";
    // print(userId);
    // print(mobile);
  }

  void insertrentdata() {
    print(serviceFromDate);
    print(serviceToDate);
    var rentcubit = RentCubit.get(context);
    rentcubit.InsertrentContactData(
      widget.product.id,
      widget.product.image,
      widget.product.servicetype,
      widget.product.userId,
      widget.product.userInfo.name,
      userId!,
      name!,
      mobile!,
      location!,
        serviceFromDate!,
        serviceToDate!

    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      insetPadding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Contact Form",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                // Name Field
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                // Location Field
                TextFormField(
                  initialValue: location,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => location = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                // Mobile Field
                TextFormField(
                  initialValue: mobile,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => mobile = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mobile number';
                    }
                    // else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    //   return 'Enter a valid 10-digit number';
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                // Service From Date Picker
                datePicker(
                  label: "Service From",
                  selectedDate: serviceFromDate,
                  onDateSelected: (pickedDate) {
                    setState(() => serviceFromDate = pickedDate);
                  },
                  context: context
                ),
                const SizedBox(height: 12.0),
                // Service To Date Picker
                datePicker(
                  label: "Service To",
                  selectedDate: serviceToDate,
                  onDateSelected: (pickedDate) {
                    setState(() => serviceToDate = pickedDate);
                  },
               context: context
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (serviceFromDate == null || serviceToDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select both dates")),
                        );
                        return;
                      }
                      insertrentdata();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Contact Owner",style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF009688),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
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

  Widget datePicker({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
    required BuildContext context, // Add context as a required parameter
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.date_range),
              SizedBox(width: 10),
              Text(
                selectedDate != null
                    ? selectedDate.toLocal().toString().split(' ')[0] // Display in "YYYY-MM-DD" format
                    : 'Select Date',
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (pickedDate != null) {
                onDateSelected(pickedDate); // Pass the picked date back
              }
            },
          ),
        ],
      ),
    );
  }
}