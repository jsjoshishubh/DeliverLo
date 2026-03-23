import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/ProfilePageComponents/account_option_card_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/past_orders_tab_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/quick_action_card_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  Future<void> _showLogoutConfirmation() async {
    await Get.dialog(
      AlertDialog(
        title: Text(
          'Logout',
          style: commonTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontColor: HexColor.fromHex('#1F2937'),
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: commonTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontColor: HexColor.fromHex('#4B5563'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'No',
              style: commonTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontColor: HexColor.fromHex('#6B7280'),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await Future.delayed(Duration(milliseconds: 100));
              Dialogs.showLoadingDialog(context, _keyLoader, 'Please wait'.tr);
              await Future.delayed(Duration(milliseconds: 200));
              await onClearLocalSetup(callback: () {
                if (_keyLoader.currentContext != null) {
                  Navigator.of(
                    _keyLoader.currentContext!,
                    rootNavigator: true,
                  ).pop();
                }
              });
            },
            child: Text(
              'Yes',
              style: commonTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontColor: HexColor.fromHex('#F97316'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                      InkWell(onTap: () => Get.back(), child: Icon(Icons.arrow_back, size: 24, color: Color(0xFF223042))),
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
                    InkWell(
                      onTap: _showLogoutConfirmation,
                      child: const Icon(Icons.more_vert, size: 24, color: Color(0xFF223042))
                    ),
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

class Dialogs {
  static Future<void> showLoadingDialog(
    BuildContext context,
    GlobalKey key,
    String text,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            key: key,
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: commonTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontColor: HexColor.fromHex('#1F2937'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}