import 'package:deliverylo/Views/Google%20Map%20/google_map_page.dart';
import 'package:deliverylo/Views/Login%20and%20Signup/Signup_page.dart';
import 'package:deliverylo/Views/Login%20and%20Signup/login_signup_page.dart';
import 'package:deliverylo/Views/Login%20and%20Signup/otp_page.dart';
import 'package:deliverylo/Views/Main%20Home/main_DashBoard_page.dart';
import 'package:deliverylo/Views/Profile%20/Favourites_page.dart';
import 'package:deliverylo/Views/Profile%20/Profile_main_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/My_Order_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/checkout_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/order_confirmation_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/order_success_deliver_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/order_tracking_page.dart';
import 'package:deliverylo/Views/Food%20Main%20Home/Food_Main_dashboard.dart';
import 'package:deliverylo/Views/Food%20Main%20Home/Search_Details_Page.dart';
import 'package:deliverylo/Views/onBoarding/onBoarding_main_page.dart';
import 'package:get/get.dart';

abstract class Routes{
 static const SPLASHSCREEN = '/splash_screen'; 
 static const ONBOARDING = '/onBoarding'; 
 static const SIGNUPAMDLOGIN = '/login_sign_up'; 
 static const OTP = '/otp'; 
 static const SIGNUP = '/signUP'; 
 static const MAIN_DASHBOARD = '/main_dashboard'; 
 static const FOOD_MAIN_DASHBOARD = '/food_main_dashboard'; 
 static const MAINHOMEPAGE = '/main_home_page'; 
 static const SEARCHDETAILSPAGE = '/search_details_page'; 
 static const CHECKOUT = '/checkout_page'; 
 static const ORDERCONFIRMATION = '/order_confirmation'; 
 static const ORDERTRACKING = '/order_TRACKING'; 
 static const ORDERSUCCESSDELIVER = '/order_success_deliver'; 
 static const GOOGLEMAP = '/google_map_page'; 
 static const PROFILE = '/profile_page'; 
 static const FAVOURITES = '/favourites_page'; 
 static const MYYORDER = '/my_order'; 
}


abstract class AppPages{
  static final pages =  [
     GetPage(name: Routes.ONBOARDING, page: () => OnBoardingMainPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.SIGNUPAMDLOGIN, page: () => LoginSignUpPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.OTP, page: () => OtpPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.SIGNUP, page: () => SignUpPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.MAIN_DASHBOARD, page: () => MainDashBoardPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.FOOD_MAIN_DASHBOARD, page: () => FoodMainDashboard(),transition: Transition.fadeIn),
     GetPage(name: Routes.SEARCHDETAILSPAGE, page: () => SearchDetailsPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.CHECKOUT, page: () => CheckoutPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.ORDERCONFIRMATION, page: () => OrderConfimationPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.ORDERTRACKING, page: () => OrdertrackingPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.GOOGLEMAP, page: () => GoogleMapPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.ORDERSUCCESSDELIVER, page: () => OrderSuccessDeliverPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.PROFILE, page: () => ProfileMainPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.FAVOURITES, page: () => FavouritesPage(),transition: Transition.fadeIn),
     GetPage(name: Routes.MYYORDER, page: () => MyOrderPage(),transition: Transition.fadeIn),
  ];
}