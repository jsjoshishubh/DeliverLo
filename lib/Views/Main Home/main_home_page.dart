import 'package:deliverylo/Components/Main%20Home%20Page%20Componenets/addressAndProfileComponent.dart';
import 'package:deliverylo/Components/Main%20Home%20Page%20Componenets/carouselOfferComponent.dart';
import 'package:deliverylo/Components/Main%20Home%20Page%20Componenets/topDealsComponent.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_food_result_card.dart';
import 'package:deliverylo/Controllers/Main_home_page.controller.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  static const String _selectedAddressStorageKey = 'food_selected_address';
  final GetStorage _storage = GetStorage();
  final GlobalKey<MainHome_AddressAndProfileComponentState> _addressHeaderKey =
      GlobalKey<MainHome_AddressAndProfileComponentState>();
  final MainHomePageController _mainHomePageController = Get.isRegistered<MainHomePageController>() ? Get.find<MainHomePageController>() : Get.put(MainHomePageController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mainHomePageController.getMainHomePopularItems();
      final dynamic saved = _storage.read(_selectedAddressStorageKey);
      final hasAddress = saved is Map && saved.isNotEmpty;
      if (!hasAddress) {
        _addressHeaderKey.currentState?.openSelectAddressBottomSheet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: _mainHomePageController,
        builder: (GetxController controller) {
          final c = controller as MainHomePageController;
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => _mainHomePageController.getMainHomePopularItems(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      MainHomeAddressAndProfileComponent(key: _addressHeaderKey),
                      const SizedBox(height:20),
                      // const MainHomeServicesCategoryComponent(),
                      const SizedBox(height: 18),
                      const MainHomeCarouselOfferComponent(),
                      const SizedBox(height: 10),
                      const MainHomeTopDealsComponent(),
                      const SizedBox(height: 10),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(' You might like',style: commonTextStyle(fontColor: blackFontColor,fontSize: 18,fontWeight: FontWeight.w700,)),  
                            const SizedBox(height: 15),
                            if (c.loading && c.popularItems.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            else if (c.popularItems.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'No popular food items available right now.',
                                  style: commonTextStyle(
                                    fontColor: greyFontColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: c.popularItems.length,
                                itemBuilder: (context, index) {
                                  final item = c.popularItems[index];
                                  return WhatsOnYourMindFoodResultCard(
                                    item: item,
                                    onTap: () {
                                      final args = Map<String, dynamic>.from(item);
                                      final vendorId = (item['vendorId'] ?? '').toString().trim();
                                      if (vendorId.isNotEmpty) {
                                        args['vendorId'] = vendorId;
                                      }
                                      Get.toNamed(Routes.SEARCHDETAILSPAGE, arguments: args);
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

