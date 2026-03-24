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
    this.filterSelected = false,
    this.sortBySelected = false,
    this.ratingSelected = false,
    this.pureVegSelected = false,
    this.offersSelected = false,
  });

  final VoidCallback? onFilter;
  final VoidCallback? onSortBy;
  final VoidCallback? onRating;
  final VoidCallback? onPureVeg;
  final VoidCallback? onOffers;
  final bool filterSelected;
  final bool sortBySelected;
  final bool ratingSelected;
  final bool pureVegSelected;
  final bool offersSelected;

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
            isSelected: filterSelected,
            onTap: onFilter ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Sort by',
            icon: Icons.keyboard_arrow_down,
            isSelected: sortBySelected,
            onTap: onSortBy ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: '4.0+',
            icon: Icons.star,
            iconColor: HexColor.fromHex('#15803D'),
            labelColor: HexColor.fromHex('#15803D'),
            isSelected: ratingSelected,
            onTap: onRating ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Pure Veg',
            icon: Icons.eco,
            iconColor: HexColor.fromHex('#16A34A'),
            isSelected: pureVegSelected,
            onTap: onPureVeg ?? () {},
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Offers',
            isSelected: offersSelected,
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
    this.isSelected = false,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Color? labelColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = HexColor.fromHex('#15803D');
    final mutedIcon = HexColor.fromHex('#686B78');
    final defaultText = HexColor.fromHex('#3D4152');
    final textColor = isSelected
        ? accent
        : (labelColor ?? defaultText);
    final iconCol = isSelected
        ? accent
        : (iconColor ?? mutedIcon);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? HexColor.fromHex('#ECFDF5')
              : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? accent : HexColor.fromHex('#D1D5DB'),
            width: isSelected ? 1.5 : 1,
          ),
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
                fontColor: textColor,
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
