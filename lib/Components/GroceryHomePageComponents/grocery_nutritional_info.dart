import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// "Nutritional Info" section with horizontal row of nutrition cards.
class GroceryNutritionalInfo extends StatelessWidget {
  const GroceryNutritionalInfo({
    super.key,
    this.title = 'Nutritional Info',
    this.unitLabel = '(per 100g)',
    this.items,
  });

  final String title;
  final String unitLabel;
  final List<NutritionalInfoItem>? items;

  static final List<NutritionalInfoItem> _defaultItems = [
    NutritionalInfoItem(
      label: 'Calories',
      value: '160',
      unit: 'kcal',
      borderColor: const Color(0xFFFDE68A),
    ),
    NutritionalInfoItem(
      label: 'Fat',
      value: '15g',
      unit: 'Healthy',
      borderColor: const Color(0xFFBBF7D0),
    ),
    NutritionalInfoItem(
      label: 'Carbs',
      value: '9g',
      unit: 'Fiber rich',
      borderColor: const Color(0xFFBFDBFE),
    ),
    NutritionalInfoItem(
      label: 'Protein',
      value: '2g',
      unit: 'Plant-base',
      borderColor: const Color(0xFFFECACA),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final list = items ?? _defaultItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              title,
              style: commonTextStyle(
                fontSize: 18,
                fontColor: const Color(0xFF1A1C2E),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              unitLabel,
              style: commonTextStyle(
                fontSize: 13,
                fontColor: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            for (int i = 0; i < list.length; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < list.length - 1 ? 10 : 0),
                  child: _NutritionCard(item: list[i]),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class NutritionalInfoItem {
  const NutritionalInfoItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.borderColor,
  });

  final String label;
  final String value;
  final String unit;
  final Color borderColor;
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({required this.item});

  final NutritionalInfoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.label,
            style: commonTextStyle(
              fontSize: 12,
              fontColor: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.value,
            style: commonTextStyle(
              fontSize: 18,
              fontColor: const Color(0xFF1A1C2E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.unit,
            style: commonTextStyle(
              fontSize: 11,
              fontColor: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
