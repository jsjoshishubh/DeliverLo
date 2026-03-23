import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_address_and_search_and_profile_componenet.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_catagory_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_TabBar_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Khana_Khajana_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/select_address_component.dart';
import 'package:deliverylo/Components/common_image_carousel_component.dart';
import 'package:deliverylo/Controllers/Food_Controller.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodHomePageView extends StatefulWidget {
  const FoodHomePageView({super.key});

  @override
  State<FoodHomePageView> createState() => _FoodHomePageViewState();
}

class _FoodHomePageViewState extends State<FoodHomePageView> {
  static const String _selectedAddressStorageKey = 'food_selected_address';
  final GetStorage _storage = GetStorage();
  final FoodController _foodController =
      Get.isRegistered<FoodController>()
          ? Get.find<FoodController>()
          : Get.put(FoodController());
  String _selectedAddressLabel = 'HOME - Savaliya Siddharth';
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedAddressFromStorage();
    _foodController.getCategoriesAndHomeOfferBanners();
  }

  Future<void> _onRefresh() async {
    await _foodController.getCategoriesAndHomeOfferBanners();
    if (mounted) setState(() {});
  }

  String _buildAddressLabelFromSelection(Map selection) {
    final String title = (selection['title'] ?? selection['label'] ?? 'Other').toString().trim();
    final String directAddress = (selection['address'] ?? selection['fullAddress'] ?? selection['formattedAddress'] ?? '').toString().trim();
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
    return GetBuilder<FoodController>(
      init: _foodController,
      builder: (controller) {
        final apiCategories = controller.categories.map((e) => <String, String>{'title': (e.name ?? '').trim().isEmpty ? 'Category' : (e.name ?? ''),'image': 'Assets/Extras/ct_2.png',}).toList();
        final bannersWithImages = controller.homeOfferBanners
            .where((e) => (e.imageUrl ?? '').trim().isNotEmpty)
            .toList();
        final bannerUrls = bannersWithImages.map((e) => (e.imageUrl ?? '').trim()).toList();
        final safeBannerIndex = bannerUrls.isEmpty
            ? 0
            : (_currentBannerIndex >= bannerUrls.length ? 0 : _currentBannerIndex);

        String dynamicTopColorHex = kFoodHomeAccentHex;
        Color dynamicTopColor = HexColor.fromHex(dynamicTopColorHex);
        if (bannersWithImages.isNotEmpty) {
          final rawColor = (bannersWithImages[safeBannerIndex].backgroundColor ?? '').trim();
          if (rawColor.isNotEmpty) {
            try {
              dynamicTopColorHex = rawColor;
              dynamicTopColor = HexColor.fromHex(rawColor);
            } catch (_) {
              dynamicTopColor = HexColor.fromHex(kFoodHomeAccentHex);
              dynamicTopColorHex = kFoodHomeAccentHex;
            }
          }
        }
        if (controller.homeAccentHex != dynamicTopColorHex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _foodController.setHomeAccentHex(dynamicTopColorHex);
          });
        }

        final List<Map<String, dynamic>> dynamicFoodTabs = [
          {
            'tab_title': 'Highly Ordered',
            'tab_type': '0',
            'api_type': 'highlight',
          },
          {
            'tab_title': 'Fast Delivery',
            'tab_type': '1',
            'api_type': 'fast_delivery',
          },
        ];

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            color: HexColor.fromHex(kFoodHomeAccentHex),
            child: CommonAppScreenBackground(
              scrollable: true,
              topColor: dynamicTopColor,
              topHeight: 420,
              topChild: Container(
                child: Column(
                  children: [
                    HomePageAddressAndSearchAndProfileComponenet(
                      onAddressTap: _openSelectAddressBottomSheet,
                      addressLabel: _selectedAddressLabel,
                    ),
                    HomePageCatagoryComponent(categories: apiCategories),
                    const SizedBox(height: 6),
                    CommonImageCarouselComponent(
                      imageUrls: bannerUrls,
                      height: 145,
                      borderRadius: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      fallbackWidget: Image.asset('Assets/Extras/cat_5.png', scale: 5),
                      onPageChanged: (index) {
                        if (!mounted) return;
                        setState(() {
                          _currentBannerIndex = index;
                        });
                      },
                    ),

                  ],
                ),
              ),
              bottomChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  
                  Container(
                    height: 296,
                    child: FoodTabBarComponent(
                      tabss: dynamicFoodTabs,
                      accentColor: HexColor.fromHex(kFoodHomeAccentHex),
                    ),
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
      },
    );
  }
}
