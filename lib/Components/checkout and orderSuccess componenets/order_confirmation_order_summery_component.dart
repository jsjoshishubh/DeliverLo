import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

  bool isExpanded = true;

  final List<Map<String, dynamic>> items = [
    {"qty": "1x", "name": "Whopper Meal", "price": 170},
    {"qty": "1x", "name": "Onion Rings (L)", "price": 100},
    {"qty": "1x", "name": "Coke Zero", "price": 30},
  ];

  int get total {
    int t = 0;
    for (var item in items) {
      t += item["price"] as int;
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        children: [

          /// HEADER
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:16,vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xffF4C27D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fastfood, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Burger King",
                        style: commonTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "3 Items",
                        style: commonTextStyle(
                          fontColor: HexColor.fromHex('#64748B'),
                          fontSize: 12,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),

          /// BODY
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:18.0),
                  child: Divider(color: Colors.grey.shade200),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF3F4F6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item["qty"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                /// ITEM NAME
                                Expanded(
                                  child: Text(
                                    item["name"],
                                    style: commonTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontColor: HexColor.fromHex('#334155')
                                    ),
                                  ),
                                ),

                                /// PRICE
                                Text(
                                  "₹${item["price"]}",
                                  style: commonTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontColor: HexColor.fromHex('#0F172A')
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      /// DASHED DIVIDER
                      const Divider(
                        color: Color(0xffE5E7EB),
                      ),

                      const SizedBox(height: 12),

                      /// TOTAL
                      Row(
                        children: [
                          Text(
                            "Total Paid",
                            style: commonTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontColor: HexColor.fromHex('#0F172A')
                            ),
                          ),

                          const Spacer(),

                          Text(
                            "₹$total",
                            style: commonTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontColor: HexColor.fromHex('#F27F0D'),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            secondChild: const SizedBox(),
          )
        ],
      ),
    );
  }
}