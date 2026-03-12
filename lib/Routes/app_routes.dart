import 'package:deliverylo/Views/onBoarding/onBoarding_main_page.dart';
import 'package:get/get.dart';

abstract class Routes{
 static const SPLASHSCREEN = '/splash_screen'; 
 static const ONBOARDING = '/onBoarding'; 
 static const SIGNUP = '/sign_up'; 
 static const LOGIN = '/login'; 
 static const OTP = '/otp'; 
 static const MAINHOMEPAGE = '/main_home_page'; 
}


abstract class AppPages{
  static final pages =  [
     GetPage(name: Routes.ONBOARDING, page: () => OnBoardingMainPage(),transition: Transition.fadeIn),
  ];
}