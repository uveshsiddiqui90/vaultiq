import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart' show AppStyles;
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/icon_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/auth_footer_txt.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/constant/widget_constant/widget_constant.dart';
import 'package:vaultiq/presentation/auth/login/login_controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: Padding(
        padding: AppPadding.screen,
        child: SingleChildScrollView(
          child: Form(
            key: loginController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                AppSize.h60,
                WidgetConstant.iconDisplay(IconConstant.wavingHand),
                AppSize.h20,
                Text(
                  TextConstant.welcomeBack,
                  style: AppStyles.syne(
                    size: AppTextSize.extraLarge,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.inkDark,
                  ),
                ),
                Text(
                  TextConstant.logintomanageyourexpenses,
                  style: AppStyles.dmSans(
                    size: AppTextSize.medium,
                    weight: AppFontWeight.regular,
                    color: ColorConstant.inkMuted,
                  ),
                ),
                AppSize.h40,
                CustomTextField(
                  label: TextConstant.emailLabel,
                  hint: TextConstant.emailHint,
                  controller: loginController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TextConstant.emailEmptyError;
                    }
                    return null;
                  },
                ),
                AppSize.h20,
                Obx(
                  () => CustomTextField(
                    label: TextConstant.passwordLabel,
                    hint: TextConstant.passwordHint,
                    controller: loginController.passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return TextConstant.passwordEmptyError;
                      }
                      return null;
                    },
                    isPasswordVisible: loginController.isPasswordVisible.value,
                    onTogglePassword: () =>
                        loginController.isPasswordVisible.value =
                            !loginController.isPasswordVisible.value,
                  ),
                ),
                AppSize.h20,
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    TextConstant.forgotPassword,
                    style: AppStyles.dmSans(
                      size: AppTextSize.body,
                      weight: AppFontWeight.medium,
                      color: ColorConstant.blue,
                    ),
                  ),
                ),
                AppSize.h20,
                Obx(
                  () => CustomButton(
                    label: TextConstant.login,
                    isLoading: loginController.isLoading.value,
                    onPressed: () {
                      loginController.login();
                    },
                  ),
                ),
                AppSize.h20,
                WidgetConstant.orWidget(context),
                AppSize.h20,
                CustomButton(
                  label: TextConstant.loginWithGoogle,
                  variant: ButtonVariant.outline,
                  prefixIcon: Image.asset(IconConstant.googleIcon, width: 25),
                  onPressed: () {},
                ),
                AppSize.h20,
                Center(
                  child: AuthFooterText(
                    normalText: TextConstant.dontHaveAccount,
                    actionText: TextConstant.signUp,
                    onTap: () {
                      Get.offNamed(AppRoutes.SIGNUP);
                    },
                  ),
                ),
                AppSize.h32,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
