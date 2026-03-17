import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessDeliverPage extends StatefulWidget {
  const OrderSuccessDeliverPage({super.key});

  @override
  State<OrderSuccessDeliverPage> createState() => _OrderSuccessDeliverPageState();
}

class _OrderSuccessDeliverPageState extends State<OrderSuccessDeliverPage> {
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
                    Text('Review Order',style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 20, fontWeight: FontWeight.w700),),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Skip',style: commonTextStyle(fontColor: HexColor.fromHex('#F48C25'),fontSize: 16, fontWeight: FontWeight.w500),),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300,height: 1,),
              SizedBox(height: 16,),
              Image.asset('Assets/Extras/order_delivered.png',scale: 4,),
              SizedBox(height: 16,),
              Container(
                child: Column(
                  children: [
                    Text('Order Delivered!',style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 24, fontWeight: FontWeight.w700),),
                    Text('Enjoy your meal from Burger King',style: commonTextStyle(fontColor: HexColor.fromHex('#64748B'),fontSize: 14, fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
        
              RateFoodCard(),
              RateRiderCard(),
              SizedBox(height: 26,),
               InkWell(
              onTap: (){
                Get.offAllNamed(Routes.MAIN_DASHBOARD);
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
                   
                   
                    Text(
                      'Submit Review',style: commonTextStyle(fontSize: 20,fontWeight:FontWeight.w700,fontColor: Colors.white),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.send,color: Colors.white,size: 17,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 36,),
          ],
        ),
      ),
    );
  }
}



class RateFoodCard extends StatefulWidget {
  const RateFoodCard({super.key});

  @override
  State<RateFoodCard> createState() => _RateFoodCardState();
}

class _RateFoodCardState extends State<RateFoodCard> {
  int rating = 4;

  final List<String> tags = [
    "Great Taste",
    "Nice Packaging",
    "Good Portion",
  ];

  int selectedTagIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xffF8BBD0), Color(0xffF48FB1)],
                  ),
                ),
                child: const Icon(Icons.fastfood, color: Colors.white),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rate your Food",
                    style: commonTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontColor: HexColor.fromHex('#0F172A'),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Whopper Meal • 2 items",
                    style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontColor: HexColor.fromHex('#64748B')),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 16),

          /// STAR RATING
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    rating = index + 1;
                  });
                },
                child: Icon(
                  Icons.star,
                  size: 30,
                  color: index < rating
                      ? Colors.orange
                      : Colors.grey.shade300,
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          /// TAGS
          Wrap(
            spacing: 10,
            children: List.generate(tags.length, (index) {
              bool isSelected = selectedTagIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTagIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Colors.orange
                          : const Color(0xffD1D5DB),
                    ),
                  ),
                  child: Text(
                    tags[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.orange
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          /// INPUT BOX
          Container(
            height: 100,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Tell us more about your experience...",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class RateRiderCard extends StatefulWidget {
  const RateRiderCard({super.key});

  @override
  State<RateRiderCard> createState() => _RateRiderCardState();
}

class _RateRiderCardState extends State<RateRiderCard> {
  int rating = 4;

  final List<int> tips = [10, 30, 50, 100];
  int selectedTipIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [

              /// AVATAR
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: Image.asset('Assets/Extras/rider.png',scale: 4,),
              ),

              const SizedBox(width: 12),

              /// NAME
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rate your Rider",
                      style: commonTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontColor: HexColor.fromHex('#0F172A'),
                      ),
                    ),
                    const SizedBox(height: 4),
                     Text(
                      "Michael S.",
                      style: commonTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontColor: HexColor.fromHex('#64748B'),
                      ),
                    ),
                  ],
                ),
              ),

              /// STARS
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      size: 20,
                      color: index < rating
                          ? Colors.orange
                          : Colors.grey.shade300,
                    ),
                  );
                }),
              )
            ],
          ),

          const SizedBox(height: 20),

          /// TIP TITLE
          Text(
            "Tip your Rider",
            style: commonTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontColor: HexColor.fromHex('#334155'),
            ),
          ),

          const SizedBox(height: 12),

          /// TIP OPTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(tips.length, (index) {
              bool isSelected = selectedTipIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTipIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: index != tips.length - 1 ? 10 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey.shade200,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "₹${tips[index]}",
                      style: commonTextStyle(
                        fontWeight: FontWeight.w600,
                          fontSize: 14,
                        fontColor: isSelected ? Colors.orange : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 14),

          /// FOOTER TEXT
           Center(
            child: Text(
              "100% of the tip goes to your rider.",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: HexColor.fromHex('#94A3B8'),
                fontSize: 12,
              ),
            ),
          ),

         
        ],
      ),
    );
  }
}