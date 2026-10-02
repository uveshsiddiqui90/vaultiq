import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/icon_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/auth_footer_txt.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/constant/widget_constant/widget_constant.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_controller/signup_controller.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  //final SignupController signUpController = Get.put(SignupController());
  final SignupController signUpController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: Padding(
        padding: AppPadding.screen,
        child: SingleChildScrollView(
          child: Form(
            key: signUpController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSize.h60,
                WidgetConstant.iconDisplay(IconConstant.startupRocket),
                AppSize.h20,
                Text(
                  TextConstant.createAccount,
                  style: AppStyles.syne(
                    size: AppTextSize.extraLarge,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.inkDark,
                  ),
                ),
                Text(
                  TextConstant.letgetStarted,
                  style: AppStyles.dmSans(
                    size: AppTextSize.medium,
                    weight: AppFontWeight.regular,
                    color: ColorConstant.inkMuted,
                  ),
                ),
                AppSize.h40,
                CustomTextField(
                  label: TextConstant.nameLabel,
                  hint: TextConstant.nameHint,
                  controller: signUpController.nameController,
                ),
                AppSize.h20,
                CustomTextField(
                  label: TextConstant.emailSignUpLabel,
                  hint: TextConstant.emailSignUpHint,
                  controller: signUpController.emailController,
                ),
                SizedBox(height: 20),
                Obx(
                  () => CustomTextField(
                    label: TextConstant.passwordLabel,
                    hint: TextConstant.passwordHint,
                    controller: signUpController.passwordController,
                    isPassword: true,
                    isPasswordVisible: signUpController.isPasswordVisible.value,
                    onTogglePassword: () =>
                        signUpController.isPasswordVisible.value =
                            !signUpController.isPasswordVisible.value,
                  ),
                ),
                AppSize.h20,
                Obx(
                  () => CustomTextField(
                    label: TextConstant.confirmPasswordLabel,
                    hint: TextConstant.confirmPasswordHint,
                    controller: signUpController.confirmPasswordController,
                    isPassword: true,
                    isPasswordVisible:
                        signUpController.isConfirmPasswordVisible.value,
                    onTogglePassword: () =>
                        signUpController.isConfirmPasswordVisible.value =
                            !signUpController.isConfirmPasswordVisible.value,
                  ),
                ),
                AppSize.h40,
                // `Obx` so the button swaps its label for a spinner (and stops
                // accepting taps) while the account is being created.
                Obx(
                  () => CustomButton(
                    label: TextConstant.createAccount,
                    isLoading: signUpController.isLoading.value,
                    onPressed: () {
                      signUpController.formKey.currentState?.validate();
                      signUpController.userSignUp();
                    },
                  ),
                ),
                AppSize.h20,
                Center(
                  child: AuthFooterText(
                    normalText: TextConstant.alreadyHaveAccount,
                    actionText: TextConstant.login,
                    onTap: () {
                      Get.offNamed(AppRoutes.LOGIN);
                    },
                  ),
                ),
                AppSize.h60,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
