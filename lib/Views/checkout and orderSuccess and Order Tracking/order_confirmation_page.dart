import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_order_confirmation_map_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/order_confirmation_order_summery_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfimationPage extends StatefulWidget {
  const OrderConfimationPage({super.key});

  @override
  State<OrderConfimationPage> createState() => _OrderConfimationPageState();
}

class _OrderConfimationPageState extends State<OrderConfimationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8FAFC'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 60,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                    Text('Order Confirmation',style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 20, fontWeight: FontWeight.w700),),
                    Text('Help',style: commonTextStyle(fontColor: HexColor.fromHex('#F27F0D'),fontSize: 16, fontWeight: FontWeight.w700),),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300,height: 1,),
              SizedBox(height: 16,),
              Image.asset('Assets/Extras/order_screen.png',scale: 4.4,),
              SizedBox(height: 16,),
              Text('Order Placed!',style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 30,fontWeight: FontWeight.w700),),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:60.0),
                child: Text(
                  'Hang tight! Your delicious meal is being prepared and will be on its way.',
                  textAlign: TextAlign.center,
                  style: commonTextStyle(fontSize: 16,fontColor: HexColor.fromHex('#475569'),fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 20,),
              DeliveryStatusCard(),
              Container(
               child: OrderCard(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal:16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF57C00),
                    Color(0xFFFFA040),
                  ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Icon(
                      Icons.card_giftcard,
                      size: 100,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite_border, color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text(
                              "Share the love!",
                              style: commonTextStyle(
                                fontColor: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                    
                        const SizedBox(height: 10),
                    
                        /// DESCRIPTION
                        Text(
                          "Give friends \$10 off their first order and\nearn \$10 when they eat.",
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                    
                        const SizedBox(height: 20),
                    
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Invite Friends",
                            style: TextStyle(
                              color: HexColor.fromHex('#F27F0D'),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}