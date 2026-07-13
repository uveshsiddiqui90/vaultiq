import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/color_constant.dart';

class BudgetShimmer extends StatelessWidget {
  const BudgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: AppPadding.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSize.h40,

              /// Title
              Center(
                child: Container(
                  width: 130.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              AppSize.h20,

              /// Monthly Budget Card
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 120.w, height: 18.h),
                    SizedBox(height: 16.h),
                    _line(width: 170.w, height: 30.h),
                  ],
                ),
              ),

              AppSize.h20,

              /// Budget Usage Card
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 130.w, height: 18.h),

                    SizedBox(height: 18.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: 8.h,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    _line(width: 80.w, height: 14.h),
                  ],
                ),
              ),

              AppSize.h20,

              /// Remaining Budget Card
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 150.w, height: 18.h),

                    SizedBox(height: 16.h),

                    _line(width: 150.w, height: 30.h),
                  ],
                ),
              ),

              AppSize.h40,

              /// Button
              Container(
                width: double.infinity,
                height: 58.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  Widget _line({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}