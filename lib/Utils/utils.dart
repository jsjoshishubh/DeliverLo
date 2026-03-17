import 'dart:developer';

import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

String isLOGGEDIN = "isLOGGEDIN";
String googleMpaKey = 'AIzaSyD3lX02gdxFt6W3qFPfr0HGqQvAH9-m79M';

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