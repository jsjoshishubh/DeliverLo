import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class AccountOptionsCard extends StatelessWidget {
  const AccountOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> items = [
      {
        "icon": Icons.description_outlined,
        "title": "Account Statement",
      },
      {
        "icon": Icons.favorite_border,
        "title": "Favourites",
      },
      {
        "icon": Icons.chat_bubble_outline,
        "title": "My order’s",
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      item["icon"],
                      size: 26,
                      color: HexColor.fromHex('#6B7280'),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        item["title"],
                        style: commonTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontColor: HexColor.fromHex('#1F2937')
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: HexColor.fromHex('#6B7280'),
                    )
                  ],
                ),
              ),

              /// DIVIDER
              if (index != items.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xffE5E7EB),
                ),
            ],
          );
        },
      ),
    );
  }
}