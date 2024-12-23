import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/models/home_data_model.dart';
import 'package:farm_connects/screen/compare/compare_expansion_tile.dart';
import 'package:farm_connects/widgets/custom_card_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/styles/colors.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';
import '../../layout/appbar_layout_new.dart';
import 'fixed_compare_tractor_screen.dart';

class CompareScreen extends StatefulWidget {
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  int _expandedIndex = -1;
  String? _selectedbrand;
  String? _selectemodel;
  List<String> brandList = [];
  String? _compareselectedbrand;
  List<String> comparebrandList = [];
  String? _compareselectedmodel;
  List<String> modelNameList = [];
  List<String> comparemodelNameList = [];

  @override
  void initState() {
    super.initState();
    loadModel();
    loadcompareModel();
    brandList = HomeCubit.get(context)
            .homeDataModel
            ?.data
            .brands
            .map((brand) => brand.name)
            .toList() ??
        [];
    comparebrandList = HomeCubit.get(context)
            .homeDataModel
            ?.data
            .brands
            .map((brand) => brand.name)
            .toList() ??
        [];
  }

  Future<void> loadModel() async {
    if (_selectedbrand != null) {
      await BlocProvider.of<SellCubit>(context).getModel(_selectedbrand!);
      modelNameList = SellCubit.get(context)
              .sellDataModel
              ?.data
              .models
              .map((model) => model.name)
              .toList() ??
          [];
      setState(() {});
    }
  }

  Future<void> loadcompareModel() async {
    if (_compareselectedbrand != null) {
      await BlocProvider.of<SellCubit>(context)
          .getModel(_compareselectedbrand!);
      comparemodelNameList = SellCubit.get(context)
              .sellDataModel
              ?.data
              .models
              .map((model) => model.name)
              .toList() ??
          [];
      setState(() {});
    }
  }

  Future<void> showModelBottomSheet() {
    return showCustomCardBottomSheet(
      context: context,
      hint: "Select a Model",
      label: "Item",
      items: modelNameList,
      selectedValue: _selectemodel,
      onChanged: (value) {
        setState(() {
          _selectemodel = value;
        });
      },
    );
  }

