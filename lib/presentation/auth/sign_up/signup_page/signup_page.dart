import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/icon_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/constant/widget_constant/auth_footer_txt.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/constant/widget_constant/widget_constant.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_controller/signup_controller.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final SignupController signUpController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Padding(
        padding:AppPadding.screen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppSize.h100,
              Text(
                TextConstant.createAccount,
                style: TextStyle(
                  fontSize: AppTextSize.extraLarge,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.txtColor,
                ),
              ),
              Text(
                TextConstant.letgetStarted,
                style: TextStyle(
                  fontSize: AppTextSize.medium,
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.txtColor,
                ),
              ),
              AppSize.h40,
              CustomTextField(
                label: TextConstant.nameLabel,
                hint: TextConstant.nameHint,
                controller: signUpController.nameController.value,
              ),
              AppSize.h20,
              CustomTextField(
                label: TextConstant.emailSignUpLabel,
                hint: TextConstant.emailSignUpHint,
                controller: signUpController.emailController.value,
              ),
              SizedBox(height: 20),
              Obx(
                () => CustomTextField(
                  label: TextConstant.passwordLabel,
                  hint: TextConstant.passwordHint,
                  controller: signUpController.passwordController.value,
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
                  controller: signUpController.confirmPasswordController.value,
                  isPassword: true,
                  isPasswordVisible:
                      signUpController.isConfirmPasswordVisible.value,
                  onTogglePassword: () =>
                      signUpController.isConfirmPasswordVisible.value =
                          !signUpController.isConfirmPasswordVisible.value,
                ),
              ),
              AppSize.h40,
              CustomButton(
                label: TextConstant.signUp,
                onPressed: () {
                      
                   if(signUpController.nameController.value.text.trim().isEmpty)
                   {
                    AppSnackbar.error(message: TextConstant.nameEmptyError);
                    return;  
                   }

                   if(
                      signUpController.emailController.value.text.trim().isEmpty ||
                      signUpController.passwordController.value.text.trim().isEmpty ||
                      signUpController.confirmPasswordController.value.text.trim().isEmpty) 
                      {
                    AppSnackbar.error(message: TextConstant.emailPasswordRequired);
                    return;  
                    }   

                  signUpController.userSignUp(
                    name: signUpController.nameController.value.text.trim(),
                    email: signUpController.emailController.value.text.trim(),
                    password: signUpController.passwordController.value.text.trim(),
                    confirmPassword: signUpController.confirmPasswordController.value.text.trim(),
                  );
                },
              ),
              AppSize.h20,
              WidgetConstant.orWidget(context),
              AppSize.h20,
              CustomButton(
                label: TextConstant.signUpwithGoogle,
                variant: ButtonVariant.outline,
                onPressed: () {},
                prefixIcon: Image.asset(
                  IconConstant.googleIcon,
                  width: 20,
                  height: 20,
                ),
              ),
              AppSize.h20,
              AuthFooterText(
                normalText: TextConstant.alreadyHaveAccount,
                actionText: TextConstant.login,
                onTap: () {
                  Get.toNamed(AppRoutes.LOGIN);
                },
              ),
              AppSize.h60,
            ],
          ),
        ),
      ),
    );
  }
}
