import 'package:deliverylo/Components/Main%20Home%20Page%20Componenets/addressAndProfileComponent.dart';
import 'package:deliverylo/Components/Main%20Home%20Page%20Componenets/carouselOfferComponent.dart';
import 'package:deliverylo/Components/Main%20Home%20Page%20Componenets/servicesCategoryComponent.dart';
import 'package:deliverylo/Components/Main%20Home%20Page%20Componenets/topDealsComponent.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_food_result_card.dart';
import 'package:deliverylo/Data/whats_on_your_mind_data.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> popularItems = categoryFoodResultsJson.values
        .expand((items) => items)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                const MainHomeAddressAndProfileComponent(),
                const SizedBox(height: 38),
                const MainHomeServicesCategoryComponent(),
                const SizedBox(height: 8),
                const MainHomeCarouselOfferComponent(),
                const SizedBox(height: 30),
                const MainHomeTopDealsComponent(),
                const SizedBox(height: 30),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' Popular Near You', style: commonTextStyle(fontSize: 20, fontColor: blackFontColor, fontWeight: FontWeight.w800)),  
                      const SizedBox(height: 15),
                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: popularItems.length,
                          itemBuilder: (context, index) {
                            return WhatsOnYourMindFoodResultCard(
                              item: popularItems[index],
                            );
                          },
                        ),
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
  }
}

