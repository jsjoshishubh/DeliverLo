import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class BillDetails extends StatefulWidget {
  const BillDetails({super.key});

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {

  List<Map<String, dynamic>> billItems = [
    {
      "title": "Item Total",
      "amount": 600,
      "showInfo": false,
    },
    {
      "title": "Delivery Fee",
      "amount": 20,
      "showInfo": true,
    },
    {
      "title": "Taxes & Charges",
      "amount": 30,
      "showInfo": false,
    },
  ];

  int get grandTotal {
    int total = 0;
    for (var item in billItems) {
      total += item["amount"] as int;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:12),
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
                          item["title"],
                          style: commonTextStyle(
                            fontSize: 14,
                            fontColor: HexColor.fromHex('#475569'),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        if (item["showInfo"])
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
                      "₹ ${item["amount"]}",
                      style:  commonTextStyle(
                        fontSize: 14,
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              );
            },
          ),

          Divider(height: 14,color: Colors.grey.shade300,),

          Row(
            children: [

              Text(
                "Grand Total",
                style:commonTextStyle(
                        fontSize: 18,
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontWeight: FontWeight.w700,
                      ),
              ),

              const Spacer(),

              Text(
                "₹ $grandTotal",
                style:commonTextStyle(
                        fontSize: 18,
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontWeight: FontWeight.w700,
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}