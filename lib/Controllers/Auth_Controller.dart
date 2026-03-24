import 'dart:developer';
import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:dio/dio.dart' as dio;
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

  onSignUpChange(k,v){
    log('signup --- ${k} ---${v}');
    authFormSignUP.update(k, (value) => v, ifAbsent: ()=> v);
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


  onOtpVerification(context,otpCode)async{
   try {
      changeLoading(true);
      update();
      final url = 'auth/phone/verify-otp';
      final reqObj = {'phone': "+91${loginForm['phone']}",  "otpCode": "${otpCode.toString().trim()}", "role": "user",};
      final response = await dioClient.postRequest(url,context: context,showLoading: true,data: reqObj);
      otpRequestObject.addAll(response.data['data']);
      if(response.data['success']){
        toastWidget('OTP verified successfully',false);
        final bool isNewUser = response.data['data']?['isNewUser'];
        onLocalSetup(
          data: response.data['data'],
          startup: false,
          isNewUser: isNewUser,
          callback: (){
            update();
          },
        );
      }else{
        toastWidget('${response.data['message'].toString().trim()}',true);
        changeLoading(false);
        update();
      }
      changeLoading(false);
      update();
    } catch (e) {
      log('Error ---- ${e}');
      onHandleError(e, error: e);
      changeLoading(false);
      update();
    }
  }


  onResendOtp(context,mobileNumber)async{
   try {
      changeLoading(true);
      update();

      final url = 'auth/phone/resend-otp';
      final reqObj = {'phone': "+91${loginForm['phone']}",};
      final response = await dioClient.postRequest(url,context: context,showLoading: true,data: reqObj);
      otpRequestObject.addAll(response.data['data']);
      toastWidget('OTP sent successfully',false);
      changeLoading(false);
      update();
    } catch (e) {
      toastWidget('User does not exist, Please signup',true);
      changeLoading(false);
      update();
    }
  }

  onSignUp(context) async {
    try {
      changeLoading(true);
      update();
      final url = 'users/me';
      final reqObj = {
        'name': authFormSignUP['name'],
        'email': authFormSignUP['email'],
        'address': authFormSignUP['address'],
        'latitude': authFormSignUP['latitude'],
        'longitude': authFormSignUP['longitude'],
      };
      reqObj.removeWhere((key, value) => value == null || value.toString().trim().isEmpty);
      final formData = dio.FormData.fromMap(reqObj);
      final response = await dioClient.patchRequest(url, data: formData);
      if(response.data['success'] == true){
        toastWidget('Profile updated successfully', false);
        final Map<String, dynamic> responseData = (response.data['data'] is Map<String, dynamic>)
            ? Map<String, dynamic>.from(response.data['data'])
            : <String, dynamic>{};
        final Map<String, dynamic> mergedPayload = <String, dynamic>{}
          ..addAll(otpRequestObject)
          ..addAll(responseData);
        onLocalSetup(
          data: mergedPayload,
          startup: false,
          isNewUser: false,
          callback: (){
            update();
          },
        );
      }else{
        toastWidget('${response.data['message'] ?? 'Unable to update profile'}', true);
      }
      changeLoading(false);
      update();
    } catch (e) {
      log('SignUp API Error ---- ${e}');
      onHandleError(e, error: e);
      changeLoading(false);
      update();
    }
  }



}