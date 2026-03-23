import 'dart:developer';

import 'package:deliverylo/Commons%20and%20Reusables/common_QuantityStepper.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_doted_divider.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutOrderSumeryComponent extends StatefulWidget {
  const CheckoutOrderSumeryComponent({super.key});

  @override
  State<CheckoutOrderSumeryComponent> createState() => _CheckoutOrderSumeryComponentState();
}

class _CheckoutOrderSumeryComponentState extends State<CheckoutOrderSumeryComponent> {
  List orderSummeryItem = [
    {'title':'Spicy Chicken Burger','subTile': 'Extra Cheese, No Onion','id':1,'price':'300','image':'Assets/Extras/buger.png'},
    {'title':'Spicy Chicken Burger','subTile': 'Extra Cheese, No Onion','id':2,'price':'300','image':'Assets/Extras/buger.png'},
  ];

  var incresedPrice;

  getPrice(incresedValue,price){
    if(incresedValue != null){
      final prices = (int.parse(price.toString()) * int.parse(incresedValue.toString()));
      return "₹ ${prices.toString()}";
    }else{
      return "₹ ${price.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: orderSummeryItem.length,
      itemBuilder: (context,index){
        final item = orderSummeryItem[index];
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(item['image'],scale: 3.2,),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4,),
                            Text(item['title'],style: commonTextStyle(fontSize: 18,fontWeight: FontWeight.w600,fontColor: HexColor.fromHex('#1D1D1D')),),
                            SizedBox(height: 4,),
                            Text(item['subTile'],style: commonTextStyle(fontSize: 12,fontColor: Colors.grey.shade500,fontWeight: FontWeight.w400),),
                          ],
                        ),
                      ],
                    )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: QuantityStepper(
                        initialValue: 1,
                        onChanged: (value) {
                          print("Quantity: $value");
                          setState(() {
                            incresedPrice = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(getPrice(incresedPrice,item['price'],).toString())
                  ],
                ),
                ],
              ),
            ),
           orderSummeryItem.length - 1 != index ?               
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: DottedLinePainter(color: Colors.grey.shade300),
                ),
              ) : SizedBox(),
            ]
           
        );
      }
    );
  }
}