  Future<void> showcompareModelBottomSheet() {
    return showCustomCardBottomSheet(
      context: context,
      hint: "Select a Model",
      label: "Item",
      items: comparemodelNameList,
      selectedValue: _compareselectedmodel,
      onChanged: (value) {
        setState(() {
          _compareselectedmodel = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    final tractors = cubit.homeDataModel?.data.tractors ?? [];

    // Filtering tractors based on the selected brand and model
    List<Tractors> filteredTractors = tractors.where((tractor) {
      return (tractor.brand == _selectedbrand && tractor.name == _selectemodel);
    }).toList();

    List<Tractors> comparefilteredTractors = tractors.where((tractor) {
      return (tractor.brand == _compareselectedbrand &&
          tractor.name == _compareselectedmodel);
    }).toList();

    // MediaQuery to get screen size for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.45; // Cards take 40% of screen width

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Compare Tractor"),
      // ),
      body: CustomScrollView(
        slivers: [
          AppBarLayoutNew(isDark: cubit.isDark),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  _sectionHeader(context, 'Compare Tractors'),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // First Tractor Card
                          GestureDetector(
                            onTap: () {
                              showCustomCardBottomSheet(
                                context: context,
                                hint: "Select a Brand",
                                label: "Item",
                                items: brandList,
                                selectedValue: _selectedbrand,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedbrand = value;
                                  });
                                  if (_selectedbrand != null) {
                                    loadModel().then((_) {
                                      setState(() {
                                        showModelBottomSheet();
                                      });
                                    });
                                  }
                                },
                              );
                            },
                            child: Card(
                              elevation: 5,
                              color: cubit.isDark
                                  ? Colors.grey[800]
                                  : Colors.white,
                              child: Container(
                                width: cardWidth,
                                // Responsive width
                                height: 210,
                                padding: EdgeInsets.all(5),
                                color: Colors.transparent,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    filteredTractors.isEmpty
                                        ? Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_outlined,
                                                  size: 50,
                                                  color: cubit.isDark
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Select Tractor',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: cubit.isDark
                                                        ? Colors.white
                                                        : Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    filteredTractors[0].image ??
                                                        '',
                                                fit: BoxFit.contain,
                                                width: cardWidth,
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(
                                                        Icons.error_outline),
                                              ),
                                              SizedBox(height: 5),
                                              Textfield(
                                                  filteredTractors[0].brand),
                                              SizedBox(height: 5),
                                              Textfield(
                                                '${filteredTractors[0].brand ?? ''} ${filteredTractors[0].name ?? ''}'
                                                    .trim(),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.currency_rupee,
                                                    size: 20,
                                                    color: cubit.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  Textfield(filteredTractors[0]
                                                      .price),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              showCustomCardBottomSheet(
                                context: context,
                                hint: "Select a Brand",
                                label: "Item",
                                items: comparebrandList,
                                selectedValue: _compareselectedbrand,
                                onChanged: (value) {
                                  setState(() {
                                    _compareselectedbrand = value;
                                  });
                                  if (_compareselectedbrand != null) {
                                    loadcompareModel().then((_) {
                                      setState(() {
                                        showcompareModelBottomSheet();
                                      });
                                    });
                                  }
                                },
                              );
                            },
                            child: Card(
                              elevation: 5,
                              color: cubit.isDark
                                  ? Colors.grey[800]
                                  : Colors.white,
                              child: Container(
                                width: cardWidth,
                                // Responsive width
                                height: 210,
                                padding: const EdgeInsets.all(5),
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    SizedBox(height: 8),
                                    comparefilteredTractors.isEmpty
                                        ? Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_outlined,
                                                  size: 50,
                                                  color: cubit.isDark
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Select Tractor',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: cubit.isDark
                                                        ? Colors.white
                                                        : Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    comparefilteredTractors[0]
                                                            .image ??
                                                        '',
                                                fit: BoxFit.contain,
                                                width: cardWidth,
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(
                                                        Icons.error_outline),
                                              ),
                                              SizedBox(height: 5),
                                              Textfield(
                                                  comparefilteredTractors[0]
                                                      .brand),
                                              SizedBox(height: 5),
                                              Textfield(
                                                '${comparefilteredTractors[0].brand ?? ''} ${comparefilteredTractors[0].name ?? ''}'
                                                    .trim(),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.currency_rupee,
                                                    size: 20,
                                                    color: cubit.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  Textfield(
                                                      comparefilteredTractors[0]
                                                          .price),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Text(
                          "Vs",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (filteredTractors.isNotEmpty &&
                      comparefilteredTractors.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              CompareExpansionTile(
                                title: 'Engine',
                                details: [
                                  {
                                    'Number of Cylinders':
                                        '${filteredTractors[0].engine.noOfCylinder} , ${comparefilteredTractors[0].engine.noOfCylinder}'
                                  },
                                  {
                                    'HP Category':
                                        '${filteredTractors[0].engine.hpCategory}, ${comparefilteredTractors[0].engine.hpCategory}'
                                  },
                                  {
                                    'Capacity (CC)':
                                        '${filteredTractors[0].engine.capacityCC}, ${comparefilteredTractors[0].engine.capacityCC}'
                                  },
                                  {
                                    'RPM':
                                        '${filteredTractors[0].engine.rpm}, ${comparefilteredTractors[0].engine.rpm}'
                                  },
                                  {
                                    'Cooling':
                                        '${filteredTractors[0].engine.cooling}, ${comparefilteredTractors[0].engine.cooling}'
                                  },
                                  {
                                    'Fuel Type':
                                        '${filteredTractors[0].engine.fuelType}, ${comparefilteredTractors[0].engine.fuelType}'
                                  }
                                ],
                                isExpanded: _expandedIndex == 0,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 0 ? -1 : 0;
                                  });
                                },
                              ),
                              CompareExpansionTile(
                                title: 'Transmission',
                                details: [
                                  {
                                    'Clutch':
                                        '${filteredTractors[0].transmission.clutch}, ${comparefilteredTractors[0].transmission.clutch}'
                                  },
                                  {
                                    'Gearbox':
                                        '${filteredTractors[0].transmission.gearBox}, ${comparefilteredTractors[0].transmission.gearBox}'
                                  },
                                  {
                                    'Forward Speed':
                                        '${filteredTractors[0].transmission.forwardSpeed}, ${comparefilteredTractors[0].transmission.forwardSpeed}'
                                  },
                                  {
                                    'Reverse Speed':
                                        '${filteredTractors[0].transmission.reverseSpeed}, ${comparefilteredTractors[0].transmission.reverseSpeed}'
                                  },
                                ],
                                isExpanded: _expandedIndex == 1,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 1 ? -1 : 1;
                                  });
                                },
                              ),
                              CompareExpansionTile(
                                title: 'Steering',
                                details: [
                                  {
                                    'Steering Type':
                                        '${filteredTractors[0].steering.steeringType}, ${comparefilteredTractors[0].steering.steeringType}'
                                  },
                                  {
                                    'Steering Column':
                                        '${filteredTractors[0].steering.steeringColumn}, ${comparefilteredTractors[0].steering.steeringColumn}'
                                  },
                                ],
                                isExpanded: _expandedIndex == 2,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 2 ? -1 : 2;
                                  });
                                },
                              ),
                              CompareExpansionTile(
                                title: 'Dimensions & Weight',
                                details: [
                                  {
                                    'Total Weight':
                                        '${filteredTractors[0].dimensionsWeight.totalWeight}, ${comparefilteredTractors[0].dimensionsWeight.totalWeight}'
                                  },
                                  {
                                    'Wheel Base':
                                        '${filteredTractors[0].dimensionsWeight.wheelBase}, ${comparefilteredTractors[0].dimensionsWeight.wheelBase}'
                                  },
                                ],
                                isExpanded: _expandedIndex == 3,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 3 ? -1 : 3;
                                  });
                                },
                              ),
                              CompareExpansionTile(
                                title: 'Hydraulics',
                                details: [
                                  {
                                    'Lifting Capacity':
                                        '${filteredTractors[0].hydraulics.liftingCapacity}, ${comparefilteredTractors[0].hydraulics.liftingCapacity}'
                                  },
                                  {
                                    'Point Linkage':
                                        '${filteredTractors[0].hydraulics.pointLinkage}, ${comparefilteredTractors[0].hydraulics.liftingCapacity}'
                                  },
                                ],
                                isExpanded: _expandedIndex == 4,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 4 ? -1 : 4;
                                  });
                                },
                              ),
                              CompareExpansionTile(
                                title: 'Wheel & Tyres',
                                details: [
                                  {
                                    'Wheel Drive':
                                        '${filteredTractors[0].wheelTyres.wheelDrive}, ${comparefilteredTractors[0].wheelTyres.wheelDrive}'
                                  },
                                  {
                                    'Front Tyre Size':
                                        '${filteredTractors[0].wheelTyres.front}, ${comparefilteredTractors[0].wheelTyres.front}'
                                  },
                                  {
                                    'Rear Tyre Size':
                                        '${filteredTractors[0].wheelTyres.rear}, ${comparefilteredTractors[0].wheelTyres.rear}'
                                  },
                                ],
                                isExpanded: _expandedIndex == 5,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 5 ? -1 : 5;
                                  });
                                },
                              ),
                              CompareExpansionTile(
                                title: 'Power Takeoff',
                                details: [
                                  {
                                    'Power Type':
                                        '${filteredTractors[0].powerTakeoff.powerType}, ${comparefilteredTractors[0].powerTakeoff.powerType}'
                                  },
                                  {
                                    'RPM':
                                        '${filteredTractors[0].powerTakeoff.rpm}, ${comparefilteredTractors[0].powerTakeoff.rpm}'
                                  },
                                ],
                                isExpanded: _expandedIndex == 6,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 6 ? -1 : 6;
                                  });
                                },
                              ),
                              CompareExpansionTile(
                                title: 'Other Information',
                                details: [
                                  {
                                    'Accessories':
                                        '${filteredTractors[0].otherInformation.accessories}, ${comparefilteredTractors[0].otherInformation.accessories}'
                                  },
                                  {
                                    'Warranty':
                                        '${filteredTractors[0].otherInformation.warranty}, ${comparefilteredTractors[0].otherInformation.warranty}'
                                  },
                                  {
                                    'Status':
                                        '${filteredTractors[0].otherInformation.status}, ${comparefilteredTractors[0].otherInformation.status}'
                                  },
                                ],
                                isExpanded: _expandedIndex == 7,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == 7 ? -1 : 7;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (filteredTractors.isEmpty &&
                      comparefilteredTractors.isEmpty)...[
                    _sectionHeader(context, 'Compare To Buy The Right Tractor'),
                    gridTractorsBuilder(cubit.homeDataModel, context),

                  ],

                  // if(filteredTractors.isEmpty && comparefilteredTractors.isEmpty)
                  //   gridTractors(cubit.homeDataModel, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Textfield(String text) {
    HomeCubit cubit = HomeCubit.get(context);
    return Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16.0.sp,
        fontWeight: FontWeight.bold,
        color: cubit.isDark ? Colors.white : Colors.black,
      ), // In case the text overflows
    );
  }

  Widget gridTractorsBuilder(
      HomeDataModel? randomTractor, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (randomTractor!.data.tractors.length > 12
                ? 12
                : randomTractor.data.tractors.length) ~/
            2,
        // Display two items per card
        itemBuilder: (context, index) {
          final product1 = randomTractor?.data.tractors[index * 2];
          final product2 =
              (index * 2 + 1) < (randomTractor?.data.tractors.length ?? 0)
                  ? randomTractor?.data.tractors[index * 2 + 1]
                  : null; // Check if a second product exists for the card

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: GestureDetector(
              onTap: () {
                // Here you can print or do other actions with the product
                if (product1 != null && product2 != null) {
                  Get.to(
                    () => FixedCompareTractorScreen(
                      filteredTractors: product1,
                      comparefilteredTractors: product2,
                    ),
                  );
                }
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
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Card 1 for product1
                              if (product1 != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 170.w,
                                        child: CachedNetworkImage(
                                          imageUrl: product1.image ?? '',
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error_outline),
                                        ),
                                      ),
                                      Text(
                                        '${product1.brand ?? ''} ${product1.name ?? ''}'
                                            .trim(),
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
                                    ],
                                  ),
                                ),
                              if (product2 != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 170.w,
                                        child: CachedNetworkImage(
                                          imageUrl: product2.image ?? '',
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error_outline),
                                        ),
                                      ),
                                      Text(
                                        '${product2.brand ?? ''} ${product2.name ?? ''}'
                                            .trim(),
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
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          // CircleAvatar displaying "Vs" in the center of the images
                          Positioned(
                            top: 60.0, // Position it slightly above the images
                            left: MediaQuery.of(context).size.width / 2 -
                                45, // Center horizontally
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 15.0,
                              child: Text(
                                "Vs",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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

  Widget gridTractors(HomeDataModel? randomTractor, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (randomTractor!.data.tractors.length < 12
                ? randomTractor!.data.tractors.length
                : 12) ~/
            2, // Display two items per card
        itemBuilder: (context, index) {
          final product1 = randomTractor?.data.tractors[(index * 2) + 12];
          final product2 =
              (index * 2 + 1) < (randomTractor?.data.tractors.length ?? 0)
                  ? randomTractor?.data.tractors[(index * 2 + 1) + 12]
                  : null; // Check if a second product exists for the card

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: GestureDetector(
              onTap: () {
                // Here you can print or do other actions with the product
                if (product1 != null && product2 != null) {
                  Get.to(
                    () => FixedCompareTractorScreen(
                      filteredTractors: product1,
                      comparefilteredTractors: product2,
                    ),
                  );
                }
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
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Card 1 for product1
                              if (product1 != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 170.w,
                                        child: CachedNetworkImage(
                                          imageUrl: product1.image ?? '',
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error_outline),
                                        ),
                                      ),
                                      Text(
                                        '${product1.brand ?? ''} ${product1.name ?? ''}'
                                            .trim(),
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
                                    ],
                                  ),
                                ),
                              if (product2 != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 170.w,
                                        child: CachedNetworkImage(
                                          imageUrl: product2.image ?? '',
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error_outline),
                                        ),
                                      ),
                                      Text(
                                        '${product2.brand ?? ''} ${product2.name ?? ''}'
                                            .trim(),
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
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          // CircleAvatar displaying "Vs" in the center of the images
                          Positioned(
                            top: 60.0, // Position it slightly above the images
                            left: MediaQuery.of(context).size.width / 2 -
                                45, // Center horizontally
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 15.0,
                              child: Text(
                                "Vs",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
  Widget _sectionHeader(BuildContext context, String title) {
    final cubit = HomeCubit.get(context);
    return Padding(
      padding: const EdgeInsets.only(top: 5,bottom: 5),
      child: Container(
        color: cubit.isDark ? asmarFate7 : offWhite,
        width: double.infinity,
        padding: EdgeInsets.only(left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
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
}
