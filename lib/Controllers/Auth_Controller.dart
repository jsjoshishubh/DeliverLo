import 'dart:developer';
import 'dart:io';

import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:get/get.dart';

DioClient dioClient = DioClient();

class AuthController extends GetxController {

  final isLoading = false.obs;

  get loading => this.isLoading.value;

  void changeLoading(bool v) => this.isLoading.value = v;
  Map<String,dynamic> authFormSignUP = {};
  Map<String,dynamic> loginForm = {};
  Map<String,dynamic> otpRequestObject = {};

  onLoginChange(k,v){
    log('auth --- ${k} ---${v}');
    loginForm.update(k, (value) => v,ifAbsent: ()=> v);
    update();
  }

  onLogin(context,)async{
   try {
      changeLoading(true);
      update();
      final url = 'auth/phone/send-otp';
      final reqObj = {'phone': "+91${loginForm['phone']}",};
      log('re2 ---- ${reqObj}');
      final response = await dioClient.postRequest(url,context: context,showLoading: true,data: reqObj);
      log('Response ---- ${response}');
      otpRequestObject.addAll(response.data['data']);
      Get.toNamed(Routes.OTP, arguments: {'mobile': loginForm['phone_number']});
      changeLoading(false);
      update();
    } catch (e) {
      toastWidget('User does not exist, Please signup',true);
      changeLoading(false);
      update();
    }
  }


  onOtpVerification(context,)async{
   try {
      changeLoading(true);
      update();
      final url = 'auth/phone/verify-otp';
      final reqObj = {'phone': "+91${loginForm['phone']}",};
      log('re2 ---- ${reqObj}');
      final response = await dioClient.postRequest(url,context: context,showLoading: true,data: reqObj);
      log('Response ---- ${response}');
      otpRequestObject.addAll(response.data['data']);
      Get.toNamed(Routes.OTP, arguments: {'mobile': loginForm['phone_number']});
      changeLoading(false);
      update();
    } catch (e) {
      toastWidget('User does not exist, Please signup',true);
      changeLoading(false);
      update();
    }
  }



}