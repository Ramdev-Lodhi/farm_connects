import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/screen/BuyScreen/brand_screen.dart';
import 'package:farm_connects/screen/BuyScreen/new_tractors_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/styles/colors.dart';
import '../cubits/rent_cubit/rent_cubit.dart';
import '../models/home_data_model.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_states.dart';
import '../models/rent_model.dart';
import '../widgets/loadingIndicator.dart';
import '../widgets/loadingPlaceholder.dart';
import 'BuyScreen/tractor_details_screen.dart';
import 'BuyScreen/tractors_by_brand_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeDataModel != null,
          builder: (context) =>
              ProductsBuilder(homeDataModel: cubit.homeDataModel),
          fallback: (context) => Center(child: LoadingPlaceholder()),
        );
      },
    );
  }
}

class ProductsBuilder extends StatefulWidget {
  final HomeDataModel? homeDataModel;

  const ProductsBuilder({Key? key, required this.homeDataModel})
      : super(key: key);

  @override
  State<ProductsBuilder> createState() => _ProductsBuilderState();
}

class _ProductsBuilderState extends State<ProductsBuilder>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.get(context);
    final Rentcubit = RentCubit.get(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarousel(widget.homeDataModel, screenHeight),
            _sectionHeader(context, 'New Tractor'),
            gridTractorsBuilder(widget.homeDataModel, context),
            _viewAllButton(context,
                label: "View All Tractors",
                onTap: () => Get.to(() => HomeLayout())),
            _sectionHeader(context, 'Tractor By Brand'),
            _tractorTypeTabBar(context),
            SizedBox(
              height: 320.h,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _newTractorsViewBrands(widget.homeDataModel, context),
                  _usedTractorsBrands(widget.homeDataModel, context),
                ],
              ),
            ),
            _sectionHeader(context, 'Custom Hiring Service'),
            _customHiringService(Rentcubit.rentDataModel, context),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(HomeDataModel? model, double screenHeight) {
    return CarouselSlider(
      items: model?.data.banners.map((e) {
        return CachedNetworkImage(
          imageUrl: e.image,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Icon(Icons.error_outline),
        );
      }).toList(),
      options: CarouselOptions(
        height: screenHeight / 5.2,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        viewportFraction: 1.0,
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final cubit = HomeCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24.0.sp,
          color: cubit.isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _viewAllButton(BuildContext context,
      {required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: onTap,
            child: Text(label, style: TextStyle(color: btn)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: BorderSide(color: btn, width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tractorTypeTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      indicatorColor: Colors.black,
      tabs: [
        Tab(text: 'New Tractors'),
        Tab(text: 'Used Tractors'),
      ],
    );
  }

  Widget _newTractorsViewBrands(
      HomeDataModel? homeDataModel, BuildContext context) {
    return Column(
      children: [
        gridBrandsBuilder(widget.homeDataModel, context),
        _viewAllButton(context,
            label: "View All Brands",
            onTap: () => Get.to(() => AllBrandScreen())),
      ],
    );
  }

  Widget _usedTractorsBrands(
      HomeDataModel? homeDataModel, BuildContext context) {
    return Column(
      children: [
        gridBrandsBuilder(widget.homeDataModel, context),
        _viewAllButton(context,
            label: "View All Brands",
            onTap: () => Get.to(() => AllBrandScreen())),
      ],
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
        return GestureDetector(
          onTap: () async {
            Get.to(() => TractorsByBrandScreen(
                brandName: product?.name, brandId: product?.id));
          },
          child: Material(
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
          ),
        );
      },
    );
  }

  Widget gridTractorsBuilder(
      HomeDataModel? homeDataModel, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return SizedBox(
      height: 279.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        // itemCount: homeDataModel?.data.tractors.length ?? 0,
        itemCount: 6,
        itemBuilder: (context, index) {
          final product = homeDataModel?.data.tractors[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: GestureDetector(
              onTap: () {
                Get.to(() => TractorsDetails(tractor: product!));
              },
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
                                  '${product?.brand ?? ''} ${product?.name ?? ''}'
                                      .trim(),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0.sp, // Increased font size
                                    fontWeight: FontWeight.bold, // Bold text
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black,
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
                                        fontSize: 14.0.sp,
                                        // Increased font size
                                        fontWeight: FontWeight.bold,
                                        // Bold text
                                        color: cubit.isDark
                                            ? Colors.grey[400]
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    // Spacing between HP and CC

                                    // CC text
                                    Text(
                                      'CC: ${product?.engine.capacityCC ?? 'N/A'} CC',
                                      style: TextStyle(
                                        fontSize: 14.0.sp,
                                        // Increased font size
                                        fontWeight: FontWeight.bold,
                                        // Bold text
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
                                      },
                                      child: Text("Check Tractor Price",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF009688),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
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
        },
      ),
    );
  }

  Widget _customHiringService(
      RentDataModel? rentDataModel, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return SizedBox(
      height: 279.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        // itemCount: homeDataModel?.data.tractors.length ?? 0,
        itemCount: 4,
        itemBuilder: (context, index) {
          final product = rentDataModel?.data.rentData[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: GestureDetector(
              onTap: () {
                // Get.to(() => TractorsDetails(tractor: product!));
              },
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${product?.servicetype ?? ''} '.trim(),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        // Increased font size
                                        fontWeight: FontWeight.bold,
                                        // Bold text
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Price: ${product?.price ?? 'N/A'}',
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

                                Text(
                                  'Location: ${product?.village == 'No villages' ? product?.sub_district : product?.village}  (${product?.pincode}) ',
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    // fontWeight: FontWeight.bold,
                                    color: cubit.isDark
                                        ? Colors.grey[400]
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
                                      },
                                      child: Text("Contact Owner",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF009688),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
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
        },
      ),
    );
  }
}
