import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/cubits/mylead_cubit/mylead_cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../models/myleads_model.dart';

class ListedItemScreen extends StatefulWidget {
  @override
  State<ListedItemScreen> createState() => _ListedItemScreenState();
}

class _ListedItemScreenState extends State<ListedItemScreen> {
  @override
  void initState() {
    super.initState();
    MyleadCubits.get(context)..getSellenquiry();
  }

  @override
  Widget build(BuildContext context) {
    final dataSellEnquiry = MyleadCubits.get(context).sellEnquirydata;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Palette.tabbarColor,
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Buy'),
                  Tab(text: 'Sell'),
                  Tab(text: 'Rent'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(),
            _buildVerticalScrollableContent(
                _buildSellEnquiry(dataSellEnquiry!)),
            Container(),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sellEnquiry.farmername ?? 'Unknown Farmer',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Budget: ₹ ${sellEnquiry.budget}',
                            style: TextStyle(
                                fontSize: 14.0.sp,
                                color: cubit.isDark
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Mobile: ${sellEnquiry.farmermobile}',
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                color: cubit.isDark
                                    ? Colors.white70
                                    : Colors.black54),

                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Location: ${sellEnquiry.farmerlocation}',
                            style: TextStyle(
                                fontSize: 8.0.sp,
                                color: cubit.isDark
                                    ? Colors.white70
                                    : Colors.black54),

                          ),
                          SizedBox(height: 8.0),

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
