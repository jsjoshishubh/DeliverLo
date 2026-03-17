import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class QuickActionCards extends StatelessWidget {
  const QuickActionCards({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> items = [
      {
        "icon": Icons.location_on_outlined,
        "title": "Saved\nAddress",
      },
      {
        "icon": Icons.account_balance_wallet_outlined,
        "title": "Payment\nModes",
      },
      {
        "icon": Icons.history,
        "title": "My order",
      },
    ];

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xffE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  item["icon"],
                  size: 28,
                  color: HexColor.fromHex('#1F2937'),
                ),
                const Spacer(),
                Text(
                  item["title"],
                  style: commonTextStyle(
                    fontColor: HexColor.fromHex('#1F2937'),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}