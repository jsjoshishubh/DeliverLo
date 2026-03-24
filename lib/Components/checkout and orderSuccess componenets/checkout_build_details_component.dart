import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class BillDetails extends StatelessWidget {
  final int itemSubtotal;
  final int deliveryFee;
  final int taxes;

  const BillDetails({
    super.key,
    this.itemSubtotal = 0,
    this.deliveryFee = 20,
    this.taxes = 30,
  });

  int get grandTotal => itemSubtotal + deliveryFee + taxes;

  @override
  Widget build(BuildContext context) {
    final billItems = <Map<String, dynamic>>[
      {
        'title': 'Item Total',
        'amount': itemSubtotal,
        'showInfo': false,
      },
      {
        'title': 'Delivery Fee',
        'amount': deliveryFee,
        'showInfo': true,
      },
      {
        'title': 'Taxes & Charges',
        'amount': taxes,
        'showInfo': false,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: billItems.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final item = billItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          item['title'] as String,
                          style: commonTextStyle(
                            fontSize: 14,
                            fontColor: HexColor.fromHex('#475569'),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (item['showInfo'] == true)
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '₹ ${item['amount']}',
                      style: commonTextStyle(
                        fontSize: 14,
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(height: 14, color: Colors.grey.shade300),
          Row(
            children: [
              Text(
                'Grand Total',
                style: commonTextStyle(
                  fontSize: 18,
                  fontColor: HexColor.fromHex('#0F172A'),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '₹ $grandTotal',
                style: commonTextStyle(
                  fontSize: 18,
                  fontColor: HexColor.fromHex('#0F172A'),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
