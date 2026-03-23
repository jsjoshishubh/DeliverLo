import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/ProfilePageComponents/account_option_card_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/past_orders_tab_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/quick_action_card_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage({super.key});

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F9FAFB'),
      body: CommonAppScreenBackground(
        scrollable: true,
        topColor: HexColor.fromHex('#FDF1EA'),
        bottomColor: HexColor.fromHex('#F9FAFB'),
        topHeight: 290,
        topChild: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ProfileTopChild()
          ),
        ),
        bottomChild: Container(
          child: ProfileBottomChild(),
        ),
      ),
    );
  }
}


class ProfileTopChild extends StatefulWidget {
  const ProfileTopChild({super.key});

  @override
  State<ProfileTopChild> createState() => Profile_TopChildState();
}

class Profile_TopChildState extends State<ProfileTopChild> {

  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.arrow_back, size: 24, color: Color(0xFF223042)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text('Help',style: commonTextStyle(fontColor: HexColor.fromHex('#1F2937'),fontSize: 14,fontWeight: FontWeight.w600,),),
                    ),
                    const SizedBox(width: 18),
                    const Icon(Icons.more_vert, size: 24, color: Color(0xFF223042)),
                  ],
                ),
                const Spacer(),
                Text('Siddhartha',style: commonTextStyle(fontColor: HexColor.fromHex('#1F2937'),fontSize: 30,fontWeight: FontWeight.w800,),),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('+91 - 9714696101',style: commonTextStyle(fontColor: HexColor.fromHex('#1F2937'),fontSize: 14,fontWeight: FontWeight.w400,),),
                    const SizedBox(width: 10),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(color: HexColor.fromHex('#9CA3AF'),shape: BoxShape.circle,),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('siddharthsavaliya17amba@gmail.com',style: commonTextStyle(fontColor: HexColor.fromHex('#6B7280'),fontSize: 14,fontWeight: FontWeight.w400,),),
                const SizedBox(height: 34),
              ],
            );
  }
}


class ProfileBottomChild extends StatefulWidget {
  const ProfileBottomChild({super.key});

  @override
  State<ProfileBottomChild> createState() => _ProfileBottomChildState();
}

class _ProfileBottomChildState extends State<ProfileBottomChild>  {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        QuickActionCards(),
        SizedBox(height: 10),
        AccountOptionsCard(),
        SizedBox(height: 20),
        PastOrdersTabComponent(),
        SizedBox(height: 60),
      ],
    );
  }
}