import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class SearchViewCartButton extends StatelessWidget {
  const SearchViewCartButton({
    super.key,
    required this.itemCount,
    required this.totalAmount,
    this.onTap,
  });

  final int itemCount;
  final String totalAmount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: HexColor.fromHex('#BD0D0E'),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: HexColor.fromHex('#BD0D0E').withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$itemCount ITEM $totalAmount',
              style: commonTextStyle(
                fontSize: 14,
                fontColor: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Text(
                  'View Cart',
                  style: commonTextStyle(
                    fontSize: 14,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.shopping_cart, color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
