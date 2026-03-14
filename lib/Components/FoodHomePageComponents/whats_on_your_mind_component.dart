import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_category_item.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_filter_options.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_food_result_card.dart';
import 'package:deliverylo/Data/whats_on_your_mind_data.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class WhatsOnYourMindComponent extends StatefulWidget {
  const WhatsOnYourMindComponent({super.key});

  @override
  State<WhatsOnYourMindComponent> createState() => _WhatsOnYourMindComponentState();
}

class _WhatsOnYourMindComponentState extends State<WhatsOnYourMindComponent> {
  String? _selectedCategoryId;
  List<Map<String, dynamic>> _results = [];

  void _onCategoryTap(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _results = categoryFoodResultsJson[categoryId] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
            child: Text(
              "What's on your mind?",
              style: commonTextStyle(
                fontSize: 18,
                fontColor: HexColor.fromHex('#3D4152'),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Category horizontal list
          SizedBox(
            height: 115,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
              itemCount: whatsOnYourMindCategoriesJson.length,
              itemBuilder: (context, index) {
                final cat = whatsOnYourMindCategoriesJson[index];
                final id = cat['id'] as String;
                final isSelected = _selectedCategoryId == id;
                return WhatsOnYourMindCategoryItem(
                  name: cat['name'] as String,
                  imagePath: cat['image'] as String,
                  isSelected: isSelected,
                  onTap: () => _onCategoryTap(id),
                );
              },
            ),
          ),
          // Filter and Sort options
          WhatsOnYourMindFilterOptions(
            onFilter: () {},
            onSortBy: () {},
            onRating: () {},
            onPureVeg: () {},
            onOffers: () {},
          ),
          // Food results (when category selected)
          if (_selectedCategoryId != null && _results.isNotEmpty) ...[
            Transform.translate(
              offset: const Offset(0, -38),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return WhatsOnYourMindFoodResultCard(item: _results[index]);
                },
              ),
            ),
            ),
          ],
        ],
      ),
    );
  }
}
