import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';

String isLOGGEDIN = "isLOGGEDIN";
String googleMpaKey = 'AIzaSyD3lX02gdxFt6W3qFPfr0HGqQvAH9-m79M';

Future<Map<String, dynamic>> fetchCurrentFormattedAddress() async {
  final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isServiceEnabled) {
    throw Exception('Please enable location services.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception('Location permission denied.');
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permission permanently denied. Please enable it from settings.',
    );
  }

  final Position position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );

  final response = await Dio().get(
    'https://maps.googleapis.com/maps/api/geocode/json',
    queryParameters: {
      'latlng': '${position.latitude},${position.longitude}',
      'key': googleMpaKey,
    },
  );

  final data = response.data;
  if (data == null || data['status'] != 'OK') {
    throw Exception('Unable to fetch address from coordinates.');
  }

  final List results = data['results'] ?? [];
  if (results.isEmpty) {
    throw Exception('No address found for current location.');
  }

  return {
    'formatted_address': results.first['formatted_address'] ?? '',
    'latitude': position.latitude,
    'longitude': position.longitude,
  };
}

void onLocalSetup({data, startup, bool? isNewUser, callback}) async {
  try {
    final storage = GetStorage();
    final Map<String, dynamic> payload = (data is Map<String, dynamic>) ? data : <String, dynamic>{};
    final Map<String, dynamic> user = (payload['user'] is Map<String, dynamic>)
        ? payload['user'] as Map<String, dynamic>
        : <String, dynamic>{};

    await storage.write('_id', user['_id']?.toString() ?? '');
    await storage.write('token', payload['accessToken']?.toString() ?? '');
    await storage.write('full_name', user['displayName']?.toString() ?? '');
    await storage.write('email', user['email']?.toString() ?? '');
    await storage.write('mobile', user['phone']?.toString() ?? '');
    await storage.write('roleType', user['role']?.toString() ?? '');
    await storage.write('phoneVerified', user['phoneVerified'] ?? false);
    await storage.write('emailVerified', user['emailVerified'] ?? false);
    await storage.write('isActive', user['isActive'] ?? false);
    await storage.write('signupComplete', user['signupComplete'] ?? false);
    await storage.write('isNewUser', isNewUser ?? (payload['isNewUser'] == true));
    await storage.write(isLOGGEDIN, true);

    if (callback is Function) callback();

    final bool shouldRouteToSignup = isNewUser ?? (payload['isNewUser'] == true);
    if (shouldRouteToSignup) {
      Get.offAllNamed(Routes.SIGNUP);
    } else {
      Get.offAllNamed(Routes.MAIN_DASHBOARD);
    }
  } catch (e) {
    log('Error ---- ${e}');
  }
}

onClearLocalSetup({callback})async {
 try {
  final storage = GetStorage();
  await storage.remove('_id');
  await storage.remove('token');
  await storage.remove('full_name'); 
  await storage.remove('email');
  await storage.remove('mobile');
  await storage.remove('roleType');
  await storage.remove('roleId');
  await storage.remove('refer_code');
  await storage.remove('subscription_status');
  await storage.remove('consent_status');
  await storage.remove('availability_status');
  await storage.remove('user_image');
  await storage.write(isLOGGEDIN, false);

  // await storage.remove('notification_count');
//  await CustomCacheManager().clearCache();
//  if(callback is Function) callback();
//   Get.offAllNamed(Routes.LOGINPAGE);
 } catch (e) {}
}

toastWidget(msg,[hasError]) {
   return showSnackNotification(message: msg,hasError: hasError ?? false);
}

showSnackBar({title = null,message = 'Something went wrong, please try again.',isDismissible = true,duration = const Duration(seconds: 2),icon = const Icon(Icons.info_outline,color: Colors.red,),isError = false }){
  return showSnackNotification(title:title,message: message,toastDuration:duration,hasError:isError);
}

