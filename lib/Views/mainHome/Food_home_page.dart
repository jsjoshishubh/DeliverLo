import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_address_and_search_and_profile_componenet.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_catagory_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_TabBar_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Khana_Khajana_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  Future<void> _onRefresh() async {
    // Simulate refresh - replace with actual data fetching
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: HexColor.fromHex('#BD0D0E'),
        child: CommonAppScreenBackground(
            scrollable: true,
          topColor: HexColor.fromHex('#BD0D0E'),
          topHeight: 400,
          topChild: Container(
            child: Column(
              children: [
                HomePageAddressAndSearchAndProfileComponenet(),
                HomePageCatagoryComponent(),
                const SizedBox(height: 6),
                Image.asset('Assets/Extras/cat_5.png', scale: 5),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('60% OFF', style: commonTextStyle(fontSize: 14, fontColor: Colors.white, fontWeight: FontWeight.w600)),
                      Text('₹60 CASHBACK', style: commonTextStyle(fontSize: 14, fontColor: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 296,
                child: FoodTabBarComponent(),
              ),
              const SizedBox(height: 5),
              Container(
                child: KhanaKhajanaComponent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
