import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vaultiq/constant/color_constant.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Center(
                child: Text(
                  "Add Expense",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                label: "Amount",
                hint: "Enter amount",
                controller: addExpenseController.amountController,
              ),
              SizedBox(height: 20),
              CustomDropdownField(
                label: "Category",
                hint: "Select category",
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
                  label: "Date",
                  selectedDate: addExpenseController.selectedDate.value,
                  onDateSelected: (date) {
                    addExpenseController.selectedDate.value = date;
                    addExpenseController.dateController.text = date.toIso8601String();
                  },
                ),
              ),

              SizedBox(height: 20.h),

              CustomTextField(
                controller: addExpenseController.noteController,
                label: "Note(Optional)",
                hint: "Add a note about this expense",
              ),
              SizedBox(height: 50.h),
              CustomButton(
                label: "Add Expense",
                onPressed: () {
                  if (addExpenseController.amountController.text.trim().isEmpty) {
                    
                       AppSnackbar.warning(message:  "Please enter an amount");
                      return;
                  }
                  if (addExpenseController.selectedCategory.value == null) {
                     AppSnackbar.warning(message: "Please select a category");
                     return;
                  }
                   if (addExpenseController.dateController.text.trim().isEmpty) {
                    AppSnackbar.warning(message: "Please select a date");
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((category) {
            return DropdownMenuItem(value: category, child: Text(category));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
