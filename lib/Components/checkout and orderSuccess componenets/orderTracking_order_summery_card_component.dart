import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatefulWidget {
  const OrderSummaryCard({super.key});

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {

  final List<Map<String, dynamic>> items = [
    {
      "qty": "2x",
      "name": "Whopper Meal",
      "desc": "Large Fries, Coke Zero",
      "price": 200
    },
    {
      "qty": "1x",
      "name": "Onion Rings",
      "desc": "6 pieces, BBQ Sauce",
      "price": 100
    }
  ];

  int get total {
    int sum = 0;
    for (var item in items) {
      sum += item["price"] as int;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1550547660-d9450f859349",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.6),
                      Colors.transparent
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),

              /// RESTAURANT INFO
              Positioned(
                left: 20,
                bottom: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Burger King",
                      style: commonTextStyle(
                        fontColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                     Text(
                      "Indian • Fast Food",
                      style: commonTextStyle(
                        fontColor: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 4),

          /// ITEMS
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xffF1F5F9),borderRadius: BorderRadius.circular(8),),
                            child: Text(
                              item["qty"],
                              style: commonTextStyle(fontWeight: FontWeight.w700,fontSize: 12,fontColor: HexColor.fromHex('#475569')),
                            ),
                          ),
                      
                          const SizedBox(width: 12),
                      
                          /// NAME + DESC
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                      
                                Text(
                                  item["name"],
                                  style: commonTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontColor: HexColor.fromHex('#0F172A'),
                                  ),
                                ),
                      
                                const SizedBox(height: 4),
                      
                                Text(
                                  item["desc"],
                                  style: commonTextStyle(
                                    fontColor: HexColor.fromHex('#64748B'),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                      
                          /// PRICE
                          Text(
                            "₹${item["price"]}",
                            style:  commonTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontColor: HexColor.fromHex('#0F172A'),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    if(index != items.length - 1)
                    Divider(color: Colors.grey.shade300,),

                  ],
                ),
              );
            },
          ),

          /// TOTAL
          Container(
            margin: const EdgeInsets.symmetric(horizontal:16,vertical: 0),
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16,),
            decoration: BoxDecoration(
              color: HexColor.fromHex('#F8FAFC'),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [

                 Text(
                  "Total Amount",
                  style: commonTextStyle(
                    fontSize: 16,
                    fontColor: HexColor.fromHex('#64748B'),
                    fontWeight: FontWeight.w500,
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
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}