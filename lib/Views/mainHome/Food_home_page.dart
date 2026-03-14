import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_address_and_search_and_profile_componenet.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_catagory_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonAppScreenBackground(
        topColor: HexColor.fromHex('#BD0D0E'),
        topHeight: 400,
        topChild: Container(
          child: Column(
            children: [
              HomePageAddressAndSearchAndProfileComponenet(),
              HomePageCatagoryComponent(),
              SizedBox(height: 6,),
              Image.asset('Assets/Extras/cat_5.png',scale: 5,),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('60% OFF',style: commonTextStyle(fontSize: 14,fontColor: Colors.white,fontWeight: FontWeight.w600),),
                    Text('₹60 CASHBACK',style: commonTextStyle(fontSize: 14,fontColor: Colors.white,fontWeight: FontWeight.w600),),
                  ],
                ),
              )
            ],
          )
        ),
        bottomChild: Column(
          children: [],
        ),
      ),
    );
  }
}
