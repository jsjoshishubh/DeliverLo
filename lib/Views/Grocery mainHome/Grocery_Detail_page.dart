import 'package:deliverylo/Commons and Reusables/common_add_to_basket_card.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_detail_screen_background.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_quantity_selector.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_description_section.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_nutritional_info.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_why_this_pick.dart';
import 'package:deliverylo/Models/grocery_detail_page_args.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroceryDetailPage extends StatefulWidget {
  const GroceryDetailPage({super.key});

  @override
  State<GroceryDetailPage> createState() => _GroceryDetailPageState();
}

class _GroceryDetailPageState extends State<GroceryDetailPage> {
  GroceryDetailPageArgs get _args {
    final raw = Get.arguments;
    if (raw is GroceryDetailPageArgs) return raw;
    return GroceryDetailPageArgs.fallback();
  }

  @override
  Widget build(BuildContext context) {
    final a = _args;

    return Scaffold(
      body: GroceryDetailScreenBackground(
        topImageAsset: a.isNetworkImage ? null : a.imagePath,
        topImageUrl: a.isNetworkImage ? a.imagePath : null,
        topHeightFraction: 0.48,
        sheetOverlapFraction: 0.12,
        sheetTopCornerRadius: 38,
        scrollable: true,
        topChild: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _iconButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Get.back(),
                ),
                _iconButton(icon: Icons.favorite_border),
              ],
            ),
          ),
        ),
        bottomChild: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _farmFreshBadge('Farm Fresh'),
                        const SizedBox(width: 10),
                        _ratingBar(
                          rating: a.rating ?? 0,
                          reviewCount: a.reviewCount,
                        ),
                      ],
                    ),
                    // Static price (replace with a.priceText / a.unitLabel when wiring data)
                    Text(
                      '₹240',
                      style: commonTextStyle(
                        fontSize: 28,
                        fontColor: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      a.title,
                      style: commonTextStyle(
                        fontSize: 26,
                        fontColor: const Color(0xFF1A1C2E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                     Text(
                          'per kg',
                          style: commonTextStyle(
                            fontSize: 13,
                            fontColor: const Color(0xFF9EA6B1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  a.subtitle ?? 'Origin: California, USA',
                  style: commonTextStyle(
                    fontSize: 14,
                    fontColor: const Color(0xFF707784),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                GroceryQuantitySelector(
                  initialQuantity: 1,
                  onChanged: (qty) {},
                ),
                const SizedBox(height: 24),
                GroceryWhyThisPick(),
                const SizedBox(height: 24),
                GroceryNutritionalInfo(),
                const SizedBox(height: 24),
                GroceryDescriptionSection(
                  text:
                      'Creamy, buttery, and rich in healthy fats, our organic avocados are hand-picked at peak ripeness. Perfect for guacamole, salads, or spreading on toast. Sourced directly from sustainable farms.',
                ),
                const SizedBox(height: 54),
                CommonAddToBasketCard(
                  priceLabel: 'TOTAL PRICE',
                  priceValue: '₹240',
                  buttonText: 'Add to Basket',
                  icon: Icons.shopping_basket_outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingBar({
    required double rating,
    int? reviewCount,
  }) {
    final clamped = rating.clamp(0.0, 5.0);
    final fullStars = clamped.floor();
    final hasHalf = (clamped - fullStars) >= 0.25;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          IconData icon;
          if (i < fullStars) {
            icon = Icons.star_rounded;
          } else if (i == fullStars && hasHalf) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_rounded;
          }
          return Padding(
            padding: const EdgeInsets.only(right: 1),
            child: Icon(
              icon,
              size: 18,
              color: i < fullStars || (i == fullStars && hasHalf)
                  ? const Color(0xFFFBBF24)
                  : const Color(0xFFE5E7EB),
            ),
          );
        }),
        const SizedBox(width: 6),
        Text(
          '(${reviewCount ?? 0})',
          style: commonTextStyle(
            fontSize: 13,
            fontColor: const Color(0xFF9EA6B1),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _farmFreshBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: commonTextStyle(
              fontSize: 11,
              fontColor: const Color(0xFF1B5E20),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 18),
      ),
    );
  }
}
