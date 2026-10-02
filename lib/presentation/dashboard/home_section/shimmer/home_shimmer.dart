import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vaultiq/constant/color_constant.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorConstant.border,
      highlightColor: ColorConstant.bgLight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// Top Container
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius: BorderRadius.circular(22),
              ),
            ),

            const SizedBox(height: 24),

            /// Budget Overview
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            const SizedBox(height: 24),

            /// Recent Transactions
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, __) {
                return Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}