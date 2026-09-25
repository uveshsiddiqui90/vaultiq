import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/color_constant.dart';

class TransactionsShimmer extends StatelessWidget {
  const TransactionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    _box(width: 44.w, height: 44.h, radius: 14),
                    AppSize.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(width: 170.w, height: 18.h),
                          SizedBox(height: 6.h),
                          _box(width: 130.w, height: 12.h),
                        ],
                      ),
                    ),
                  ],
                ),

                AppSize.h20,

                /// Filter pill
                Align(
                  alignment: Alignment.centerRight,
                  child: _box(width: 124.w, height: 38.h, radius: 14),
                ),

                AppSize.h16,

                /// List card
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      itemBuilder: (_, __) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          children: [
                            _box(width: 46.w, height: 46.h, radius: 23),
                            AppSize.w12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _box(width: 140.w, height: 14.h),
                                  SizedBox(height: 8.h),
                                  _box(width: 90.w, height: 11.h),
                                  SizedBox(height: 8.h),
                                  _box(width: 70.w, height: 18.h, radius: 10),
                                ],
                              ),
                            ),
                            _box(width: 60.w, height: 16.h),
                          ],
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
    );
  }

  Widget _box({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}
