import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:farm_connects/screen/BuyScreen/tractors_by_brand_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layout/appbar_layout.dart';
import '../../models/home_data_model.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/home_cubit/home_states.dart';
import '../../widgets/placeholder/brandscreen_placeholder.dart';



class AllBrandScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: HomeCubit.get(context).homeDataModel != null,
          builder: (context) =>
              productsBuilder(HomeCubit.get(context).homeDataModel, context),
          fallback: (context) => Center(child: BrandscreenPlaceholder()),
        );
      },
    );
  }

  Widget productsBuilder(HomeDataModel? homeDataModel, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: gridBrandsBuilder(homeDataModel, context),
    );
  }

  Widget gridBrandsBuilder(HomeDataModel? homeDataModel, context) {
    HomeCubit cubit = HomeCubit.get(context);
    return Scaffold(
      appBar: AppBarLayout(
        isDark: cubit.isDark,
        onSearchPressed: () {},
        onDropdownChanged: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0.w,
            mainAxisSpacing: 10.0.h,
            childAspectRatio: 1,
          ),
          itemCount: homeDataModel?.data.brands.length ?? 0,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final product = homeDataModel?.data.brands[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => TractorsByBrandScreen(brandName: product?.name, brandId: product?.id));

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
                          errorWidget: (context, url, error) => Icon(Icons.error_outline),
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
        ),
      ),
    );
  }
}
