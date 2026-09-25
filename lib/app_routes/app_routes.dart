// Route name constants intentionally use SCREAMING_SNAKE_CASE so they read as
// route identifiers (e.g. AppRoutes.LOGIN). Naming lint suppressed for this file.
// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_binding/add_budget_binding.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_page/add_budget_page.dart';
import 'package:vaultiq/presentation/auth/login/login_binding/login_binding.dart';
import 'package:vaultiq/presentation/auth/login/login_pages/login_page.dart';
import 'package:vaultiq/presentation/auth/profile_picture/profile_picture_binding/profile_picture_binding.dart';
import 'package:vaultiq/presentation/auth/profile_picture/profile_picture_page/profile_picture_page.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_binding/signup_binding.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_page/signup_page.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_binding/dashboard_binding.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_page/dashboard_page.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/change_password/change_password_page/change_password_page.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/edit_profile_page/edit_profile_page.dart';
import 'package:vaultiq/presentation/dashboard/transactions_section/transactions_page/transactions_page.dart';



class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => SignupPage(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.ADDBUDGET,
      page: () => AddBudgetPage(),
      binding: AddBudgetBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
      GetPage(
        name: AppRoutes.EDITPROFILE,
        page: () => const EditProfilePage(),
      ),
      GetPage(
        name: AppRoutes.CHANGEPASSWORD,
        page: () => ChangePasswordPage(),
      ),
      GetPage(
        name: AppRoutes.PROFILEPICTURE,
        page: () => ProfilePicturePage(),
        binding: ProfilePictureBinding(),
      ),
      GetPage(
        name: AppRoutes.TRANSACTIONS,
        page: () => TransactionsPage(),
      ),
  ];
}

class AppRoutes 
{ 
  // Route names define karne ke liye
    static const LOGIN = '/login';
    static const SIGNUP = '/signup';
    static const ADDBUDGET = '/addbudget';
    static const DASHBOARD = '/dashboard';
    static const EDITPROFILE = '/editprofile';
    static const CHANGEPASSWORD = '/changepassword';
    static const PROFILEPICTURE = '/profilepicture';
    static const TRANSACTIONS = '/transactions';
}