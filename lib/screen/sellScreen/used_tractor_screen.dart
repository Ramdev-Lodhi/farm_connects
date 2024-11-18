import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
import 'package:flutter/services.dart';
import '../../config/network/local/cache_helper.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../widgets/snackbar_helper.dart';
import '../BuyScreen/tractors_by_brand_screen.dart';
import '../sellScreen/used_tractor_details_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cubits/sell_cubit/sell_States.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';
import '../../models/home_data_model.dart';
import '../../models/sell_model.dart';
import '../../widgets/loadingIndicator.dart';
import '../../widgets/loadingPlaceholder.dart';
import '../BuyScreen/brand_screen.dart';

class UsedTractorScreen extends StatefulWidget {
  @override
  State<UsedTractorScreen> createState() => _UsedTractorScreenState();
}

class _UsedTractorScreenState extends State<UsedTractorScreen> {
  String? selectedBrand;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellCubit, SellFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SellCubit.get(context).sellAllTractorData != null,
          builder: (context) => productsBuilder(
              SellCubit.get(context).sellAllTractorData, context),
          fallback: (context) => Center(child: LoadingPlaceholder()),
        );
      },
    );
  }

  Widget productsBuilder(SellAllTractorData? sellAllTractorData, context) {
    SellCubit cubit = SellCubit.get(context);
    HomeCubit cubits = HomeCubit.get(context);
    final tractors = sellAllTractorData?.data.SellTractor ?? [];
    final brands = HomeCubit.get(context).homeDataModel?.data.brands ?? [];
    final filteredTractors = selectedBrand != null
        ? tractors.where((tractor) => tractor.brand == selectedBrand).toList()
        : tractors;
// print('sell = ${sellAllTractorData?.data.SellTractor}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// Display first two tractors
            Column(
              children: List.generate(
                filteredTractors.length < 2 ? filteredTractors.length : 2,
                (index) => tractorItemBuilder(filteredTractors[index], context),
              ),
            ),

// Display brands list
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
                      "Select your favorite brands",
                      style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                        color: cubits.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              gridBrandsBuilder(HomeCubit.get(context).homeDataModel, context),
              TextButton(
                onPressed: () {
                  Get.to(AllBrandScreen());
                },
                child: Text(
                  "View All Brands   ➞",
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w600,
                    color: cubits.isDark ? Colors.blue : Colors.blue,
                  ),
                ),
              ),
            ],

// Display remaining tractors
            Column(
              children: List.generate(
                filteredTractors.length > 6
                    ? 4
                    : (filteredTractors.length - 2).clamp(0, 4),
                (index) =>
                    tractorItemBuilder(filteredTractors[index + 2], context),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        color: Colors.orange,
                        size: 24.0.sp,
                      ),
                      SizedBox(width: 10.0.w),
                      Text(
                        " Select tractor by HP",
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.bold,
                          color: cubits.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    children: [
                      budgetOption("Under 20 HP", context),
                      budgetOption("21 - 30 HP", context),
                      budgetOption("31 - 40 HP", context),
                      budgetOption("41 - 45 HP", context),
                      budgetOption("46 - 50 HP", context),
                      budgetOption("51 - 60 HP", context),
                      budgetOption("61 - 75 HP", context),
                      budgetOption("Above 75 HP", context),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(
                (tractors.length - 6).clamp(0, 6),
                (index) => tractorItemBuilder(tractors[index + 6], context),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payments,
                        color: Colors.green,
                        size: 24.0.sp,
                      ),
                      SizedBox(width: 10.0.w),
                      Text(
                        "Select your budget",
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.bold,
                          color: cubits.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    children: [
                      budgetOption("Under 3 Lakhs", context),
                      budgetOption("3 to 5 Lakhs", context),
                      budgetOption("5 to 7 Lakhs", context),
                      budgetOption("7 to 10 Lakhs", context),
                      budgetOption("Above 10 Lakhs", context),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(
                tractors.length > 12 ? tractors.length - 12 : 0,
                (index) => tractorItemBuilder(tractors[index + 12], context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget budgetOption(String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Selected budget: $label");
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
// padding: EdgeInsets.all(8.0),
        height: 20.0,
        decoration: BoxDecoration(
          color: Colors.green.shade200,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Text color
            ),
          ),
        ),
      ),
    );
  }

  Widget tractorItemBuilder(SellData? product, BuildContext context) {
// SellCubit cubit = SellCubit.get(context);
    HomeCubit cubit = HomeCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: GestureDetector(
        onTap: () {
          Get.to(() => UsedTractorDetails(selltractor: product));
        },
        child: Card(
          elevation: 1,
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(8.0),
            color: cubit.isDark ? Colors.grey[800] : Colors.white,
            child: Container(
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: SizedBox(
                          height: 190.w,
                          child: CachedNetworkImage(
                            imageUrl: product?.image ?? '',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${product?.brand ?? ''} ${product?.modelname ?? ''}'
                                .trim(),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'HP: ${product?.modelHP ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.grey[400]
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'State: ${product?.state ?? 'N/A'} ',
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.grey[400]
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return sellerContactDialog(
                                          product, context);
                                    },
                                  );
                                },
                                child: Text("Contact Seller",
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget gridBrandsBuilder(HomeDataModel? homeDataModel, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    final brands = homeDataModel?.data.brands ?? [];

    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
// itemCount: brands.length,
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final product = brands[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                selectedBrand = product.name;
                  Get.to(() => TractorsByBrandScreen(brandName: product.name, brandId: product.id));

                setState(() {});
              },
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
                              imageUrl: product.image ?? '',
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                product.name ?? '',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
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

  Widget gridTractorsBuilder(
      SellAllTractorData? SellAllTractorData, BuildContext context) {
// SellCubit cubit = SellCubit.get(context);
    HomeCubit cubit = HomeCubit.get(context);
    return SizedBox(
      height: 460.h,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 2,
        itemBuilder: (context, index) {
          final product = SellAllTractorData?.data.SellTractor[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 4.0.h),
            child: Card(
              elevation: 1,
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(8.0),
                color: cubit.isDark ? Colors.grey[800] : Colors.white,
                child: Container(
                  width: 300.w,
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
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${product?.brand ?? ''} ${product?.modelname ?? ''}',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'HP: ${product?.modelHP ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark
                                          ? Colors.grey[400]
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'State: ${product?.state ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark
                                          ? Colors.grey[400]
                                          : Colors.black,
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

  Widget sellerContactDialog(selltractors, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: 450.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seller Contact Form", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10.0),
                TextFormField(
                  initialValue: CacheHelper.getData(key: 'name') ?? "",
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue:
                      '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}',
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue:
                      ProfileCubits.get(context).profileModel.data?.mobile ??
                          "",
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mobile';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Budget',
                    prefixIcon: Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Budget';
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
                  margin: EdgeInsets.only(bottom: 0), // Set bottom margin to 0
                  child: SizedBox(
                    width: 150, // Set the desired width here
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Get.to(() =>
                              UsedTractorDetails(selltractor: selltractors));
                        }
                      },
                      child: Text("Contact Seller",
                          style: TextStyle(color: Colors.white)),
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
        ),
      ),
    );
  }
}
