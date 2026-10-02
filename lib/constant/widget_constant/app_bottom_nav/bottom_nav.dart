import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/color_constant.dart';

class AppBottomSheet {
  static Future<void> showAmountBottomSheet({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback onSave,
    String title = "Set Monthly\nBudget",
    String subtitle = "Apna total monthly amount set karo",
    String buttonText = "Save Budget",
  }) async {
    final quickAmounts = ["10000", "25000", "40000", "50000"];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: ColorConstant.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Drag Indicator
                    Center(
                      child: Container(
                        width: 45.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: ColorConstant.border,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        color: ColorConstant.inkDark,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Subtitle
                    Text(
                      subtitle,
                      style: TextStyle(color: ColorConstant.inkMuted, fontSize: 14.sp),
                    ),

                    SizedBox(height: 22.h),

                    /// Amount Field
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.bgLight,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: ColorConstant.primary,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.inkDark,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixText: "₹ ",
                          prefixStyle: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.inkMid,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// Quick Amount Buttons
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: quickAmounts.map((amount) {
                        final isSelected = controller.text == amount;

                        return GestureDetector(
                          onTap: () {
                            controller.text = amount;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ColorConstant.primaryLight
                                  : ColorConstant.bgLight,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isSelected
                                    ? ColorConstant.primary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              "₹${(int.parse(amount) ~/ 1000)}K",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: ColorConstant.inkDark,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 28.h),

                    /// Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 58.h,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: ColorConstant.bgLight,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: ColorConstant.inkDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 14.w),
                        Expanded(
                          child: SizedBox(
                            height: 58.h,
                            child: ElevatedButton(
                              onPressed: () {
                                onSave();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: ColorConstant.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    buttonText,
                                    style: TextStyle(
                                      color: ColorConstant.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child:  Icon(
                                      Icons.check,
                                      color: ColorConstant.white,
                                      weight: 100.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
