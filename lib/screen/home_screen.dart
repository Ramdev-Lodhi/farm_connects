import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/home_data_model.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_states.dart';
import '../config/network/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: HomeCubit.get(context).homeDataModel != null,
          // HomeCubit.get(context).categoryModel != null,
          builder: (context) => productsBuilder(
              HomeCubit.get(context).homeDataModel,
              // HomeCubit.get(context).categoryModel,
              context),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(HomeDataModel? homeDataModel, context) {
    HomeCubit cubit = HomeCubit.get(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: homeDataModel?.data.banners.map((e) {
                  return CachedNetworkImage(
                    imageUrl: e.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: screenHeight / 5.2,
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  enableInfiniteScroll: true,
                  initialPage: 0,
                  reverse: false,
                  viewportFraction: 1.0,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              //Categories
              Text(
                'New Tractor',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0.sp,
                  color: cubit.isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              gridTractorsBuilder(homeDataModel, context),
              SizedBox(
                height: 20.0.h,
              ),
              //products
              Text(
                'Tractor By Brand',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0.sp,
                    color: cubit.isDark ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      cubit.toggleNewTractor(!cubit.isNewTractor);
                    },
                    child: Column(
                      children: [
                        Text(
                          'New Tractors',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                            color: cubit.isUsedTractor
                                ? (cubit.isDark ? Colors.white : Colors.black)
                                : (cubit.isDark ? Colors.white : Colors.black),
                          ),
                        ),
                        // Underline
                        if (cubit.isNewTractor) ...[
                          SizedBox(height: 1),
                          // Space between text and underline
                          Container(
                            height: 2,
                            width: 100, // Adjust width as needed
                            color: Colors.green, // Color of the underline
                          ),
                        ]
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0.w),
                  GestureDetector(
                    onTap: () {
                      cubit.toggleUsedTractor(!cubit.isUsedTractor);
                    },
                    child: Column(
                      children: [
                        Text(
                          'Used Tractor',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                            color: cubit.isUsedTractor
                                ? (cubit.isDark ? Colors.white : Colors.black)
                                : (cubit.isDark ? Colors.white : Colors.black),
                          ),
                        ),
                        // Underline
                        if (cubit.isUsedTractor) ...[
                          SizedBox(height: 1),
                          // Space between text and underline
                          Container(
                            height: 2,
                            width: 100, // Adjust width as needed
                            color: Colors.green, // Color of the underline
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),
              gridBrandsBuilder(homeDataModel, context),
              SizedBox(height: 20.h),
              // View All Button
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('View All'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridBrandsBuilder(HomeDataModel? homeDataModel, context) {
    HomeCubit cubit = HomeCubit.get(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 3 items per row
        crossAxisSpacing: 10.0.w,
        mainAxisSpacing: 10.0.h,
        childAspectRatio: 1, // Adjust ratio based on content
      ),
      // itemCount: homeDataModel?.data.brands.length ?? 0,
      itemCount: 12,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final product = homeDataModel?.data.brands[index];
        return Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(5.0),
          color: cubit.isDark ? Colors.grey[800] : Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                  child: CachedNetworkImage(
                    imageUrl: product?.image ?? '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      product?.name ?? '',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w600,
                        color: cubit.isDark ? Colors.white : Colors.black,
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
  Widget gridTractorsBuilder(HomeDataModel? homeDataModel, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return SizedBox(
      height: 220.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        itemCount: homeDataModel?.data.tractors.length ?? 0,
        itemBuilder: (context, index) {
          final product = homeDataModel?.data.tractors[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: Card(
              elevation: 1,
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(8.0),
                color: cubit.isDark ? Colors.grey[800] : Colors.white,
                child: Container(
                  width: 300.w, // Adjust the card width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 170.w,
                          child: CachedNetworkImage(
                            imageUrl: product?.image ?? '',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Display the tractor name
                              Text(
                                product?.name ?? '',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0.sp, // Increased font size
                                  fontWeight: FontWeight.bold, // Bold text
                                  color: cubit.isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              // Row for HP and CC details
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // HP text
                                  Text(
                                    'HP: ${product?.engine.hpCategory ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14.0.sp, // Increased font size
                                      fontWeight: FontWeight.bold, // Bold text
                                      color: cubit.isDark ? Colors.grey[400] : Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10.w), // Spacing between HP and CC
                                  // CC text
                                  Text(
                                    'CC: ${product?.engine.capacityCC ?? 'N/A'} CC',
                                    style: TextStyle(
                                      fontSize: 14.0.sp, // Increased font size
                                      fontWeight: FontWeight.bold, // Bold text
                                      color: cubit.isDark ? Colors.grey[400] : Colors.black,
                                    ),
                                  ),
                                ],
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
        },
      ),
    );
  }
}
