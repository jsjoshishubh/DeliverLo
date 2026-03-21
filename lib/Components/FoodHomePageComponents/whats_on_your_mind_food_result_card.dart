import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:deliverylo/Models/grocery_detail_page_args.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:get/get.dart';

class WhatsOnYourMindFoodResultCard extends StatelessWidget {
  const WhatsOnYourMindFoodResultCard({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final isPureVeg = item['isPureVeg'] as bool? ?? false;
    final rating = (item['rating'] as num?)?.toDouble() ?? 4.0;
    final offerText = item['offerText'] as String? ?? '';

    return GestureDetector(
      onTap: () => Get.toNamed(
            Routes.GROCERY_DETAIL_PAGE,
            arguments: GroceryDetailPageArgs.fromWhatsOnMindMap(item),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.asset(
                      item['imageUrl'] as String,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 180,
                        color: greyFontColor.shade50.withValues(alpha: 0.2),
                        child: Icon(Icons.restaurant, color: greyFontColor.shade50, size: 48),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.favorite_border, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 10, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'] as String,
                        style: commonTextStyle(
                          fontSize: 18,
                          fontColor: HexColor.fromHex('#0F172A'),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isPureVeg) ...[
                      const SizedBox(width: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco, size: 14, color: HexColor.fromHex('#16A34A')),
                          const SizedBox(width: 5),
                          Text(
                            'Pure Veg',
                            style: commonTextStyle(
                              fontSize: 12,
                              fontColor: HexColor.fromHex('#1B5E20'),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                // const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${item['cuisine']} • ${item['dish']}, ${item['location']}',
                        style: commonTextStyle(
                          fontSize: 14,
                          fontColor: HexColor.fromHex('#64748B'),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal:8, vertical: 5),
                      decoration: BoxDecoration(
                        color: HexColor.fromHex('#2ECC71'),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            '$rating',
                            style: commonTextStyle(
                              fontSize: 12,
                              fontColor: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time, size: 16, color: HexColor.fromHex('#475569')),
                    const SizedBox(width: 6),
                    Text(
                      item['deliveryTime'] as String? ?? '20-30 min',
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: HexColor.fromHex('#475569'),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.two_wheeler, size: 16, color: HexColor.fromHex('#475569')),
                    const SizedBox(width: 6),
                    Text(
                      item['deliveryFee'] as String? ?? 'Free Fee',
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: HexColor.fromHex('#475569'),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (offerText.isNotEmpty) const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
          if (offerText.isNotEmpty)
            Positioned(
              bottom: 0,
              right: -2,
              child: Container(
                width: 112,
                height: 29,
                padding: const EdgeInsets.only(left: 4, right: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      HexColor.fromHex('#C30001'),
                      HexColor.fromHex('#FFFFFF'),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(28), topLeft: Radius.circular(18),bottomLeft: Radius.circular(18),topRight: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: HexColor.fromHex('#FEC42E'),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '%',
                          style: commonTextStyle(
                            fontSize: 14,
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      offerText,
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: HexColor.fromHex('#FFFFFF'),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
