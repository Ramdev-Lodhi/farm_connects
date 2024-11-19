import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/screen/BuyScreen/brand_screen.dart';
import 'package:farm_connects/screen/rentScreen/rent_detials_screen.dart';
import 'package:farm_connects/screen/sellScreen/sell_Screen.dart';
import 'package:farm_connects/screen/sellScreen/used_tractor_details_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/network/local/cache_helper.dart';
import '../constants/styles/colors.dart';
import '../cubits/profile_cubit/profile_cubits.dart';
import '../cubits/rent_cubit/rent_cubit.dart';
import '../cubits/sell_cubit/sell_cubit.dart';
import '../models/home_data_model.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_states.dart';
import '../models/rent_model.dart';
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
        final sellcubit = SellCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeDataModel != null &&
              sellcubit.sellAllTractorData != null,
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKeyrent = GlobalKey<FormState>();
  final TextEditingController rentlocationController = TextEditingController();
  final TextEditingController rentnameController = TextEditingController();
  final TextEditingController rentmobileController = TextEditingController();
  final TextEditingController rentpriceController = TextEditingController();

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
    final selltractors =
        SellCubit.get(context).sellAllTractorData?.data.SellTractor ?? [];
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCarousel(widget.homeDataModel, screenHeight),
          ),
          _sectionHeader(context, 'New Tractor'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: gridTractorsBuilder(widget.homeDataModel, context),
          ),
          _viewAllButton(
            context,
            label: "View All Tractors",
            onTap: () {
              cubit.changeNavIndex(1);
            },
            // onTap: () => Get.to(() => HomeLayout())
          ),
          _sectionHeader(context, 'Tractor By Brand'),
          _tractorTypeTabBar(context),
          SizedBox(
            height: 350.h,
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _newTractorsViewBrands(widget.homeDataModel, context),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _usedTractorsBrands(widget.homeDataModel, context),
                ),
              ],
            ),
          ),
          _sectionHeader(context, 'Used Tractor'),
          gridsellTractorsBuilder(selltractors, context),
          _viewAllButton(
            context,
            label: "View All Used Tractors",
            onTap: () {
              cubit.changeNavIndex(2);
            },
            // onTap: () => Get.to(() => HomeLayout())
          ),
          _sectionHeader(context, 'Explore Farm Connects'),
          gridExploreBuilder(context),
          SizedBox(height: 10.h),
          _sectionHeader(context, 'Custom Hiring Service'),
          _customHiringService(Rentcubit.rentDataModel, context),
          _viewAllButton(
            context,
            label: "View All Rent Services",
            onTap: () {
              cubit.changeNavIndex(3);
            },
            // onTap: () => Get.to(() => HomeLayout())
          ),
        ],
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: cubit.isDark ? asmarFate7 : offWhite,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
        child: Text(
          '$title'.toUpperCase(),
          style: TextStyle(
              color: cubit.isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.0.sp),
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
    final cubit = HomeCubit.get(context);
    return TabBar(
      controller: _tabController,
      labelColor: cubit.isDark ? offWhite : asmarFate7,
      unselectedLabelColor: cubit.isDark ? offWhite : asmarFate7,
      indicatorColor: cubit.isDark ? offWhite : asmarFate7,
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
                                      onPressed: () {},
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return rentContactDialog(
                                                product, context);
                                          },
                                        );
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

  Widget gridsellTractorsBuilder(selltractors, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        // itemCount: homeDataModel?.data.tractors.length ?? 0,
        itemCount: 6,
        itemBuilder: (context, index) {
          final product = selltractors[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: GestureDetector(
              onTap: () {
                Get.to(() => UsedTractorDetails(selltractor: product!));
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
                                  '${product?.brand ?? ''} ${product?.modelname ?? ''}'
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
                                      'HP: ${product?.modelHP ?? 'N/A'}',
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

                                    // Year text
                                    Text(
                                      'Year: ${product?.year ?? 'N/A'} ',
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
                                Text(
                                  'Price: ${product?.price ?? 'N/A'}',
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

  Widget sellerContactDialog(selltractors, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
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
                  Text("Seller Contact Form", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    initialValue: CacheHelper.getData(key: 'name') ?? "",
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                    margin: EdgeInsets.only(bottom: 0),
                    // Set bottom margin to 0
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

  Widget rentContactDialog(rent, BuildContext context) {
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
              key: _formKeyrent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Owner Contact Form", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    initialValue: CacheHelper.getData(key: 'name') ?? "",
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                    margin: EdgeInsets.only(bottom: 0),
                    // Set bottom margin to 0
                    child: SizedBox(
                      width: 150, // Set the desired width here
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKeyrent.currentState!.validate()) {
                            Get.to(() => RentDetialsScreen(rentdata: rent));
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

  Widget gridExploreBuilder(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    List<Map<String, String>> categories = [
      {'name': 'New Tractor', 'icon': 'assets/images/newTractor.png'},
      {'name': 'Rent Services', 'icon': 'assets/images/rent.png'},
      {'name': 'Used Tractor', 'icon': 'assets/images/oldTractor.png'},
      {'name': 'My Lead', 'icon': 'assets/images/mylead.png'},
      {'name': 'Compare', 'icon': 'assets/images/compare.png'},
      {'name': 'Sell Tractor', 'icon': 'assets/images/sell.png'},
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0.w,
        mainAxisSpacing: 10.0.h,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () async {
            // print(category['name']);
            if (category['name'] == 'New Tractor') {
              cubit.changeNavIndex(1);
            } else if (category['name'] == 'Rent Services') {
              cubit.changeNavIndex(3);
            } else if (category['name'] == 'Used Tractor') {
              cubit.changeNavIndex(2);
            }else if (category['name'] == 'My Lead') {
              cubit.changeNavIndex(4);
            }else if (category['name'] == 'Compare') {
              // cubit.changeNavIndex(2);
            }else if (category['name'] == 'Sell Tractor') {
              Get.to(()=> SellScreen());
            }
          },
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(5.0),
            color: cubit.isDark ? Colors.grey[800] : Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon for each category
                  SizedBox(
                    height: 40.h,
                    child: Image.asset(
                      category['icon'] ?? '', // Ensure you have the icon path
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(
                        category['name'] ?? '',
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
}
