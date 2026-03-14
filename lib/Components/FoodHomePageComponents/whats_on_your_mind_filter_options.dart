import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class WhatsOnYourMindFilterOptions extends StatelessWidget {
  const WhatsOnYourMindFilterOptions({
    super.key,
    this.onFilter,
    this.onSortBy,
    this.onRating,
    this.onPureVeg,
    this.onOffers,
  });

  final VoidCallback? onFilter;
  final VoidCallback? onSortBy;
  final VoidCallback? onRating;
  final VoidCallback? onPureVeg;
  final VoidCallback? onOffers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          _FilterChip(
            label: 'Filter',
            icon: Icons.tune,
            onTap: onFilter ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Sort by',
            icon: Icons.keyboard_arrow_down,
            onTap: onSortBy ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: '4.0+',
            icon: Icons.star,
            iconColor: HexColor.fromHex('#15803D'),
            labelColor: HexColor.fromHex('#15803D'),
            onTap: onRating ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Pure Veg',
            icon: Icons.eco,
            iconColor: HexColor.fromHex('#16A34A'),
            onTap: onPureVeg ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Offers',
            onTap: onOffers ?? () {},
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.icon,
    this.iconColor,
    this.labelColor,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = labelColor ?? HexColor.fromHex('#3D4152');
    final iconCol = iconColor ?? HexColor.fromHex('#686B78');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: HexColor.fromHex('#D1D5DB')),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: commonTextStyle(
                fontSize: 14,
                fontColor: HexColor.fromHex('#3D4152'),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon!, size: 16, color: iconCol),
            ],
          ],
        ),
      ),
    );
  }
}
