import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/oerderTracking_stapper_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/orderTracking_order_summery_card_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/order_timeLine_componenent.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdertrackingPage extends StatefulWidget {
  const OrdertrackingPage({super.key});

  @override
  State<OrdertrackingPage> createState() => _OrdertrackingPageState();
}

class _OrdertrackingPageState extends State<OrdertrackingPage> {
    final List<OrderTimelineItem> _timelineItems = const [
    OrderTimelineItem(
      title: 'Preparing your order',
      subtitle: 'Kitchen is working on it',
      time: '12:25 PM',
      status: OrderTimelineStatus.current,
    ),
    OrderTimelineItem(
      title: 'Order Confirmed',
      subtitle: 'Restaurant accepted order',
      time: '12:15 PM',
      status: OrderTimelineStatus.completed,
    ),
    OrderTimelineItem(
      title: 'Order Placed',
      subtitle: 'We received your order',
      time: '12:14 PM',
      status: OrderTimelineStatus.inactive,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#FFFFFF'),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Container(
                  margin: EdgeInsets.only(top: 60,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                      Text('Order #2481',style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 20, fontWeight: FontWeight.w700),),
                      IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz))
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade300,height: 1,),
                SizedBox(height: 16,),
                Image.asset('Assets/Extras/Overlay.png',scale: 4,),
                SizedBox(height: 16,),
                Text('Your food is being \nprepared! 🎉',textAlign: TextAlign.center,style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 30,fontWeight: FontWeight.w700),),
                SizedBox(height: 10,),
                Text('Estimated arrival: 12:45 PM',textAlign: TextAlign.center,style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 16,fontWeight: FontWeight.w500),),
                SizedBox(height: 30,),
                const OrderTrackingStepperComponent(
                  currentStep: 1,
                ),
                SizedBox(height: 4,),
                OrderSummaryCard(),
                SizedBox(height: 24,),
                OrderTimeline(items: _timelineItems),
                SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Implement help action
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            side: BorderSide(color: HexColor.fromHex('#E2E8F0'),width: 1,),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                            foregroundColor: HexColor.fromHex('#0F172A'),
                            overlayColor: HexColor.fromHex('#E2E8F0').withOpacity(0.15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.help_outline,
                                size: 18,
                                color: HexColor.fromHex('#0F172A'),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Help',
                                style: commonTextStyle(
                                  fontColor: HexColor.fromHex('#0F172A'),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Implement cancel action
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            side: BorderSide(color: HexColor.fromHex('#FECACA'),width: 1,),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                            foregroundColor: HexColor.fromHex('#EF4444'),
                            overlayColor: HexColor.fromHex('#FEE2E2').withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 18,
                                color: HexColor.fromHex('#EF4444'),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Cancel',
                                style: commonTextStyle(
                                  fontColor: HexColor.fromHex('#EF4444'),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                InkWell(
                  onTap: (){
                    Get.toNamed(Routes.GOOGLEMAP);
                  },
                  child: Container(
                    padding:const EdgeInsets.all(6),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 55,
                    decoration: commonContainerBoxDecoration(containerColor: HexColor.fromHex('#F27F0D'),borderRadios: 12,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.map,color: Colors.white,size: 17,),
                        const SizedBox(width: 5),
                        Text(
                          'Track on Map',style: commonTextStyle(fontSize: 20,fontWeight:FontWeight.w700,fontColor: Colors.white),
                        ),
                       
                       
                      ],
                    ),
                  ),
                ),
                 const SizedBox(height: 54),
          ],
        ),
      ),
    );
  }
}

