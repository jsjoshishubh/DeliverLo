import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class PaymentMethodComponent extends StatefulWidget {
  const PaymentMethodComponent({super.key});

  @override
  State<PaymentMethodComponent> createState() => _PaymentMethodComponentState();
}

class _PaymentMethodComponentState extends State<PaymentMethodComponent> {

  int selectedIndex = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "title": "Google Pay",
      "subtitle": "upi@gpay",
      "icon": Icons.account_balance_wallet_outlined,
      "addNew": false,
      "arrow": false,
    },
    {
      "title": "Credit / Debit Card",
      "subtitle": "Visa, Mastercard",
      "icon": Icons.credit_card,
      "addNew": true,
      "arrow": false,
    },
    {
      "title": "Net Banking",
      "subtitle": "",
      "icon": Icons.account_balance,
      "addNew": false,
      "arrow": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: paymentMethods.length,
        itemBuilder: (context, index) {
      
          final item = paymentMethods[index];
          final bool isSelected = selectedIndex == index;
      
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? HexColor.fromHex('#F48C25').withValues(alpha: 0.1)
                    : HexColor.fromHex('#FFFFFF'),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? HexColor.fromHex('#F48C25')
                      : const Color(0xffD7DDE5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: HexColor.fromHex('#F48C25'),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
      
                  const SizedBox(width: 10),
      
                  /// Icon
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected? HexColor.fromHex('#F48C25') :Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item["icon"],
                      size: 20,
                      color:isSelected? Colors.white : Colors.blueGrey,
                    ),
                  ),
      
                  const SizedBox(width: 14),
      
                  /// Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
      
                        Text(
                          item["title"],
                          style:commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontWeight:FontWeight.w500,fontSize: 16 )
                        ),
      
                        if (item["subtitle"].toString().isNotEmpty)
                          Text(
                            item["subtitle"],
                            style: commonTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontColor: HexColor.fromHex('#64748B'),
                            ),
                          ),
                      ],
                    ),
                  ),
      
                  /// ADD NEW
                  if (item["addNew"])
                    Text(
                      "ADD NEW",
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: Colors.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
      
                  /// Arrow
                  if (item["arrow"])
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}