showSnackNotification({title = null,message = null,action,onActionPressed,toastDuration = const Duration(seconds: 2),hasError = false}){
    final isError = (['Something went wrong,please try again later','No internet available'].contains(message) || hasError) ? true:false;
    return showFlash(
      context: Get.context!,
      duration: toastDuration,
      builder: (_, controller) { 
       return Align(
          alignment: Alignment.center,
          child: Flash(
            controller: controller,
            position: FlashPosition.top,
            dismissDirections: FlashDismissDirection.values,
            child: FlashBar(
            behavior: FlashBehavior.floating,
            elevation: 3,
            useSafeArea: true,
            margin: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))),
            backgroundColor:Colors.black.withValues(alpha: 0.8),
            shouldIconPulse: true,
            icon: isError ? const Icon(Icons.error,color: Colors.red,):const Icon(Icons.check_circle,color:Colors.green),
            indicatorColor: isError ? Colors.red:Colors.green,
            title: !['',null].contains(title) ? Text(title,style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),):null,
            content: Text(message ?? '',style: const TextStyle(color: Colors.white),),
            primaryAction: IconButton(onPressed: (){controller.dismiss();}, icon: const Icon(Icons.close,color: Colors.white,)), controller: controller,
          )
          ),
        );
      },
    );
  }

commonContainerBoxDecoration({bool border = false,double borderRadios = 10,Color containerColor = Colors.amber,Color brderColor = Colors.grey}){
  return BoxDecoration(
    border: border ? Border.all(color: brderColor) : null,
    borderRadius: BorderRadius.circular(borderRadios), 
    color: containerColor,
  );
}

getFontSizeForCommonTextSTyle(fontType){
  switch (fontType.toString()) {
    case 'H1':
      return 21.0;
    case 'H2' :
      return 18.0;

    case 'H3':
      return 16.0;

    case 'H4':
      return 14.0;

    case 'Title' :
      return 12.0;

    case 'Subtitle':
      return 11.0;
    default:
      return 14.0;
  }
}

commonTextStyle({Color? fontColor, double? fontSize,String? fontType,FontWeight? fontWeight }){
  return TextStyle(
    color: fontColor == null ?  blackFontColor : fontColor,
    fontSize: fontType != null ? getFontSizeForCommonTextSTyle(fontType) : fontSize == null ? 12 : fontSize,
    fontWeight: fontWeight == null ? FontWeight.w800 : fontWeight,
  );
}

