import 'dart:developer';

import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
         isPreFixIcon ? Icon(preFixicon == null ? Icons.map : preFixicon!,color: Colors.white,size: 20,) : SizedBox(),
          const SizedBox(width: 5),
          Text(
            '${buttonTitle}',style: commonTextStyle(fontSize: 20,fontWeight:FontWeight.w700,fontColor: Colors.white),
          ),
          SizedBox(width: 5,),
          isSufixIcon ? Icon(sufixIcon == null ? Icons.map : sufixIcon!,color: Colors.white,size: 20,) : SizedBox(),
          
        ],
      ),
    ),
  );
}