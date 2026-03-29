import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:deliverylo/Models/grocery_detail_page_args.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:get/get.dart';



class KhanaKhajanaComponent extends StatefulWidget {
  final List<Map<String, dynamic>>? items;
  final bool isLoading;
  

  const KhanaKhajanaComponent({
    super.key,
    this.items,
    this.isLoading = false,
  });

  @override
  State<KhanaKhajanaComponent> createState() => _KhanaKhajanaComponentState();
}

class _KhanaKhajanaComponentState extends State<KhanaKhajanaComponent> {
  List<Map<String, dynamic>> get _items => widget.items == null || widget.items!.isEmpty ? [] : widget.items!;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 14),
      decoration: BoxDecoration(
        color: HexColor.fromHex('#E1F2FF'),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Text('Khana Khazana',style: commonTextStyle(fontColor: Colors.transparent,fontSize: 18,fontWeight: FontWeight.w800,).copyWith(foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = blackFontColor.shade50,),),
                        Text('Khana Khazana',style: commonTextStyle(fontColor: yellowColor.shade50,fontSize: 18,fontWeight: FontWeight.w800,),),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 18, color: HexColor.fromHex('#324F98')),
                        const SizedBox(width: 6),
                        Text('Meals at ₹99 + Free Delivery',style: commonTextStyle(fontSize: 12,fontColor: greyFontColor,fontWeight: FontWeight.w500,),),
                      ],
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 4),
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Text(
                //           'See All',
                //           style: commonTextStyle(
                //             fontSize: 14,
                //             fontColor: HexColor.fromHex('#3D4152'),
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //         SizedBox(width: 2),
                //         Icon(Icons.arrow_forward_ios, size: 10, color: HexColor.fromHex('#3D4152')),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            // Horizontal food item list
            widget.isLoading
              ? SizedBox(height: 200,child: Center(child: CircularProgressIndicator(color: HexColor.fromHex('#324F98')),),)
              : SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _buildFoodItemCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemCard(Map<String, dynamic> item) {
    final isVeg = item['isVegetarian'] == true;
    final imagePath = (item['image'] ?? '').toString();
    final isNetworkImage = imagePath.startsWith('http');

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.SEARCHDETAILSPAGE),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: isNetworkImage
                  ? Image.network(
                      imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: greyFontColor.shade50.withOpacity(0.2),
                        child: Icon(Icons.restaurant, color: greyFontColor.shade50),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: greyFontColor.shade50.withOpacity(0.2),
                        child: Icon(Icons.restaurant, color: greyFontColor.shade50),
                      ),
                    ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 24,
                      height: 22,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(4),),
                      child: Icon(Icons.add, color:greenColor, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  border: Border.all(color: isVeg ? HexColor.fromHex('#16A34A') : HexColor.fromHex('#DC2626'),width: 2,),borderRadius: BorderRadius.circular(2),),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isVeg ? HexColor.fromHex('#16A34A') : HexColor.fromHex('#DC2626'),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  (item['name'] ?? '').toString(),
                  style: commonTextStyle(
                    fontSize: 14,
                    fontColor: blackFontColor,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text((item['description'] ?? '').toString(),style: commonTextStyle(fontSize: 11.5,fontColor: greyFontColor,fontWeight: FontWeight.w400,),maxLines: 1,overflow: TextOverflow.ellipsis,),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹${item['originalPrice'] ?? 0}',style: commonTextStyle(fontSize: 12,fontColor: greyFontColor,fontWeight: FontWeight.w400,).copyWith(decoration: TextDecoration.lineThrough,decorationColor: greyFontColor.shade50,),),
                  Text('₹${item['discountedPrice'] ?? 0}',style: commonTextStyle(fontSize: 12,fontColor: blackFontColor,fontWeight: FontWeight.w400,),),
                ],
              ),
              Container(
                width: 45,
                height: 20,
                decoration: BoxDecoration(color:HexColor.fromHex('#F0FDF4'),borderRadius: BorderRadius.circular(10),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 14, color: HexColor.fromHex('#15803D')),
                    const SizedBox(width: 2),
                    Text('${item['rating'] ?? 0}',style: commonTextStyle(fontSize: 12,fontColor: HexColor.fromHex('#15803D'),fontWeight: FontWeight.w800,),),
                  ],
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}
