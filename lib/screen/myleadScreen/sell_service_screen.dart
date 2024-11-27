import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/cubits/mylead_cubit/mylead_cubits.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_cubit.dart';
import 'package:farm_connects/cubits/sell_cubit/sell_cubit.dart';
import 'package:farm_connects/models/sell_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../models/myleads_model.dart';
import '../../models/rent_model.dart';
import 'package:intl/intl.dart';

class SellServiceScreen extends StatefulWidget {
  @override
  State<SellServiceScreen> createState() =>
      _SellServiceScreenState();
}

class _SellServiceScreenState extends State<SellServiceScreen> {
  String? userId;
  // List<RentData> filteredRentServices = [];
  List<RentServiceRequest> filteredRentServices = [];

  @override
  void initState() {
    super.initState();
    userId = ProfileCubits.get(context).profileModel.data?.id ?? "";
    MyleadCubits.get(context)..getSellenquiry();
  }

  @override
  Widget build(BuildContext context) {
    final dataSellEnquiry = MyleadCubits.get(context).sellEnquirydata;
    HomeCubit cubit = HomeCubit.get(context);
    final selltractor = SellCubit.get(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sell Service",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: cubit.isDark ? Colors.white70 : Colors.black,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Palette.tabbarColor,
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Your Service'),
                  Tab(text: 'Service Sell Response'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            (selltractor.sellAllTractorData!.data.SellTractor.isNotEmpty) ?
            _buildVerticalScrollableContent(
                _buildyourSellservice(selltractor.sellAllTractorData)) :
            Center( child: Text('No Service Available')),
            (dataSellEnquiry!.data.Sellenquiry.isNotEmpty) ?
            _buildVerticalScrollableContent(_buildSellEnquiry(dataSellEnquiry)) :
            Center( child: Text('No Service Request Available')),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalScrollableContent(Widget child) {
    return SingleChildScrollView(
      child: child,
    );
  }

  Widget _buildSellEnquiry(sellEnquiryData dataSellEnquiry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataSellEnquiry.data.Sellenquiry.length,
        itemBuilder: (context, index) {
          return ItemBuilder(dataSellEnquiry.data.Sellenquiry[index], context);
        },
      ),
    );
  }
  Widget ItemBuilder(SellEnquirydata sellEnquiry, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return GestureDetector(
      onTap: () {
        // Implement navigation to details screen if needed
      },
      child: Padding(
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
              child: Column(
                children: [
                  // Header Card for Model Name and Status
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    color: cubit.isDark ? Colors.grey[700] : Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Model Name
                          Text(
                            sellEnquiry.farmername ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Status
                          // Text(
                          //   sellEnquiry.renterInfo?.requestStatus ?? 'Unknown',
                          //   style: TextStyle(
                          //     fontSize: 14.0.sp,
                          //     fontWeight: FontWeight.w500,
                          //     color: sellEnquiry.renterInfo?.requestStatus == 'Pending'
                          //         ? Color(0xFFF57F17)
                          //         : sellEnquiry.renterInfo?.requestStatus == 'Approved'
                          //         ? Colors.green
                          //         : Colors.red,
                          //   ),
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // Main content of the card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: SizedBox(
                              height: 120.w,
                              width: 120.w,
                              child: CachedNetworkImage(
                                imageUrl: sellEnquiry.sellerInfo?.image ?? '',
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Text(
                                  'Price: ₹ ${sellEnquiry.budget}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${sellEnquiry.farmerlocation.replaceAll(",", "\n")}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildyourSellservice( dataSellEnquiry) {
    var tractor=dataSellEnquiry.data.SellTractor;
    final filteredTractors = tractor.where((tractor) => tractor.sellerId == userId).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: filteredTractors.length,
        itemBuilder: (context, index) {
          return sellItemBuilder(filteredTractors[index], context);
        },
      ),
    );
  }

  Widget sellItemBuilder( selldata, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return GestureDetector(
      onTap: () {
        // Implement navigation to details screen if needed
      },
      child: Padding(
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
              child: Column(
                children: [
                  // Header Card for Model Name and Status
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    color: cubit.isDark ? Colors.grey[700] : Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Model Name
                          Text(
                            selldata.name ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Status

                        ],
                      ),
                    ),
                  ),
                  // Main content of the card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: SizedBox(
                              height: 120.w,
                              width: 120.w,
                              child: CachedNetworkImage(
                                imageUrl: selldata?.image ?? '',
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Text(
                                  'Name: ${selldata.brand} ${selldata.modelname}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ${selldata.mobile}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${selldata.location.replaceAll(",", "\n")}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
