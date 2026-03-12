import 'dart:developer';

import 'package:deliverylo/Routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

String isLOGGEDIN = "isLOGGEDIN";
String googleMpaKey = 'AIzaSyCr2bGeCuuWXEIDQIrtRjfdkb5-zrwNQ5w';

void onLocalSetup({data,startup,callback}) async {
  try {
  final storage = GetStorage();
  final userId = data['_id'].toString();
  await storage.write('_id', userId);
  final at = '${data['token']}';
  await storage.write('token', at);
  // await storage.write('user_image', data['image']);
  await storage.write('full_name', '${data['full_name']}');
  await storage.write('email', data['email']);
  await storage.write('mobile', data['mobile'] ?? '');
  await storage.write('roleType', data['roleType'] ?? '');
  await storage.write('roleId', data['roleId'] ?? '');
  await storage.write('subscription_status', data['subscription_status'] ?? '');
  // await storage.write('user_image', data['image' ?? '']);
  await storage.write('refer_code', data['refer_code' ?? '']);
  await storage.write('consent_status', data['consent_status'] ?? false);
  await storage.write('availability_status', data['availability_status'] == 'ACTIVE' ? true : false);
  await storage.write(isLOGGEDIN, true);
  
  if(callback is Function) callback();
   if(!['',null].contains(startup)){
    // Get.offAllNamed(Routes.);
    // Get.toNamed(Routes.MAIN_HOME_PAGE);;
  }else{
    //  Get.offAndToNamed(Routes.MAIN_HOME_PAGE);
  }
  } catch (e) {
    log('Error  ---- ${e}');
  }
}

onClearLocalSetup({callback})async {
 try {
  final storage = GetStorage();
  final userId = storage.read('_id');
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

commonContainerBoxDecoration({bool border = false,double borderRadios = 10,Color containerColor = Colors.amber}){
  return BoxDecoration(
    border: border ? Border.all() : null,
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
    color: fontColor == null ?  Colors.black : fontColor,
    fontSize: fontType != null ? getFontSizeForCommonTextSTyle(fontType) : fontSize == null ? 12 : fontSize,
    fontWeight: fontWeight == null ? FontWeight.w800 : fontWeight,
  );
}