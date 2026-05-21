import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/app_routes/app_routes.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 
 await Supabase.initialize(
    url: "https://eqgilxxzbjfawidwncrn.supabase.co",
    anonKey: "sb_publishable_AuCr2nguwsuGVTg51fNnwA_H6J_4cTk",
  );

  
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
       return ScreenUtilInit(
      designSize: Size(360, 690), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) 
      {
        return MediaQuery(
         data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0),),
         child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: getInitialRoute(), 
            getPages: AppPages.routes,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            
       ));
      });
  }

 

static String getInitialRoute() {
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    return AppRoutes.DASHBOARD;
  } else {
    return AppRoutes.LOGIN;
  }
}
}
