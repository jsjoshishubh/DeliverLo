import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class GroceryLowestPricesSection extends StatelessWidget {
  const GroceryLowestPricesSection({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
      color: HexColor.fromHex('#EDF5F0'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [ 
              Expanded(
                child: Text(
                  'LOWEST PRICES ACROSS SURAT',
                  style: commonTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontColor: blackFontColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 248,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) => _LowestPriceCard(item: items[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _LowestPriceCard extends StatelessWidget {
  const _LowestPriceCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item['imageUrl'] as String? ?? '';
    final quantity = item['quantity'] as String? ?? '';
    final name = item['name'] as String? ?? '';
    final rating = item['rating'] as String? ?? '';
    final ratingCount = item['ratingCount'] as String? ?? '';
    final offText = item['offText'] as String? ?? '';
    final unitPrice = item['unitPrice'] as String? ?? '';
    final price = item['price'] as String? ?? '';
    final oldPrice = item['oldPrice'] as String? ?? '';

    return Container(
      width: 168,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
         color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HexColor.fromHex('#E5E7EB')),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.local_grocery_store),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: -12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: HexColor.fromHex('#22C55E'), width: 1.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'ADD',
                      style: commonTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontColor: HexColor.fromHex('#22C55E'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quantity,
                  style: commonTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontColor: greyFontColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: commonTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontColor: blackFontColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, size: 13, color: HexColor.fromHex('#10B981')),
                    const SizedBox(width: 2),
                    Text(
                      rating,
                      style: commonTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontColor: HexColor.fromHex('#10B981'),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '($ratingCount)',
                      style: commonTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontColor: HexColor.fromHex('#98A2B3'),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      offText,
                      style: commonTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontColor: HexColor.fromHex('#10B981'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                Text(
                  unitPrice,
                  style: commonTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontColor: HexColor.fromHex('#667085'),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      price,
                      style: commonTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontColor: HexColor.fromHex('#1D2939'),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      oldPrice,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: HexColor.fromHex('#98A2B3'),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