int parsePrice(String? priceStr) {
  if (priceStr == null || priceStr.isEmpty) return 0;
  final cleaned = priceStr.replaceAll(RegExp(r'[^\d]'), '');
  return int.tryParse(cleaned) ?? 0;
}


  Widget buildAddOnCard({required String title,required String subtitle,required IconData icon,required Color iconColor,required Widget trailing,required Color iconBackground}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16),border: Border.all(color: HexColor.fromHex('#E5E7EB')),),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(shape: BoxShape.circle,color: iconBackground,),
            child: Icon(icon,size: 20,color: iconColor,),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: commonTextStyle(fontColor: HexColor.fromHex('#1F2937'),fontSize: 14,fontWeight: FontWeight.w400,),),
                const SizedBox(height: 4),
                Text(subtitle,style: commonTextStyle(fontColor: HexColor.fromHex('#6B7280'),fontSize: 12,fontWeight: FontWeight.w400,),),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget buildPortionChip({required String label,required String value,required Function onTap,required Color activeColor,required  String selectedPortion}) {
    final bool isSelected = selectedPortion == value;
    final Color activeColor = HexColor.fromHex('#FF5200');

    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : HexColor.fromHex('#E5E7EB'),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: commonTextStyle(
            fontColor: isSelected ? activeColor : HexColor.fromHex('#4B5563'),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

commonTextWithSufixAndPreFixIcon({Function? onTap, IconData? preFixicon, bool isPreFixIcon = false,String buttonTitle = 'Done', bool isSufixIcon = false, IconData? sufixIcon, EdgeInsets? padding,double buttonHeight = 55 }){
  return InkWell(
    onTap: (){
      onTap!();
    },
    child: Container(
      padding:const EdgeInsets.all(6),
      margin: padding == null ? EdgeInsets.symmetric(horizontal: 20) : padding, 
      height: buttonHeight,
      decoration: commonContainerBoxDecoration(containerColor: HexColor.fromHex('#F27F0D'),borderRadios: 12,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         isPreFixIcon ? Icon(preFixicon ?? Icons.map,color: Colors.white,size: 20,) : SizedBox(),
          const SizedBox(width: 5),
          Text(
            '${buttonTitle}',style: commonTextStyle(fontSize: 20,fontWeight:FontWeight.w700,fontColor: Colors.white),
          ),
          SizedBox(width: 5,),
          isSufixIcon ? Icon(sufixIcon ?? Icons.map,color: Colors.white,size: 20,) : SizedBox(),
          
        ],
      ),
    ),
  );
}


void onHandleError({required dynamic error, Function? onCallback, List<String>? validationKey,}) {
  int? statusCode;
  dynamic errorData;
  String? message;

  if (error is DioException) {
    final responseData = error.response?.data;
    statusCode = error.response?.statusCode;

    if (responseData is Map<String, dynamic>) {
      message = (responseData['message'] ??
              responseData['errorMessage'] ??
              responseData['error'])
          ?.toString();
      errorData = responseData['error'] ?? responseData['errors'] ?? responseData;
    } else if (responseData is String && responseData.trim().isNotEmpty) {
      message = responseData;
      errorData = responseData;
    }

    message ??= error.message;
  } else if (error is CustomResponse) {
    statusCode = error.statusCode;
    message = error.message?.toString();
    errorData = error.error;
  } else if (error is Map<String, dynamic>) {
    statusCode = error['statusCode'] ?? error['code'];
    message = (error['message'] ?? error['errorMessage'] ?? error['error'])?.toString();
    errorData = error['error'] ?? error['errors'] ?? error;
  } else if (error is String) {
    message = error;
  } else {
    message = error?.toString();
  }

  log('Error caught — StatusCode: ---- ${statusCode}, Message: ----- ${message}');

  switch (statusCode) {
     case 400:
      if (onCallback != null) onCallback();
      showSnackNotification(
        message: (message?.toString().trim().isNotEmpty ?? false)
            ? message!.toString().capitalizeFirst
            : 'Something went wrong'.tr,
        hasError: true,
      );
      break;
    case 500:
      if (onCallback != null) onCallback();
      showSnackNotification(
        message: (message?.toString().trim().isNotEmpty ?? false)
            ? message!.toString().capitalizeFirst
            : 'Something went wrong'.tr,
        hasError: true,
      );
      break;

    case 502:
      showSnackNotification(
        message: (message?.toString().trim().isNotEmpty ?? false)
            ? message!.toString().capitalizeFirst
            : 'Server error, please try again later'.tr,
        hasError: true,
      );
      onClearLocalSetup();
      break;

    case 422:
      if (validationKey != null && errorData is Map) {
        for (var key in validationKey) {
          final val = errorData[key];
          if (val is List && val.isNotEmpty) {
            final validationMsg = val[0];
            if (validationMsg != null && validationMsg.toString().isNotEmpty) {
              showSnackNotification(
                message: validationMsg.toString().capitalizeFirst,
                hasError: true,
              );
              return;
            }
          }
        }
      }

      showSnackNotification(
        message: (message?.toString().trim().isNotEmpty ?? false)
            ? message!.toString().capitalizeFirst
            : 'Something went wrong, please try again later'.tr,
        hasError: true,
      );
      break;

    default:
      showSnackNotification(
        message: (message?.toString().trim().isNotEmpty ?? false)
            ? message!.toString().capitalizeFirst
            : 'Something went wrong, please try again later'.tr,
        hasError: true,
      );
      break;
  }
}