import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/screen/BuyScreen/tractor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/mylead_cubit/mylead_cubits.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';
import '../../models/home_data_model.dart';
import '../../models/sell_model.dart';
import '../../widgets/customDropdown.dart';
import '../../widgets/snackbar_helper.dart';
import '../sellScreen/used_tractor_details_screen.dart';

class SellTractorsByBrand extends StatefulWidget {
  final String? brandName;
  final String? brandId;

  const SellTractorsByBrand({Key? key, this.brandName, this.brandId})
      : super(key: key);

  @override
  _SellTractorsByBrandScreenState createState() => _SellTractorsByBrandScreenState();
}

class _SellTractorsByBrandScreenState extends State<SellTractorsByBrand> {
  int _expandedIndex = -1;
  String? _selectedbrand;
  String? _selectedsellbrand;
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? mobile;
  String? location;
  String? price;

  @override
  void initState() {
    super.initState();
    _selectedbrand = widget.brandName;
    _selectedsellbrand = widget.brandName;
    name = CacheHelper.getData(key: 'name') ?? "";
    location =
    '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(
        key: 'subDistrict') ?? ''}';
    mobile = ProfileCubits
        .get(context)
        .profileModel
        .data
        ?.mobile ?? "";
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

  void insertbuydata(buycontactdata) {
    var mylead = MyleadCubits.get(context);
    mylead.InsertbuyContactData(
        buycontactdata.image,
        buycontactdata.brand,
        // buycontactdata.userId,
        buycontactdata.name,
        name!,
        mobile!,
        location!,
        price!);
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
                  Tab(text: 'Used Tractors'),
                  Tab(text: 'New Tractors'),
                  Tab(text: 'Implements'),
                  Tab(text: 'About Tractors'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsedTractorsSection(filteredSellTractors, context),
            _buildOverview(filteredTractors, context),
            _buildVerticalScrollableContent(_buildImplementsSection()),
            _buildVerticalScrollableContent(_buildAboutTractorsSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(List<Tractors> filteredTractors, BuildContext context) {
    List<String> brandList = [];
    brandList = HomeCubit
        .get(context)
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

  Widget _buildTractorsList(List<Tractors> tractorsByBrand,
      BuildContext context) {
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
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return newTractorContactDialog(
                                          product, context);
                                    },
                                  );
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

  Widget _buildUsedTractorsSection(List<SellData> filteredSellTractors,
      BuildContext context) {
    List<String> brandList = [];
    brandList = HomeCubit
        .get(context)
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

  Widget _buildSellTractorsList(List<SellData> selltractorsByBrand,
      BuildContext context) {
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
          Get.to(() => UsedTractorDetails(selltractor: product));
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
                            '${product?.brand ?? ''} ${product?.modelname ??
                                ''}'
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
                          Text(
                            'Price: ${product?.price ?? 'N/A'} ',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.bold,
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
  Widget newTractorContactDialog(newtractors, BuildContext context) {
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
                  Text("Contact Form",
                      style: TextStyle(
                          fontSize: 20,
                          color: cubit.isDark ? Colors.white : Colors.black)),
                  TextFormField(
                    initialValue: name,
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.person,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
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
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
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
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
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
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.currency_rupee,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                    onSaved: (value) => price = value,
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
                    color: cubit.isDark ? Colors.white : Colors.black12,
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            insertbuydata(newtractors);
                            Navigator.pop(context);
                            Get.to(() => TractorsDetails(tractor: newtractors));
                          }
                        },
                        child: Text("Contact",
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
                  Text("Seller Contact Form",
                      style: TextStyle(
                          fontSize: 20,
                          color: cubit.isDark ? Colors.white : Colors.black)),
                  TextFormField(
                    initialValue: name,
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.person,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
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
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
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
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
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
                    style: TextStyle(
                        color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      labelStyle: TextStyle(
                          color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(
                        Icons.currency_rupee,
                        color: cubit.isDark ? Colors.white : Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                    onSaved: (value) => price = value,
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
                    color: cubit.isDark ? Colors.white : Colors.black12,
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
