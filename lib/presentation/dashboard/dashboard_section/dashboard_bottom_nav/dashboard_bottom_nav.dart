import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/icon_constant.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_controller/dashboard_controller.dart';

class DashboardBottomNav extends StatelessWidget {
  DashboardBottomNav({super.key});

  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,

      children: [
        Container(
          height: 78.h,

          padding: EdgeInsets.symmetric(horizontal: 10.w),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),

          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                _navItem(icon: IconConstant.homeIcon, label: "Home", index: 0,
                isSelected: controller.currentIndex.value == 0
                ),

                _navItem(
                  icon: IconConstant.budgetIcon,
                  label: "Budget",
                  index: 1,
                  isSelected: controller.currentIndex.value == 1
                ),

                SizedBox(width: 60.w),

                _navItem(
                  icon: IconConstant.analyticsIcon,
                  label: "Analytics",
                  index: 3,
                  isSelected: controller.currentIndex.value == 3
                ),

                _navItem(
                  icon: IconConstant.profileIcon,
                  label: "Profile",
                  index: 4,
                  isSelected: controller.currentIndex.value == 4
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: -24,

          child: GestureDetector(
            onTap: () {
              controller.changeTab(2);
            },

            child: Container(
              width: 62.w,
              height: 62.h,

              decoration: BoxDecoration(
                gradient: ColorConstant.primaryGradient,
                borderRadius: BorderRadius.circular(20.r),

                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.primary.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Icon(Icons.add, color: Colors.white, size: 32.sp),
            ),
          ),
        ),
      ],
    );
  }

 
 Widget _navItem({
  required String icon,
  required String label,
  required int index,
  required bool isSelected,
}) {
  return GestureDetector(
    onTap: () {
      controller.changeTab(index);
    },
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),

      decoration: BoxDecoration(
        color: isSelected
            ? ColorConstant.focusedFieldBg
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 22.w,
            height: 22.h,
            gaplessPlayback: true,
          ),

          SizedBox(height: 4.h),

          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? ColorConstant.primary
                  : ColorConstant.inkMuted,
            ),
          ),
        ],
      ),
    ),
  );
}
}
