import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class GrocerySnacksDrinksSection extends StatelessWidget {
  const GrocerySnacksDrinksSection({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.take(8).toList();
    final topRow = visibleItems.take(4).toList();
    final bottomRow = visibleItems.length > 4 ? visibleItems.sublist(4, visibleItems.length) : <Map<String, dynamic>>[];

    return Container(
      width: double.infinity,
      color: HexColor.fromHex('#EDF5F0'),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Snacks & drinks',
            style: commonTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontColor: blackFontColor,
            ),
          ),
          const SizedBox(height: 14),
          _FixedRow(items: topRow),
          const SizedBox(height: 12),
          _FixedRow(items: bottomRow),
        ],
      ),
    );
  }
}

class _FixedRow extends StatelessWidget {
  const _FixedRow({required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    final padded = [...items];
    while (padded.length < 4) {
      padded.add({});
    }

    return Row(
      children: List.generate(4, (index) {
        final item = padded[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 3 ? 0 : 10),
            child: item.isEmpty ? const SizedBox.shrink() : _SnackGridCard(item: item),
          ),
        );
      }),
    );
  }
}

class _SnackGridCard extends StatelessWidget {
  const _SnackGridCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item['imageUrl'] as String? ?? '';
    final title = item['title'] as String? ?? '';

    return SizedBox(
      height: 136,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              color: HexColor.fromHex('#EEF2F6'),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 96,
                height: 96,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.fastfood_outlined,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: commonTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontColor: blackFontColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
