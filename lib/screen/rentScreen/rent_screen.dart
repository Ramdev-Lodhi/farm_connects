import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_cubit.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_states.dart';
import 'package:farm_connects/screen/rentScreen/rent_detials_screen.dart';
import 'package:flutter/services.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/styles/colors.dart';
import '../../cubits/mylead_cubit/mylead_cubits.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../models/rent_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/home_data_model.dart';
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
  @override
  void initState() {
    super.initState();
    name = CacheHelper.getData(key: 'name') ?? "";
    location =
    '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}';
    mobile = ProfileCubits.get(context).profileModel.data?.mobile ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RentCubit, RentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: RentCubit.get(context).rentDataModel != null,
          builder: (context) =>
              productsBuilder(RentCubit.get(context).rentDataModel, context),
          fallback: (context) => Center(child: RentscreenPlaceholder()),
        );
      },
    );
  }

  Widget productsBuilder(RentDataModel? rentDataModel, BuildContext context) {
    RentCubit Rentcubit = RentCubit.get(context);
    HomeCubit cubits = HomeCubit.get(context);
    final RentData = rentDataModel?.data.rentData ?? [];
    final services = cubits.homeDataModel?.data.services ?? [];

    return Transform.translate(
      offset: Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: RentData.length < 3 ? RentData.length : 3,
                itemBuilder: (context, index) =>
                    ItemBuilder(RentData[index], context),
              ),
              if (services.isNotEmpty) ...[

                _sectionHeader(context, 'Select Hiring Service'),
                gridServiceBuilder(cubits.homeDataModel, context),
                TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    "View All Services   ➞",
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
              Transform.translate(
                offset: Offset(0, -25),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: RentData.length - 3,
                  itemBuilder: (context, index) =>
                      ItemBuilder(RentData[index + 3], context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      onTap: (){
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
                            'Location: ${product?.village == 'No villages' ? product?.sub_district : product?.village}  (${product?.pincode}) ',
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
                                  return rentContactDialog(
                                      product, context);
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

  Widget gridServiceBuilder(HomeDataModel? homeDataModel, BuildContext context) {
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
            onTap: (){
              print(service.service);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
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
                              imageUrl:  service.image ?? '',
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

  Widget rentContactDialog(rentdata, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      insetPadding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Container(
          height: 400.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Owner Contact Form", style: TextStyle(fontSize: 20)),
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
                  TextFormField(
                    initialValue:
                    location,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),onSaved: (value) => location = value,
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
                  TextFormField(
                    initialValue:
                    mobile,
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
                      }else if (value.length != 13) {
                        return 'please enter 10 digit number';
                      }
                      return null;
                    },
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    // Set bottom margin to 0
                    child: SizedBox(
                      width: 150, // Set the desired width here
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            insertrentdata(rentdata);
                            Get.to(() => RentDetialsScreen(rentdata: rentdata));
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
