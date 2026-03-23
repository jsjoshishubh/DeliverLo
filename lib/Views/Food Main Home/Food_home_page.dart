import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_address_and_search_and_profile_componenet.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_catagory_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_TabBar_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Khana_Khajana_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/select_address_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class FoodHomePageView extends StatefulWidget {
  const FoodHomePageView({super.key});

  @override
  State<FoodHomePageView> createState() => _FoodHomePageViewState();
}

class _FoodHomePageViewState extends State<FoodHomePageView> {
  static const String _selectedAddressStorageKey = 'food_selected_address';
  final GetStorage _storage = GetStorage();
  String _selectedAddressLabel = 'HOME - Savaliya Siddharth';

  @override
  void initState() {
    super.initState();
    _loadSelectedAddressFromStorage();
  }

  Future<void> _onRefresh() async {
    // Simulate refresh - replace with actual data fetching
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() {});
  }

  String _buildAddressLabelFromSelection(Map selection) {
    final String title = (selection['title'] ?? selection['label'] ?? 'Other').toString().trim();
    final String directAddress =
        (selection['address'] ?? selection['fullAddress'] ?? selection['formattedAddress'] ?? '')
            .toString()
            .trim();
    final String composedAddress = [
      (selection['line1'] ?? selection['flat'] ?? '').toString().trim(),
      (selection['line2'] ?? selection['area'] ?? '').toString().trim(),
      (selection['landmark'] ?? '').toString().trim(),
      (selection['city'] ?? '').toString().trim(),
      (selection['state'] ?? '').toString().trim(),
      (selection['pincode'] ?? selection['postalCode'] ?? '').toString().trim(),
    ].where((part) => part.isNotEmpty).join(', ');
    final String address = directAddress.isNotEmpty ? directAddress : composedAddress;
    if (address.isEmpty) return title.toUpperCase();
    return '${title.toUpperCase()} - $address';
  }

  void _loadSelectedAddressFromStorage() {
    final dynamic storedAddress = _storage.read(_selectedAddressStorageKey);
    if (storedAddress is! Map) return;
    final label = _buildAddressLabelFromSelection(storedAddress);
    if (label.trim().isEmpty) return;
    setState(() {
      _selectedAddressLabel = label;
    });
  }

  Future<void> _openSelectAddressBottomSheet() async {
    final dynamic selectedAddress = await showCommonBottomSheet<Map<String, dynamic>>(
      context: context,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.76,
        child: const SelectAddressComponent(),
      ),
    );

    if (!mounted || selectedAddress is! Map) return;

    await _storage.write(
      _selectedAddressStorageKey,
      Map<String, dynamic>.from(selectedAddress),
    );

    setState(() {
      _selectedAddressLabel = _buildAddressLabelFromSelection(selectedAddress);
    });
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
                HomePageAddressAndSearchAndProfileComponenet(
                  onAddressTap: _openSelectAddressBottomSheet,
                  addressLabel: _selectedAddressLabel,
                ),
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
              const SizedBox(height: 10),
              
              Container(
                height: 296,
                child: FoodTabBarComponent(),
              ),
              const SizedBox(height: 10),
              Container(
                child: KhanaKhajanaComponent(),
              ),
              SizedBox(height: 5),
              Container(
                child: WhatsOnYourMindComponent(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
