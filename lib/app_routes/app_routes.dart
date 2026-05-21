import 'package:get/get.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_binding/add_budget_binding.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_page/add_budget_page.dart';
import 'package:vaultiq/presentation/auth/login/login_binding/login_binding.dart';
import 'package:vaultiq/presentation/auth/login/login_pages/login_page.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_binding/signup_binding.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_page/signup_page.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_binding/dashboard_binding.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_page/dashboard_page.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_binding/home_binding.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_page/home_page.dart';



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
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
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
    static const HOME = '/home';
}