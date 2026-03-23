import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class MainHomeTopDealsComponent extends StatelessWidget {
  const MainHomeTopDealsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DealItem> deals = [
      const _DealItem(
        badgeText: 'HOT DEAL',
        badgeColor: Color(0xFFF24857),
        title: 'GROCERY',
        description: 'Starting at low price',
        subtitle: 'Limited time offer',
        imageUrl:
            'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=900&q=80',
      ),
      const _DealItem(
        badgeText: '20% OFF',
        badgeColor: Color(0xFF4B49D7),
        title: 'ELECTRONICS',
        description: 'Save big on latest tech',
        subtitle: 'Ends in 2 days',
        imageUrl:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=80',
      ),
    ];

    return SizedBox(
      height: 265,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department_outlined, color: orangeColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Top Deals for You',
                  style: commonTextStyle(
                    fontColor: blackFontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 226,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final item = deals[index];
                return Padding(
                  padding: EdgeInsets.only(right: index == deals.length - 1 ? 0 : 14),
                  child: _TopDealCard(item: item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopDealCard extends StatelessWidget {
  const _TopDealCard({required this.item});

  final _DealItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 136,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(item.imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(color: item.badgeColor,borderRadius: BorderRadius.circular(12),),
                      child: Text(
                        item.badgeText,
                        style: commonTextStyle(
                          fontColor: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: commonTextStyle(
                      fontColor: orangeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: commonTextStyle(
                      fontColor: blackFontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: commonTextStyle(
                      fontColor: greyFontColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealItem {
  const _DealItem({
    required this.badgeText,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.subtitle,
    required this.imageUrl,
  });

  final String badgeText;
  final Color badgeColor;
  final String title;
  final String description;
  final String subtitle;
  final String imageUrl;
}
