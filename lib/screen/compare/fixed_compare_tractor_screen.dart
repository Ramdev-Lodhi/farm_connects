import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/layout/appbar_layout_new.dart';
import 'package:farm_connects/models/home_data_model.dart';
import 'package:farm_connects/screen/compare/compare_expansion_tile.dart';
import 'package:farm_connects/widgets/custom_card_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/styles/colors.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';

class FixedCompareTractorScreen extends StatefulWidget {
  final Tractors? filteredTractors;
  final Tractors? comparefilteredTractors;

  FixedCompareTractorScreen(
      {this.filteredTractors, this.comparefilteredTractors});

  @override
  State<FixedCompareTractorScreen> createState() =>
      _FixedCompareTractorScreen();
}

class _FixedCompareTractorScreen extends State<FixedCompareTractorScreen> {
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    final tractors = cubit.homeDataModel?.data.tractors ?? [];

    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.45;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarLayoutNew(isDark: cubit.isDark),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // First Tractor Card
                          Card(
                            elevation: 5,
                            color:
                                cubit.isDark ? Colors.grey[800] : Colors.white,
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
                                  Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            widget.filteredTractors?.image ??
                                                '',
                                        fit: BoxFit.contain,
                                        width: cardWidth,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error_outline),
                                      ),
                                      SizedBox(height: 5),
                                      Textfield(widget.filteredTractors!.brand),
                                      SizedBox(height: 5),
                                      Textfield(
                                        '${widget.filteredTractors?.brand ?? ''} ${widget.filteredTractors?.name ?? ''}'
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
                                              widget.filteredTractors!.price),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Card(
                            elevation: 5,
                            color:
                                cubit.isDark ? Colors.grey[800] : Colors.white,
                            child: Container(
                              width: cardWidth,
                              // Responsive width
                              height: 210,
                              padding: const EdgeInsets.all(5),
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  SizedBox(height: 8),
                                  Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: widget.comparefilteredTractors
                                                ?.image ??
                                            '',
                                        fit: BoxFit.contain,
                                        width: cardWidth,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error_outline),
                                      ),
                                      SizedBox(height: 5),
                                      Textfield(widget
                                          .comparefilteredTractors!.brand),
                                      SizedBox(height: 5),
                                      Textfield(
                                        '${widget.comparefilteredTractors?.brand ?? ''} ${widget.comparefilteredTractors?.name ?? ''}'
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
                                          Textfield(widget
                                              .comparefilteredTractors!.price),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
                  if (widget.filteredTractors != null &&
                      widget.comparefilteredTractors != null)
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
                                        '${widget.filteredTractors?.engine.noOfCylinder} , ${widget.comparefilteredTractors?.engine.noOfCylinder}'
                                  },
                                  {
                                    'HP Category':
                                        '${widget.filteredTractors?.engine.hpCategory}, ${widget.comparefilteredTractors?.engine.hpCategory}'
                                  },
                                  {
                                    'Capacity (CC)':
                                        '${widget.filteredTractors?.engine.capacityCC}, ${widget.comparefilteredTractors?.engine.capacityCC}'
                                  },
                                  {
                                    'RPM':
                                        '${widget.filteredTractors?.engine.rpm}, ${widget.comparefilteredTractors?.engine.rpm}'
                                  },
                                  {
                                    'Cooling':
                                        '${widget.filteredTractors?.engine.cooling}, ${widget.comparefilteredTractors?.engine.cooling}'
                                  },
                                  {
                                    'Fuel Type':
                                        '${widget.filteredTractors?.engine.fuelType}, ${widget.comparefilteredTractors?.engine.fuelType}'
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
                                        '${widget.filteredTractors?.transmission.clutch}, ${widget.comparefilteredTractors?.transmission.clutch}'
                                  },
                                  {
                                    'Gearbox':
                                        '${widget.filteredTractors?.transmission.gearBox}, ${widget.comparefilteredTractors?.transmission.gearBox}'
                                  },
                                  {
                                    'Forward Speed':
                                        '${widget.filteredTractors?.transmission.forwardSpeed}, ${widget.comparefilteredTractors?.transmission.forwardSpeed}'
                                  },
                                  {
                                    'Reverse Speed':
                                        '${widget.filteredTractors?.transmission.reverseSpeed}, ${widget.comparefilteredTractors?.transmission.reverseSpeed}'
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
                                        '${widget.filteredTractors?.steering.steeringType}, ${widget.comparefilteredTractors?.steering.steeringType}'
                                  },
                                  {
                                    'Steering Column':
                                        '${widget.filteredTractors?.steering.steeringColumn}, ${widget.comparefilteredTractors?.steering.steeringColumn}'
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
                                        '${widget.filteredTractors?.dimensionsWeight.totalWeight}, ${widget.comparefilteredTractors?.dimensionsWeight.totalWeight}'
                                  },
                                  {
                                    'Wheel Base':
                                        '${widget.filteredTractors?.dimensionsWeight.wheelBase}, ${widget.comparefilteredTractors?.dimensionsWeight.wheelBase}'
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
                                        '${widget.filteredTractors?.hydraulics.liftingCapacity}, ${widget.comparefilteredTractors?.hydraulics.liftingCapacity}'
                                  },
                                  {
                                    'Point Linkage':
                                        '${widget.filteredTractors?.hydraulics.pointLinkage}, ${widget.comparefilteredTractors?.hydraulics.liftingCapacity}'
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
                                        '${widget.filteredTractors?.wheelTyres.wheelDrive}, ${widget.comparefilteredTractors?.wheelTyres.wheelDrive}'
                                  },
                                  {
                                    'Front Tyre Size':
                                        '${widget.filteredTractors?.wheelTyres.front}, ${widget.comparefilteredTractors?.wheelTyres.front}'
                                  },
                                  {
                                    'Rear Tyre Size':
                                        '${widget.filteredTractors?.wheelTyres.rear}, ${widget.comparefilteredTractors?.wheelTyres.rear}'
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
                                        '${widget.filteredTractors?.powerTakeoff.powerType}, ${widget.comparefilteredTractors?.powerTakeoff.powerType}'
                                  },
                                  {
                                    'RPM':
                                        '${widget.filteredTractors?.powerTakeoff.rpm}, ${widget.comparefilteredTractors?.powerTakeoff.rpm}'
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
                                        '${widget.filteredTractors?.otherInformation.accessories}, ${widget.comparefilteredTractors?.otherInformation.accessories}'
                                  },
                                  {
                                    'Warranty':
                                        '${widget.filteredTractors?.otherInformation.warranty}, ${widget.comparefilteredTractors?.otherInformation.warranty}'
                                  },
                                  {
                                    'Status':
                                        '${widget.filteredTractors?.otherInformation.status}, ${widget.comparefilteredTractors?.otherInformation.status}'
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
}
