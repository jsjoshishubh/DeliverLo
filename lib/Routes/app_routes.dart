import 'package:deliverylo/Views/Login%20and%20Signup/login_signup_page.dart';
import 'package:deliverylo/Views/Login%20and%20Signup/otp_page.dart';
import 'package:deliverylo/Views/mainHome/Main_dashboard.dart';
import 'package:deliverylo/Views/onBoarding/onBoarding_main_page.dart';
import 'package:get/get.dart';

abstract class Routes{
 static const SPLASHSCREEN = '/splash_screen'; 
 static const ONBOARDING = '/onBoarding'; 
 static const SIGNUPAMDLOGIN = '/login_sign_up'; 
 static const OTP = '/otp'; 
 static const MAIN_DASHBOARD = '/main_dashboard'; 
 static const MAINHOMEPAGE = '/main_home_page'; 
}


abstract class AppPages{
  static final pages =  [
     GetPage(name: Routes.ONBOARDING, page: () => OnBoardingMainPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.SIGNUPAMDLOGIN, page: () => LoginSignUpPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.OTP, page: () => OtpPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.MAIN_DASHBOARD, page: () => MainDashboard(),transition: Transition.fadeIn),
  ];
}