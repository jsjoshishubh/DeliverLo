import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class GroceryYouMightNeedSection extends StatelessWidget {
  const GroceryYouMightNeedSection({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: HexColor.fromHex('#EDF5F0'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'You might need',
              style: commonTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                fontColor: HexColor.fromHex('#1F2937'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 255,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemBuilder: (context, index) {
                final item = items[index];
                return _GroceryNeedCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GroceryNeedCard extends StatelessWidget {
  const _GroceryNeedCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item['imageUrl'] as String? ?? '';
    final quantity = item['quantity'] as String? ?? '';
    final name = item['name'] as String? ?? '';
    final price = item['price'] as String? ?? '';
    final oldPrice = item['oldPrice'] as String? ?? '';

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(10),
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: Colors.grey.shade300,
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
          const SizedBox(height: 15),
          Text(
            quantity,style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w400,fontColor: greyFontColor),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w700,fontColor: blackFontColor,),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w700,fontColor: blackFontColor,),
              ),
              const SizedBox(width: 8),
              Text(
                oldPrice,
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: HexColor.fromHex('#9CA3AF'),decoration: TextDecoration.lineThrough,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
