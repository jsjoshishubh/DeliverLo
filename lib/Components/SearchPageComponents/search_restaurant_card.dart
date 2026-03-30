import 'dart:math';

import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class SearchRestaurantCard extends StatelessWidget {
  const SearchRestaurantCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final rating = (item['rating'] as num?)?.toDouble() ?? 4.0;
    final offerBadge = item['offerBadge'] as String? ?? '';
    final offerText = item['offerText'] as String? ?? '';
    final imageUrl = item['imageUrl'] as String? ?? '';
    final isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final distanceRaw = item['distance'] as String?;
    final locationRaw = item['location'] as String?;
    final distanceDisplay = (distanceRaw != null && distanceRaw.trim().isNotEmpty)
        ? distanceRaw.trim()
        : (locationRaw != null && locationRaw.trim().isNotEmpty
            ? locationRaw.trim()
            : '2.5 km');
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: imageUrl.isEmpty ? Container(
                      width: 110,
                      height: 110,
                      color: greyFontColor.shade50.withValues(alpha: 0.2),
                      child: Icon(Icons.restaurant, color: greyFontColor.shade50, size: 40),
                    )
                    : isNetwork
                      ? Image.network(
                      imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 110,
                        height: 110,
                        color: greyFontColor.shade50.withValues(alpha: 0.2),
                        child: Icon(Icons.restaurant,color: greyFontColor.shade50, size: 40),
                        ),
                      )
                    : Image.asset(
                      imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 110,
                        height: 110,
                        color: greyFontColor.shade50.withValues(alpha: 0.2),
                        child: Icon(Icons.restaurant, color: greyFontColor.shade50, size: 40),
                      ),
                    ),
                    ),
                  ),
                if (offerBadge.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 30,
                    child: Container(
                      width: 75,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: HexColor.fromHex('#FFFFFF'),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),  
                      child: Center(
                        child: Text(
                          "${offerBadge.toString().split('%').first} % OFF".capitalizeFirst.toString(),
                          style: commonTextStyle(
                            fontSize: 12,
                            fontColor: HexColor.fromHex('#FF5200'),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 16,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_border, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text(
                                item['name'] as String? ?? '',
                                style: commonTextStyle(
                                  fontSize: 16,
                                  fontColor: blackFontColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['cuisine'] as String? ?? '',
                              style: commonTextStyle(
                                fontSize: 12,
                                fontColor:Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 12, color: Colors.white),
                              const SizedBox(width: 2),
                              Text(
                                '${rating}',
                                style: commonTextStyle(
                                  fontSize: 10,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['priceForTwo'] as String? ?? '',
                          style: commonTextStyle(
                            fontSize: 12,
                            fontColor: greyFontColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 13, color: greenColor),
                            const SizedBox(width: 2),
                            Text(
                              (item['deliveryTime'] as String?)?.trim().isNotEmpty == true ? item['deliveryTime'] as String : '25 mins',
                              style: commonTextStyle(
                                fontSize: 12,
                                fontColor: greyFontColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.rotate(
                              angle: pi / 3,
                              child: Icon(Icons.navigation_outlined,size: 14, color: HexColor.fromHex('#002A80')),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              distanceDisplay,
                              style: commonTextStyle(
                                fontSize: 12,
                                fontColor: greyFontColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Divider(
                          color: HexColor.fromHex('#E5E7EB'), height: 1, thickness: 1),
                    ),
                    const SizedBox(height: 15),
                    if (offerText.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.local_offer_outlined,size: 14, color: HexColor.fromHex('#A855F7')),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              offerText,
                              style: commonTextStyle(
                                fontSize: 12,
                                fontColor: greyFontColor,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                    
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
