import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/screen/BuyScreen/tractor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';
import '../../models/home_data_model.dart';
import '../../models/sell_model.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/snackbar_helper.dart';
import '../sellScreen/used_tractor_details_screen.dart';
import 'customExpansionTile.dart';

class TractorsByBrandScreen extends StatefulWidget {
  final String? brandName;
  final String? brandId;

  const TractorsByBrandScreen({Key? key, this.brandName, this.brandId})
      : super(key: key);

  @override
  _TractorsByBrandScreenState createState() => _TractorsByBrandScreenState();
}

class _TractorsByBrandScreenState extends State<TractorsByBrandScreen> {
  int _expandedIndex = -1;
  String? _selectedbrand;
  String? _selectedsellbrand;

  @override
  void initState() {
    super.initState();
    _selectedbrand = widget.brandName;
    _selectedsellbrand = widget.brandName;
  }

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    final tractors = cubit.homeDataModel?.data.tractors ?? [];
    final brands = cubit.homeDataModel?.data.brands ?? [];

    // Filter tractors based on the passed brandId or brandName
    List<Tractors> filteredTractors = tractors.where((tractor) {
      return (tractor.brand == _selectedbrand);
    }).toList();

    SellCubit sellcubit = SellCubit.get(context);
    final sellTractor = sellcubit.sellAllTractorData?.data.SellTractor ?? [];
// Filter tractors based on the passed brandId or brandName
    List<SellData> filteredSellTractors = sellTractor.where((sellTractor) {
      return (sellTractor.brand == _selectedsellbrand);
    }).toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tractors By ${_selectedbrand ?? 'Brand'}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Palette.tabbarColor,
              child: TabBar(
                isScrollable: false,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.black,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(horizontal: 16),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Used Tractors'),
                  Tab(text: 'Implements'),
                  Tab(text: 'About Tractors'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverview(filteredTractors, context),
            _buildUsedTractorsSection(filteredSellTractors, context),
            _buildVerticalScrollableContent(_buildImplementsSection()),
            _buildVerticalScrollableContent(_buildAboutTractorsSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(List<Tractors> filteredTractors, BuildContext context) {
    List<String> brandList = [];
    brandList = HomeCubit.get(context)
            .homeDataModel
            ?.data
            .brands
            .map((brand) => brand.name)
            .toList() ??
        [];
    return Column(
      children: [
        // Dropdown to change brand
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomDropdown(
            hint: "Change Brand",
            items: brandList,
            // value: _selectedbrand,
            onChanged: (value) {
              setState(() => _selectedbrand = value);
            },
            label: "",
          ),
        ),
        // List of filtered tractors
        Expanded(
          child: _buildTractorsList(filteredTractors, context),
        ),
      ],
    );
  }

  Widget _buildTractorsList(
      List<Tractors> tractorsByBrand, BuildContext context) {
    return ListView.builder(
      itemCount: tractorsByBrand.length,
      itemBuilder: (context, index) {
        return tractorItemBuilder(tractorsByBrand[index], context);
      },
    );
  }

  Widget _buildVerticalScrollableContent(Widget child) {
    return SingleChildScrollView(child: child);
  }

  Widget tractorItemBuilder(Tractors product, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
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
                                const Icon(Icons.error_outline),
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
                            '${product?.brand ?? ''} ${product?.name ?? ''}'
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
                                'HP: ${product?.engine.hpCategory ?? 'N/A'}',
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
                                'CC: ${product?.engine.capacityCC ?? 'N/A'} CC',
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
                                  // Navigate to check price screen
                                },
                                child: const Text("Check Tractor Price",
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

  Widget _buildImplementsSection() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Implements',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAboutTractorsSection() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'About',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUsedTractorsSection(List<SellData> filteredSellTractors , BuildContext context) {
    List<String> brandList = [];
    brandList = HomeCubit.get(context)
        .homeDataModel
        ?.data
        .brands
        .map((brand) => brand.name)
        .toList() ??
        [];
    return Column(
      children: [
        // Dropdown to change brand
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomDropdown(
            hint: "Change Brand",
            items: brandList,
            // value: _selectedbrand,
            onChanged: (value) {
              setState(() => _selectedsellbrand = value);
            },
            label: "",
          ),
        ),
        // List of filtered tractors
        Expanded(
          child: _buildSellTractorsList(filteredSellTractors, context),
        ),
      ],
    );
  }
  Widget _buildSellTractorsList(
      List<SellData> selltractorsByBrand, BuildContext context) {
    return ListView.builder(
      itemCount: selltractorsByBrand.length,
      itemBuilder: (context, index) {
        return selltractorItemBuilder(selltractorsByBrand[index], context);
      },
    );
  }
  Widget selltractorItemBuilder(SellData? product, BuildContext context) {
    // SellCubit cubit = SellCubit.get(context);
    HomeCubit cubit = HomeCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: GestureDetector(
        onTap: () {
          Get.to(()=> UsedTractorDetails(selltractor: product));
          // Get.to(() => BrandDetailScreen(
          //   brandName: product?.name ?? '',
          //   brandId: product?.id ?? '', // Assuming `id` exists in your model
          // ));
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
                                  if (product?.mobile != null) {
                                    // Copy the phone number to clipboard
                                    Clipboard.setData(ClipboardData(text: product!.mobile))
                                        .then((_) {
                                      showCustomSnackbar(
                                          'Alert', 'Phone number copied to clipboard!');
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Phone number is not available.')),
                                    );
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
