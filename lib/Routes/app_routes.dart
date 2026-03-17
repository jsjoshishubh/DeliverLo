import 'package:deliverylo/Views/Google%20Map%20/google_map_page.dart';
import 'package:deliverylo/Views/Login%20and%20Signup/login_signup_page.dart';
import 'package:deliverylo/Views/Login%20and%20Signup/otp_page.dart';
import 'package:deliverylo/Views/Profile%20/Profile_main_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/checkout_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/order_confirmation_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/order_success_deliver_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/order_tracking_page.dart';
import 'package:deliverylo/Views/mainHome/Main_dashboard.dart';
import 'package:deliverylo/Views/mainHome/Search_Details_Page.dart';
import 'package:deliverylo/Views/onBoarding/onBoarding_main_page.dart';
import 'package:get/get.dart';

abstract class Routes{
 static const SPLASHSCREEN = '/splash_screen'; 
 static const ONBOARDING = '/onBoarding'; 
 static const SIGNUPAMDLOGIN = '/login_sign_up'; 
 static const OTP = '/otp'; 
 static const MAIN_DASHBOARD = '/main_dashboard'; 
 static const MAINHOMEPAGE = '/main_home_page'; 
 static const SEARCHDETAILSPAGE = '/search_details_page'; 
 static const CHECKOUT = '/checkout_page'; 
 static const ORDERCONFIRMATION = '/order_confirmation'; 
 static const ORDERTRACKING = '/order_TRACKING'; 
 static const ORDERSUCCESSDELIVER = '/order_success_deliver'; 
 static const GOOGLEMAP = '/google_map_page'; 
 static const PROFILE = '/profile_page'; 
}


abstract class AppPages{
  static final pages =  [
     GetPage(name: Routes.ONBOARDING, page: () => OnBoardingMainPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.SIGNUPAMDLOGIN, page: () => LoginSignUpPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.OTP, page: () => OtpPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.MAIN_DASHBOARD, page: () => MainDashboard(),transition: Transition.fadeIn),
     GetPage(name: Routes.SEARCHDETAILSPAGE, page: () => SearchDetailsPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.CHECKOUT, page: () => CheckoutPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.ORDERCONFIRMATION, page: () => OrderConfimationPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.ORDERTRACKING, page: () => OrdertrackingPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.GOOGLEMAP, page: () => GoogleMapPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.ORDERSUCCESSDELIVER, page: () => OrderSuccessDeliverPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.PROFILE, page: () => ProfileMainPage(),transition: Transition.fadeIn),
  ];
}