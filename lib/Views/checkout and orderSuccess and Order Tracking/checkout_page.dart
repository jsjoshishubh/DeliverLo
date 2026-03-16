import 'package:deliverylo/Commons%20and%20Reusables/common_doted_divider.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_build_details_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_order_summery_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_payment_methods_component.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8FAFC'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Row(
                children: [
                  IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                  Container(
                    width: Get.width/2.1,
                    alignment: Alignment.centerRight,
                    child: Text('Checkout',style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 20, fontWeight: FontWeight.w700),)
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300,height: 1,),
            SizedBox(height: 2,),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    child: ListTile(
                      leading: Image.asset('Assets/Extras/address.png',scale: 3,),
                      title: Text('Home',style: commonTextStyle(fontColor:HexColor.fromHex('#0F172A'),fontSize: 18,fontWeight: FontWeight.w700),),
                      subtitle: Text('123 Main St, Apt 4B, New York, NY',style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 14,fontWeight: FontWeight.w400),),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        decoration: BoxDecoration(color: HexColor.fromHex('#F48C25').withOpacity(0.23),borderRadius: BorderRadius.circular(16)),
                        child: Text('Change',style: commonTextStyle(fontColor: HexColor.fromHex('#F48C25')),),
                      ),
                    )
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: ListTile(
                      leading: Image.asset('Assets/Extras/time.png',scale: 3,),
                      title: Text('Delivery in 15-20 mins',style: commonTextStyle(fontColor:HexColor.fromHex('#0F172A'),fontSize: 18,fontWeight: FontWeight.w700),),
                      subtitle: Text('Standard delivery',style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 14,fontWeight: FontWeight.w400),),
                    )
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:18.0,horizontal: 20),
                    child: Text('Order Summery',style: commonTextStyle(fontColor: HexColor.fromHex('#1D1D1D'),fontWeight:FontWeight.w700,fontSize: 20 ),),
                  ),
                  SizedBox(height: 6,),
                  Container(
                    child: CheckoutOrderSumeryComponent(),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child:  DashedBorder(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: HexColor.fromHex('#F48C25').withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.percent,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          "Apply Coupon",
                          style: commonTextStyle(
                            fontSize: 16,
                            fontColor: HexColor.fromHex('#0F172A'),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Save up to ₹100",
                          style: TextStyle(
                            color: HexColor.fromHex('#F48C25'),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                   padding: const EdgeInsets.symmetric(vertical:0,horizontal: 10),
                    child: Text(
                      "Bill Details",
                      style: commonTextStyle(fontColor: HexColor.fromHex('#1D1D1D'),fontWeight:FontWeight.w700,fontSize: 20 ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BillDetails(),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                   padding: const EdgeInsets.symmetric(vertical:0,horizontal: 6),
                    child: Text(
                      "Payment Method",
                      style: commonTextStyle(fontColor: HexColor.fromHex('#1D1D1D'),fontWeight:FontWeight.w700,fontSize: 20 ),
                    ),
                  ),
                  const SizedBox(height: 15),
                 PaymentMethodComponent(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(color: const Color(0xFFF28C1B),borderRadius: BorderRadius.circular(20),),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TOTAL TO PAY",
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "₹650",
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: ()=> Get.toNamed(Routes.ORDERCONFIRMATION),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: const [
                            Text(
                              "Pay Now",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

