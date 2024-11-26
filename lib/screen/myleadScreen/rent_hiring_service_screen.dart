import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/cubits/mylead_cubit/mylead_cubits.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../models/myleads_model.dart';
import '../../models/rent_model.dart';

class RentHiringServiceScreen extends StatefulWidget {
  @override
  State<RentHiringServiceScreen> createState() =>
      _RentHiringServiceScreenState();
}

class _RentHiringServiceScreenState extends State<RentHiringServiceScreen> {
  String? userId;

  // List<RentData> filteredRentServices = [];
  List<RentServiceRequest> filteredRentServices = [];

  @override
  void initState() {
    super.initState();
    userId = ProfileCubits.get(context).profileModel.data?.id ?? "";
    MyleadCubits.get(context)
      ..getSellenquiry()
      ..getRentenquiry()
      ..getBuyenquiry()
      ..getrentItemByUserId();
    RentCubit.get(context)..GetRentData();
  }

  @override
  Widget build(BuildContext context) {
    final rentserviceData = MyleadCubits.get(context).rentDataModel;
    final dataRentRequestEnquiry = MyleadCubits.get(context).rentEnquiryData;
    final dataRentEnquiry = MyleadCubits.get(context).rentEnquiryData;
    final databuyEnquiry = MyleadCubits.get(context).buyEnquiryData;
    final rentservicedata = RentCubit.get(context).rentDataModel;
    HomeCubit cubit = HomeCubit.get(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Rent Hiring Service",
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
                  Tab(text: 'Service Rent Response'),
                  Tab(text: 'Your Request'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildVerticalScrollableContent(
                _buildRentService(rentserviceData!)),
            _buildVerticalScrollableContent(_buildrentEnquiry(rentserviceData)),
            _buildVerticalScrollableContent(
                _buildRentRequestEnquiry(rentservicedata!)),
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

  Widget _buildRentRequestEnquiry(RentDataModel rentDataModel) {
    final rentData = rentDataModel.data.rentData ?? [];

    List<Widget> rentItems = [];
    filteredRentServices.clear();
    for (var data in rentData) {
      List<RentServiceRequest>? rentServiceRequest = data.rentServiceRequest;
      var filteredRequests = rentServiceRequest.where((request) {
        return request.requestedBy == userId;
      }).toList();

      filteredRentServices.addAll(filteredRequests);

          rentItems.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: filteredRentServices.length,
          itemBuilder: (context, index) {
            return ItemBuilder(filteredRentServices[index],data, context);
          },
        ),
      ));
    }
    return Column(
      children: rentItems,
    );
  }

  Widget ItemBuilder(
      RentServiceRequest filteredRentServices,RentData rentData, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return GestureDetector(
      onTap: () {},
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Model Name
                          Text(
                            '${rentData.servicetype}',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Status
                          Text(
                            filteredRentServices.requestStatus ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500,
                              color: filteredRentServices.requestStatus ==
                                      'Pending'
                                  ? Color(0xFFF57F17)
                                  : filteredRentServices.requestStatus ==
                                          'Approved'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                                imageUrl: rentData.image ?? '',
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
                                  'Price: ₹ ${rentData.price}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ${filteredRentServices.mobile}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${filteredRentServices.location.replaceAll(",", "\n")}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
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

  Widget _buildrentEnquiry(RentDataModel rentDataModel) {
    final rentData = rentDataModel?.data?.rentData ?? [];

    List<Widget> rentItems = [];

    for (var data in rentData) {
      rentItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.rentServiceRequest.length,
            itemBuilder: (context, index) {
              return RentItemBuilder(
                  data.rentServiceRequest[index], data, context); // Corrected
            },
          ),
        ),
      );
    }

    return Column(
      children: rentItems,
    );
  }

  Widget RentItemBuilder(RentServiceRequest rentServiceRequest,
      RentData rentData, BuildContext context) {
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
                  // Header Card for Farmer Name and Status
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Farmer Name
                          Text(
                            '${rentData.servicetype}',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Status
                          Text(
                            rentServiceRequest.requestStatus ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  rentServiceRequest.requestStatus == 'Pending'
                                      ? Color(0xFFF57F17)
                                      : rentServiceRequest.requestStatus ==
                                              'Approved'
                                          ? Colors.green
                                          : Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                                imageUrl: rentData.image ?? '',
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
                                  'Name: ${rentServiceRequest.name}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Price: ₹ ${rentData.price}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ${rentServiceRequest.mobile}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${rentServiceRequest.location.replaceAll(",", "\n")}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
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

  Widget _buildRentService(RentDataModel rentserviceData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: rentserviceData.data.rentData.length,
        itemBuilder: (context, index) {
          return RentServiceItemBuilder(
              rentserviceData.data.rentData[index], context);
        },
      ),
    );
  }

  Widget RentServiceItemBuilder(RentData rentData, BuildContext context) {
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
                  // Header Card for Service Type
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Service Type
                          Text(
                            rentData.servicetype ?? 'Unknown Service',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${rentData.rentedStatus == false ? 'Unavailable' : 'Available'} ',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: rentData.rentedStatus
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: SizedBox(
                              height: 120.w,
                              width: 120.w,
                              child: CachedNetworkImage(
                                imageUrl: rentData.image ?? '',
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
                                  'Name: ${rentData.userInfo?.name ?? 'Not Available'}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Price: ₹ ${rentData.price ?? 'Not Available'}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${rentData.address?.state},'
                                  "\n"
                                  ' ${rentData.address?.sub_district} (${rentData.address?.pincode})',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
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
