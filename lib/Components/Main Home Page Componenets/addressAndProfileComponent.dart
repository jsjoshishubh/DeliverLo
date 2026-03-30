import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Routes/app_routes.dart';

class MainHomeAddressAndProfileComponent extends StatefulWidget {
  const MainHomeAddressAndProfileComponent({super.key});

  @override
  State<MainHomeAddressAndProfileComponent> createState() =>
      MainHome_AddressAndProfileComponentState();
}

class MainHome_AddressAndProfileComponentState
    extends State<MainHomeAddressAndProfileComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(border: Border.all(color: redColor,width: 0.4),color: lightRed,shape: BoxShape.circle,),
            child: const Icon(Icons.location_on_outlined,color: redColor,size: 24,),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DELIVER TO',
                  style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontColor: greyFontColor,),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('OTHER - 31, Bhatiyani Chohatta...',overflow: TextOverflow.ellipsis,style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontColor:blackFontColor,),),
                    SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down_rounded,color: blackFontColor,size: 20,),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => Get.toNamed(Routes.PROFILE),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(color: redColor,shape: BoxShape.circle,),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
