import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// "Why this pick?" section with a 2x2 grid of feature cards.
class GroceryWhyThisPick extends StatelessWidget {
  const GroceryWhyThisPick({
    super.key,
    this.title = 'Why this pick?',
    this.items,
  });

  final String title;
  final List<WhyThisPickItem>? items;

  static final List<WhyThisPickItem> _defaultItems = [
    WhyThisPickItem(
      icon: Icons.eco_rounded,
      iconColor: const Color(0xFF1B5E20),
      iconBgColor: const Color(0xFFDCFCE7),
      title: '100% Organic',
      subtitle: 'Certified',
    ),
    WhyThisPickItem(
      icon: Icons.verified_user_rounded,
      iconColor: const Color(0xFF1E40AF),
      iconBgColor: const Color(0xFFDBEAFE),
      title: 'Quality Check',
      subtitle: 'Passed',
    ),
    WhyThisPickItem(
      icon: Icons.local_shipping_rounded,
      iconColor: const Color(0xFFC2410C),
      iconBgColor: const Color(0xFFFFEDD5),
      title: 'Express',
      subtitle: 'Delivery by 6pm',
    ),
    WhyThisPickItem(
      icon: Icons.health_and_safety_rounded,
      iconColor: const Color(0xFF6D28D9),
      iconBgColor: const Color(0xFFEDE9FE),
      title: 'Hygienic',
      subtitle: 'Packed safely',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final list = items ?? _defaultItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: commonTextStyle(
            fontSize: 18,
            fontColor: const Color(0xFF1A1C2E),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: list.map((e) => _FeatureCard(item: e)).toList(),
        ),
      ],
    );
  }
}

class WhyThisPickItem {
  const WhyThisPickItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.item});

  final WhyThisPickItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: commonTextStyle(
                    fontSize: 15,
                    fontColor: const Color(0xFF1A1C2E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: commonTextStyle(
                    fontSize: 13,
                    fontColor: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
