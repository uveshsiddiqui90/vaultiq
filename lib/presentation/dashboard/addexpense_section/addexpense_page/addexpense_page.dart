import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/constant/widget_constant/cutom_datefield.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_controller/addexpense_controller.dart';

class AddexpensePage extends StatelessWidget {
  AddexpensePage({super.key});
  final AddExpenseController addExpenseController = AddExpenseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Padding(
        padding: AppPadding.screen,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSize.h40,
              Center(
                child: Text(
                  TextConstant.addExpenseTitle,
                  style: AppStyles.syne(
                    size: AppTextSize.largeTitle,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.txtColor,
                  ),
                ),
              ),
              AppSize.h20,
              CustomTextField(
                label: TextConstant.amountLabel,
                hint: TextConstant.enterAmountHint,
                controller: addExpenseController.amountController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              CustomDropdownField(
                label: TextConstant.categoryLabel,
                hint: TextConstant.selectCategoryHint,
                selectedValue: addExpenseController.selectedCategory.value,
                items: const [
                  "Groceries",
                  "Food",
                  "Transport",
                  "Shopping",
                  "Bills",
                  "Health",
                ],
                onChanged: (value) {
                  addExpenseController.selectedCategory.value = value!;
                },
              ),
              SizedBox(height: 20),
              Obx(
                () => CustomDateField(
                  label: TextConstant.dateLabel,
                  selectedDate: addExpenseController.selectedDate.value,
                  onDateSelected: (date) {
                    addExpenseController.selectedDate.value = date;
                    addExpenseController.dateController.text = date
                        .toIso8601String();
                  },
                ),
              ),

              AppSize.h20,

              CustomTextField(
                controller: addExpenseController.noteController,
                label: TextConstant.noteLabel,
                hint: TextConstant.enterNoteHint,
              ),
              AppSize.h40,
              CustomButton(
                label: TextConstant.addExpenseButton,
                onPressed: () {
                  if (addExpenseController.amountController.text
                      .trim()
                      .isEmpty) {
                    AppSnackbar.warning(message: TextConstant.enterAmountHint);
                    return;
                  }
                  if (addExpenseController.selectedCategory.value
                      .trim()
                      .isEmpty) {
                    AppSnackbar.warning(
                      message: TextConstant.selectCategoryHint,
                    );
                    return;
                  }
                  if (addExpenseController.dateController.text.trim().isEmpty) {
                    AppSnackbar.warning(message: TextConstant.enterDateHint);
                    return;
                  }
                  if (addExpenseController.noteController.text.trim().isEmpty) {
                    AppSnackbar.warning(message: TextConstant.enterNoteHint);
                    return;
                  }

                  addExpenseController.addExpense();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.dmSans(
            size: AppTextSize.small,
            weight: AppFontWeight.semiBold,
            color: ColorConstant.inkMuted,

            //style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: ColorConstant.border,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.transparent, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.transparent, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1.2,
              ),
            ),
          ),

          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(
                category,
                style: AppStyles.dmSans(
                  size: AppTextSize.small,
                  weight: AppFontWeight.semiBold,
                  color: ColorConstant.inkMuted,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: ColorConstant.focusedFieldBg,
        ),
      ],
    );
  }
}
