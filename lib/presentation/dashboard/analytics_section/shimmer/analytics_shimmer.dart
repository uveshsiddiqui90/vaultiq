import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/color_constant.dart';

class AnalyticsShimmer extends StatelessWidget {
  const AnalyticsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: AppPadding.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _box(width: 48.w, height: 48.h, radius: 14.r),
                    AppSize.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _line(width: 120.w, height: 20.h),
                          AppSize.h8,
                          _line(width: 180.w, height: 12.h),
                        ],
                      ),
                    ),
                    _box(width: 44.w, height: 44.h, radius: 12.r),
                  ],
                ),
                AppSize.h20,
                _line(width: double.infinity, height: 48.h, radius: 14.r),
                AppSize.h20,
                _box(width: double.infinity, height: 130.h, radius: 20.r),
                AppSize.h20,
                _box(width: double.infinity, height: 300.h, radius: 20.r),
                AppSize.h20,
                _box(width: double.infinity, height: 220.h, radius: 20.r),
                AppSize.h20,
                _box(width: double.infinity, height: 90.h, radius: 20.r),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _box({
    required double width,
    required double height,
    double radius = 12,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _line({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
