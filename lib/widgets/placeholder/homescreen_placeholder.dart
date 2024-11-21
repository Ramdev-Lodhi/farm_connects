import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomescreenPlaceholder extends StatelessWidget {
  const HomescreenPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: screenHeight / 5.2,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.h),
            _sectionHeader(),
            SizedBox(height: 10.h),
            _ListViewbuilderContainder(),
            SizedBox(height: 20.h),
            _sectionHeader(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0.w,
                  mainAxisSpacing: 10.0.h,
                  childAspectRatio: 1,
                ),
                itemCount: 6,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            _sectionHeader(),
            SizedBox(height: 20.h),
            _ListViewbuilderContainder(),
            SizedBox(height: 20.h),
            _sectionHeader(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0.w,
                  mainAxisSpacing: 10.0.h,
                  childAspectRatio: 1,
                ),
                itemCount: 12,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            _sectionHeader(),
            SizedBox(height: 20.h),
            _ListViewbuilderContainder(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader() {

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 40.h,
        color: Colors.grey,
        width: double.infinity,
      ),
    );
  }

  Widget _ListViewbuilderContainder(){
    return Container(
      height:  279.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: Card(
              elevation: 1,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 300.w,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
