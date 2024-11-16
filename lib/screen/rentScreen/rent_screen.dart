import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_cubit.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_states.dart';
import 'package:flutter/services.dart';
import '../../models/rent_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/home_data_model.dart';
import '../../widgets/loadingPlaceholder.dart';
import '../BuyScreen/brand_screen.dart';

class RentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RentCubit, RentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: RentCubit.get(context).rentDataModel != null,
          builder: (context) =>
              productsBuilder(RentCubit.get(context).rentDataModel, context),
          fallback: (context) => Center(child: LoadingPlaceholder()),
        );
      },
    );
  }

  Widget productsBuilder(RentDataModel? rentDataModel, BuildContext context) {
    RentCubit Rentcubit = RentCubit.get(context);
    HomeCubit cubits = HomeCubit.get(context);
    final RentData = rentDataModel?.data.rentData ?? [];
    final brands = cubits.homeDataModel?.data.brands ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: RentData.length < 3 ? RentData.length : 3,
                  itemBuilder: (context, index) =>
                      ItemBuilder(RentData[index], context),
                ),
              ],
            ),
            if (brands.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.branding_watermark_outlined,
                      color: Colors.red,
                      size: 24.0.sp,
                    ),
                    SizedBox(width: 10.0.w),
                    Text(
                      "Select Hiring Service",
                      style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                        color: cubits.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
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
            Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: RentData.length - 3,
                  itemBuilder: (context, index) =>
                      ItemBuilder(RentData[index + 3], context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ItemBuilder(RentData? product, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return Padding(
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
                        // Title (Service type or name)
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
                            print('price: ${product?.price}');
                            print('Id: ${product?.id}');
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
          return Padding(
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
                            imageUrl:  '',
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
          );
        },
      ),
    );
  }
}
