import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_cubit.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_states.dart';
import 'package:farm_connects/models/rent_model.dart';
import 'package:farm_connects/screen/rentScreen/rent_detials_screen.dart';
import 'package:flutter/services.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/styles/colors.dart';
import '../../cubits/mylead_cubit/mylead_cubits.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/home_data_model.dart';
import '../../models/rent_model.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/custom_contact_form.dart';
import '../../widgets/placeholder/rentscreen_placeholder.dart';

class RentScreen extends StatefulWidget {
  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? mobile;
  String? location;
  String? price;
  String? inputpincode;
  String? _pincode;
  String? _selectedService;
  DateTime? serviceFromDate;
  DateTime? serviceToDate;
  List<RentData> filteredRentServices = [];
  // List<ServicesType> serviceList = [];
  @override
  void initState() {
    super.initState();
    RentCubit.get(context)
      ..GetRentData();
    name = CacheHelper.getData(key: 'name') ?? "";
    inputpincode = CacheHelper.getData(key: 'pincode') ?? "";
    _pincode = CacheHelper.getData(key: 'pincode') ?? "";
    location =
    '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(
        key: 'subDistrict') ?? ''}';
    mobile = ProfileCubits
        .get(context)
        .profileModel
        .data
        ?.mobile ?? "";
  }
  void insertrentdata(rentcontactdata) {
    var mylead = MyleadCubits.get(context);
    mylead.InsertrentContactData(
        rentcontactdata.image,
        rentcontactdata.servicetype,
        rentcontactdata.userId,
        rentcontactdata.userInfo.name,
        name!,
        mobile!,
        location!,
        rentcontactdata.price);
  }
  void _filterRentData(String? enteredPincode, RentDataModel? rentDataModel) {
    if (rentDataModel == null) return;

    final rentData = rentDataModel.data.rentData ?? [];
    setState(() {
      inputpincode = enteredPincode;
      filteredRentServices = rentData.where((rentData) {
        final matchesPincode = rentData.address?.pincode == enteredPincode;
        final matchesService = _selectedService == null ||
            rentData.servicetype == _selectedService;
        return matchesPincode && matchesService;
      }).toList();
    });
    // setState(() {
    //   inputpincode = enteredPincode;
    //   filteredRentServices = rentData.where((rentData) {
    //     return (rentData.address?.pincode == enteredPincode);
    //   }).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RentCubit, RentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: RentCubit
              .get(context)
              .rentDataModel != null,
          builder: (context) =>
              _buildOverview(RentCubit
                  .get(context)
                  .rentDataModel, context),
          fallback: (context) => Center(child: RentscreenPlaceholder()),
        );
      },
    );
  }

  Widget _buildOverview(RentDataModel? rentDataModel, BuildContext context) {
    HomeCubit cubits = HomeCubit.get(context);
    // final serviceList = cubits.homeDataModel?.data.services ?? [];
    if (filteredRentServices.isEmpty && rentDataModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _filterRentData(inputpincode, rentDataModel);
      });
    }
    List<String> serviceList = [];
    serviceList = HomeCubit
        .get(context)
        .homeDataModel
        ?.data
        .services
        .map((service) => service.service)
        .toList() ??
        [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: cubits.isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Search Pincode",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cubits.isDark ? Colors.white : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _filterRentData(value, RentCubit.get(context).rentDataModel);
                    } else {
                      _filterRentData(_pincode, RentCubit.get(context).rentDataModel);
                    }
                  },
                ),
              ),
              SizedBox(width: 10),

              // // Service Type Dropdown
              Expanded(
                child: CustomDropdown(
                  hint: "Select Service Type",
                  items: serviceList,
                  value: _selectedService,
                  onChanged: (value) {
                    setState(() => _selectedService = value);
                    if (inputpincode != null) {
                      _filterRentData(inputpincode, RentCubit.get(context).rentDataModel);
                    } else {
                      _filterRentData(_pincode, RentCubit.get(context).rentDataModel);
                    }
                  },

                  label: _selectedService != null ? "Service Type" : "",
                ),
              ),
            ],
          ),
        ),

        // Filtered Data Display
        Expanded(
          child: filteredRentServices.isEmpty
              ? Center(
            child: Text(
              "No Service Available for this Pincode",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cubits.isDark ? Colors.white : Colors.black,
              ),
            ),
          )
              : productsBuilder(filteredRentServices, context),
        ),
      ],
    );
  }

  Widget productsBuilder(List<RentData> filteredRentServices,
      BuildContext context) {
    HomeCubit cubits = HomeCubit.get(context);
    final services = cubits.homeDataModel?.data.services ?? [];
    if (filteredRentServices != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, -20),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredRentServices.length < 3
                      ? filteredRentServices.length
                      : filteredRentServices.length,
                  itemBuilder: (context, index) =>
                      ItemBuilder(filteredRentServices[index], context),
                ),
              ),
              // if (services.isNotEmpty) ...[
              //   _sectionHeader(context, 'Select Hiring Service'),
              //   gridServiceBuilder(cubits.homeDataModel, context),
              //   TextButton(
              //     onPressed: () {},
              //     child: Text(
              //       "View All Services   ➞",
              //       style: TextStyle(
              //         fontSize: 18.0.sp,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.blue,
              //       ),
              //     ),
              //   ),
              // ],
              // Transform.translate(
              //   offset: Offset(0, -25),
              //   child: ListView.builder(
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: filteredRentServices.length < 3
              //         ? 0
              //         : filteredRentServices.length - 3,
              //     itemBuilder: (context, index) =>
              //         ItemBuilder(filteredRentServices[index + 3], context),
              //   ),
              // ),
            ],
          ),
        ),
      );
    } else {
      // When no rent data is available
      return Center(
        child: Text('No Rent Data Available'),
      );
    }
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final cubit = HomeCubit.get(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: cubit.isDark ? asmarFate7 : offWhite,
        width: double.infinity,
        padding: EdgeInsets.only(left: 5.0.w, top: 7.5.h, bottom: 7.5.h),
        child: Row(
          children: [
            Icon(
              Icons.branding_watermark_outlined,
              color: Colors.red,
              size: 24.0.sp,
            ),
            SizedBox(width: 15.0.w),
            Text(
              '$title'.toUpperCase(),
              style: TextStyle(
                  color: cubit.isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget ItemBuilder(RentData? product, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return GestureDetector(
      onTap: () {
        Get.to(() => RentDetialsScreen(rentdata: product));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0.h),
        child: Card(
          elevation: 1,
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(8.0),
            color: cubit.isDark ? Colors.grey[800] : Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: SizedBox(
                          height: 120.w,
                          width: 120.w,
                          child: CachedNetworkImage(
                            imageUrl: product?.image ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product?.servicetype}'.trim(),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                          ),

                          SizedBox(height: 8.0),
                          Text("₹ ${product?.price}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.0),
                          Text(
                            'Location: ${product?.address?.village ==
                                'No villages'
                                ? product?.address?.sub_district
                                : product?.address?.village}  (${product
                                ?.address?.pincode}) ',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              color:
                              cubit.isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomContactForm(product: product);
                                },
                              );
                            },

                            child: Text("Contact Owner",
                                style: TextStyle(color: Colors.white)),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget gridServiceBuilder(HomeDataModel? homeDataModel,
      BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    final services = homeDataModel?.data.services ?? [];
    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // itemCount: brands.length,
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () {
              print(service.service);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 5.0, vertical: 8.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(5.0),
                color: cubit.isDark ? Colors.grey[800] : Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 110.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50.h,
                            width: 60.w,
                            child: CachedNetworkImage(
                              imageUrl: service.image ?? '',
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                service.service ?? '',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                  cubit.isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget rentContactDialog(rentserviceData, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      insetPadding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Container(
          height: 500.0, // Increased height to fit date pickers
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Owner Contact Form", style: TextStyle(fontSize: 20)),
                  // Name Field
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                    onSaved: (value) => name = value,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  // Location Field
                  TextFormField(
                    initialValue: location,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                    onSaved: (value) => location = value,
                    onChanged: (value) {
                      setState(() {
                        location = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Location';
                      }
                      return null;
                    },
                  ),
                  // Mobile Field
                  TextFormField(
                    initialValue: mobile,
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                    onSaved: (value) => mobile = value,
                    onChanged: (value) {
                      setState(() {
                        mobile = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Mobile';
                      } else if (value.length != 10) {
                        return 'Please enter a valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  // Service From Date Picker
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Service From: ${serviceFromDate != null
                            ? serviceFromDate?.toLocal().toString().split(
                            ' ')[0]
                            : 'Select Date'}"),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                  Duration(days: 365)), // Up to one year
                            );
                            if (pickedDate != null) {
                              setState(() {
                                serviceFromDate = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Service To Date Picker
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Service To: ${serviceToDate != null
                            ? serviceToDate?.toLocal().toString().split(' ')[0]
                            : 'Select Date'}"),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            if (serviceFromDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                    "Please select Service From date first!")),
                              );
                              return;
                            }
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: serviceFromDate!.add(
                                  Duration(days: 1)),
                              firstDate: serviceFromDate!.add(
                                  Duration(days: 1)),
                              lastDate: DateTime.now().add(
                                  Duration(days: 365)), // Up to one year
                            );
                            if (pickedDate != null) {
                              setState(() {
                                serviceToDate = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: SizedBox(
                      width: 150, // Set the desired width here
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (serviceFromDate == null ||
                                serviceToDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Please select both dates")),
                              );
                              return;
                            }
                            insertrentdata(rentserviceData);
                            Navigator.pop(context);
                            Get.to(() =>
                                RentDetialsScreen(rentdata: rentserviceData));
                          }
                        },
                        child: Text("Contact Owner",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009688),
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
          ),
        ),
      ),
    );
  }

}
