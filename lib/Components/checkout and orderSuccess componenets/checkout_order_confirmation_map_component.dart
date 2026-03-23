import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/order_confirmation_order_summery_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';

class DeliveryStatusCard extends StatelessWidget {
  const DeliveryStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal:16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                  color: Colors.white.withOpacity(0.75),
                ),
              ),

              /// LEFT TEXT
              Positioned(
                left: 20,
                top: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "ESTIMATED\nARRIVAL",
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "25",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "mins",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const Positioned(
                right: 20,
                top: 26,
                child: Text(
                  "#12345",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 1),
          Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.4,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height:10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: Divider(height: 1,color: HexColor.fromHex('#F3F4F6'),),
          ),

          /// DELIVERY LOCATION
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [

                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.blueGrey,
                  ),
                ),

                const SizedBox(width: 14),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivering to",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Jodhpur Char Rasta",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}