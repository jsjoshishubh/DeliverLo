import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8F8F8'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context),icon: const Icon(Icons.arrow_back),),
                  Expanded(
                    child: Text(
                      'My Orders',
                      textAlign: TextAlign.center,
                      style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 20,fontWeight: FontWeight.w700,),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
                height: 1,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(color: HexColor.fromHex('#FF8A00'),borderRadius: BorderRadius.circular(12),),
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4,),
                    labelColor: Colors.white,
                    unselectedLabelColor: HexColor.fromHex('#64748B'),
                    labelStyle: commonTextStyle(fontColor: Colors.white,fontSize: 14,fontWeight: FontWeight.w700,),
                    unselectedLabelStyle: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 14,fontWeight: FontWeight.w500,),
                    tabs: const [
                      Tab(text: 'Ongoing'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  color: Colors.white,
                  child: TabBarView(
                    children: [
                      OngoingTab(),
                      HistoryTab(),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}


class OngoingTab extends StatefulWidget {
  const OngoingTab({super.key});

  @override
  State<OngoingTab> createState() => _OngoingTabState();
}

class _OngoingTabState extends State<OngoingTab> {

  double progress = 0.4;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Active Order",style: commonTextStyle(fontSize: 20, fontWeight: FontWeight.w700,fontColor: HexColor.fromHex('#0F172A')),),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 140,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        image: DecorationImage(
                          image: NetworkImage("https://images.unsplash.com/photo-1513104890138-7c749659a591"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 12,
                      bottom: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal:10,vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ESTIMATED ARRIVAL",style: commonTextStyle(fontColor: HexColor.fromHex('#F48C25'), fontSize: 12,fontWeight: FontWeight.w700)),
                            Text("12:45 PM",style: commonTextStyle(fontSize: 14,fontColor: HexColor.fromHex('#0F172A'),fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                /// DETAILS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16,vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text("Burger King",style: commonTextStyle(fontSize: 18,fontWeight: FontWeight.w700,fontColor: HexColor.fromHex('#0F172A')),),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: HexColor.fromHex('#DCFCE7'),borderRadius: BorderRadius.circular(20),),
                            child: Text("COOKING",style: commonTextStyle(fontColor: HexColor.fromHex('#15803D'),fontWeight: FontWeight.w700,fontSize: 12)),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("2 items • ₹1.00",style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'))),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Confirmed",style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 12,fontWeight: FontWeight.w500),),
                          Text("Cooking", style: commonTextStyle(fontColor: HexColor.fromHex('#F48C25'),fontSize: 12,fontWeight: FontWeight.w700)),
                          Text("On the way",style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 12,fontWeight: FontWeight.w500),),
                          Text("Delivered",style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 12,fontWeight: FontWeight.w500),),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.circular(20),),
                        child: FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor.fromHex('#F48C25'),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Your meal is being prepared with love!",style: commonTextStyle(fontColor:HexColor.fromHex('#334155'),fontSize: 14,fontWeight: FontWeight.w500),),
                      ),

                      const SizedBox(height: 16),

                      commonTextWithSufixAndPreFixIcon(
                        buttonTitle: 'Track Order',
                        isPreFixIcon: true,
                        padding: EdgeInsets.all(0),
                        buttonHeight: 50,
                        onTap: (){}
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Text("Past Orders",style: commonTextStyle(fontSize: 20, fontWeight: FontWeight.w700,fontColor: HexColor.fromHex('#0F172A')),),
          SizedBox(height: 10,),
          Container(
            child: HistoryTab(isScrollable: true,)
          )

        ],
      ),
    );
  }
}


class HistoryTab extends StatefulWidget {
  bool isScrollable;
  HistoryTab({super.key,this.isScrollable = false});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {

  final List<Map<String, dynamic>> orders = [
    {
      "title": "Green Salad House",
      "subtitle": "Quinoa Bowl, Avocado Toast...",
      "price": "₹1.00",
      "status": "Delivered",
      "date": "Yesterday"
    },
    {
      "title": "Burger Joint NYC",
      "subtitle": "Classic Cheeseburger...",
      "price": "₹1.00",
      "status": "Delivered",
      "date": "Oct 24"
    },
    {
      "title": "Sushi Master",
      "subtitle": "Salmon Roll, Tuna...",
      "price": "₹1.00",
      "status": "Canceled",
      "date": "Oct 20"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: widget.isScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
      padding: widget.isScrollable ?  EdgeInsets.symmetric(horizontal:1,vertical: 10) :  EdgeInsets.symmetric(horizontal:14,vertical: 14),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final item = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: commonContainerBoxDecoration(containerColor: Colors.white,borderRadios: 20,border:true,brderColor: Colors.grey.shade200),
          
          child: Column(
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage("https://images.unsplash.com/photo-1550547660-d9450f859349"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item["title"],style: commonTextStyle(fontWeight: FontWeight.w700,fontColor: HexColor.fromHex('#0F172A'),fontSize: 16)),
                             Text(item["date"],style:  commonTextStyle(fontColor: HexColor.fromHex('#94A3B8'),fontSize: 12,fontWeight: FontWeight.w400))
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(item["subtitle"], style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 14,fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text("${item["price"]}  • ",style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 14,fontWeight: FontWeight.w700),),
                            Row(
                              children: [
                                item["status"] == "Delivered" ? Icon(Icons.check_circle_outline_outlined,color: HexColor.fromHex('#16A34A'),size: 14,) : Icon(Icons.cancel_outlined,color: HexColor.fromHex('#64748B'),size: 14,),
                                Text(" ${item["status"]}", style: commonTextStyle( fontSize: 12,fontWeight: FontWeight.w500,fontColor: item["status"] == "Delivered" ? HexColor.fromHex('#16A34A'): HexColor.fromHex('#64748B'),),),
                              ],
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),

                 
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey.shade200,),
              const SizedBox(height: 10),
              Row(
                children: [
                   const SizedBox(width:10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: commonContainerBoxDecoration(containerColor: Colors.white,border: true,brderColor: Colors.grey.shade200,borderRadios: 9),
                      alignment: Alignment.center,
                      child: Text("Rate",style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w500,fontColor: HexColor.fromHex('#334155')),),
                    ),
                  ),
                  const SizedBox(width:20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: commonContainerBoxDecoration(containerColor: HexColor.fromHex('#F48C25').withValues(alpha: 0.2),border: false,borderRadios: 9),
                      alignment: Alignment.center,
                      child: Text("Reorder",style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w700,fontColor: HexColor.fromHex('#F48C25')),),
                    ),
                  ),
                   const SizedBox(width:10),
                ],
              ),
              SizedBox(height: 4,)
            ],
          ),
        );
      },
    );
  }
} 