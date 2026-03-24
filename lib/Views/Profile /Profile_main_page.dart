import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/common_popup_menu_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/account_option_card_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/past_orders_tab_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/quick_action_card_component.dart';
import 'package:deliverylo/Controllers/Profile_Controller.dart';
import 'package:deliverylo/Routes/app_routes.dart';
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
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _profileController.getUserProfileData();
  }

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
            child: GetBuilder<ProfileController>(
              builder: (controller) =>
                  ProfileTopChild(userProfileData: controller.userProfileData),
            ),
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
  final Map<String, dynamic> userProfileData;
  const ProfileTopChild({super.key, required this.userProfileData});

  @override
  State<ProfileTopChild> createState() => Profile_TopChildState();
}

class Profile_TopChildState extends State<ProfileTopChild> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  static const String _menuEditProfile = 'edit_profile';
  static const String _menuLogout = 'logout';
  static const String _menuDeleteUser= 'delete_user';

  void _onProfileMenuSelected(String value) {
    if (value == _menuEditProfile) {
      Get.toNamed(Routes.EDITPROFILE);
    }
    if (value == _menuLogout) {
      _showLogoutConfirmation();
    }
    if (value == _menuDeleteUser) {
      _showDeleteUserConfirmation();
    }
  }

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

  Future<void> _showDeleteUserConfirmation() async {
    await Get.dialog(
      AlertDialog(
        title: Text(
          'Delete user',
          style: commonTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontColor: HexColor.fromHex('#1F2937'),
          ),
        ),
        content: Text(
          'Are you sure you want to delete your profile?',
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
              await Get.find<ProfileController>().deleteUserProfile();
            },
            child: Text(
              'Yes',
              style: commonTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontColor: HexColor.fromHex('#EF4444'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic fullNameValue = widget.userProfileData['displayName'] ?? widget.userProfileData['name'];
    final dynamic emailValue = widget.userProfileData['email'];
    final dynamic phoneValue = widget.userProfileData['mobile'] ?? widget.userProfileData['phone'];
    final String fullName = fullNameValue?.toString().trim().isNotEmpty == true ? fullNameValue.toString().trim() : 'User';
    final String email = emailValue?.toString().trim() ?? '';
    final String phone = phoneValue?.toString().trim() ?? '';

    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Color(0xFF223042),
                      ),
                    ),
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
                    CommonPopupMenuTrigger(
                      items: const [
                        CommonPopupMenuItemData(
                          value: _menuEditProfile,
                          title: 'Edit profile',
                          icon: Icons.edit_outlined,
                        ),
                        CommonPopupMenuItemData(
                          value: _menuLogout,
                          title: 'Logout',
                          icon: Icons.logout_rounded,
                        ),
                        CommonPopupMenuItemData(
                          value: _menuDeleteUser,
                          title: 'Delete Profile',
                          icon: Icons.delete_outline,
                        ),
                      ],
                      onSelected: _onProfileMenuSelected,
                      child: const Icon(
                        Icons.more_vert,
                        size: 24,
                        color: Color(0xFF223042),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(fullName,style: commonTextStyle(fontColor: HexColor.fromHex('#1F2937'),fontSize: 30,fontWeight: FontWeight.w800,),),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text("+${phone}",style: commonTextStyle(fontColor: HexColor.fromHex('#1F2937'),fontSize: 14,fontWeight: FontWeight.w400,),),
                    if (phone.isNotEmpty && email.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(color: HexColor.fromHex('#9CA3AF'),shape: BoxShape.circle,),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(email,style: commonTextStyle(fontColor: HexColor.fromHex('#6B7280'),fontSize: 14,fontWeight: FontWeight.w400,),),
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