import 'package:deliverylo/Https%20Requests/server_configs.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Views/onBoarding/onBoarding_main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Config.appFlavor = Flavor.DEV;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = GetStorage();


  renderInitialRoute() {
    bool isLoggedIn = storage.read(isLOGGEDIN) ?? false;
    bool shownOnboard = storage.read('onBorderDone') ?? false;
    if (isLoggedIn){
       return Routes.MAIN_DASHBOARD;
   }else{
      return  shownOnboard ? Routes.SIGNUPAMDLOGIN : Routes.ONBOARDING;
      return Routes.ONBOARDING;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Delivery Lo',
      getPages: AppPages.pages,
      initialRoute: renderInitialRoute(),
      theme: ThemeData(
        fontFamily: 'PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const OnBoardingMainPage(),
    );
  }
}

