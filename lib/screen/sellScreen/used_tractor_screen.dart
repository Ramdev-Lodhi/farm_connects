import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
import 'package:flutter/services.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/styles/colors.dart';
import '../../cubits/mylead_cubit/mylead_cubits.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../widgets/placeholder/usedscreen_placeholder.dart';
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
import '../BuyScreen/brand_screen.dart';

class UsedTractorScreen extends StatefulWidget {
  @override
  State<UsedTractorScreen> createState() => _UsedTractorScreenState();
}

class _UsedTractorScreenState extends State<UsedTractorScreen> {
  String? selectedBrand;
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? mobile;
  String? location;
  String? price;

  @override
  void initState() {
    super.initState();
    name = CacheHelper.getData(key: 'name') ?? "";
    location =
    '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}';
    mobile = ProfileCubits.get(context).profileModel.data?.mobile ?? "";
  }

  void insertselldata(sellcontactdata) {
    var mylead = MyleadCubits.get(context);
    mylead.InsertContactData(
        sellcontactdata.image,
        sellcontactdata.modelname,
        sellcontactdata.brand,
        sellcontactdata.sellerId,
        sellcontactdata.name,
        name!,
        mobile!,
        location!,
        price!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellCubit, SellFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SellCubit.get(context).sellAllTractorData != null,
          builder: (context) => productsBuilder(
              SellCubit.get(context).sellAllTractorData, context),
          fallback: (context) => Center(child: UsedScreenPlaceholder()),
        );
      },
    );
  }

  Widget productsBuilder(SellAllTractorData? sellAllTractorData, context) {
    SellCubit cubit = SellCubit.get(context);
    HomeCubit cubits = HomeCubit.get(context);
    final tractors = sellAllTractorData?.data.SellTractor ?? [];
    final brands = HomeCubit.get(context).homeDataModel?.data.brands ?? [];
    // final filteredTractors = selectedBrand != null
    //     ? tractors.where((tractor) => tractor.brand == selectedBrand).toList()
    //     : tractors;
// print('sell = ${sellAllTractorData?.data.SellTractor}');
    if(tractors.isNotEmpty) {
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
                  tractors.length < 2 ? tractors.length : 2,
                      (index) => tractorItemBuilder(tractors[index], context),
                ),
              ),

// Display brands list
              if (brands.isNotEmpty) ...[
                _sectionHeader(
                  context,
                  'Select your favorite brands',
                  Icon(Icons.branding_watermark_outlined),
                  Colors.red,
                ),

                gridBrandsBuilder(HomeCubit
                    .get(context)
                    .homeDataModel, context),
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

              Column(
                children: List.generate(
                  tractors.length > 6 ? 4 : (tractors.length - 2).clamp(0, 4),
                      (index) =>
                      tractorItemBuilder(tractors[index + 2], context),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      context,
                      'Select tractor by HP',
                      Icon(Icons.flash_on),
                      orange,
                    ),
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
                      (index) =>
                      tractorItemBuilder(tractors[index + 6], context),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      context,
                      'Select your budget',
                      Icon(Icons.payments),
                      Colors.green,
                    ),

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
                      (index) =>
                      tractorItemBuilder(tractors[index + 12], context),
                ),
              ),
            ],
          ),
        ),
      );
    }else {
      // When no rent data is available
      return Center(
        child: Text('No Sell Data Available'),
      );
    }
  }

  Widget _sectionHeader(
      BuildContext context, String title, Icon icon, Color color) {
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
              icon.icon,
              color: color,
              size: 24.0.sp,
            ),
            SizedBox(width: 15.0.w),
            Text(
              '$title'.toUpperCase(),
              style: TextStyle(
                color: cubit.isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.0.sp,
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
                                      ? Colors.white
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
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Price: ₹ ${product?.price ?? 'N/A'} ',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
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
                Get.to(() => TractorsByBrandScreen(
                    brandName: product.name, brandId: product.id));

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


  Widget sellerContactDialog(selltractors, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: cubit.isDark ? Colors.grey[800] : Colors.white,
      insetPadding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Container(
          height: 400.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Seller Contact Form", style: TextStyle(fontSize: 20,color: cubit.isDark ? Colors.white : Colors.black)),
                  TextFormField(
                    initialValue: name,
                    style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(Icons.person,color: cubit.isDark ? Colors.white : Colors.black,),
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
                    initialValue: location,
                    style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(Icons.location_on,color: cubit.isDark ? Colors.white : Colors.black,),
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
                  TextFormField(
                    initialValue: mobile,
                    style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      labelStyle:  TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(Icons.phone,color: cubit.isDark ? Colors.white : Colors.black,),
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
                      } else if (value.length != 13) {
                        return 'please enter 10 digit number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(Icons.currency_rupee,color: cubit.isDark ? Colors.white : Colors.black,),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),onSaved: (value) => price = value,
                    onChanged: (value) {
                      setState(() {
                        price = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Budget';
                      }
                      return null;
                    },
                  ),
                  Divider(
                    thickness: 1.5,
                    color: cubit.isDark ? Colors.white :Colors.black12,
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
                            insertselldata(selltractors);
                            Get.back();
                          }
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
          ),
        ),
      ),
    );
  }
}
