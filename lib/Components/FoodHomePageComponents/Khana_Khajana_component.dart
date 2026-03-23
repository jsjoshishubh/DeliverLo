import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:deliverylo/Models/grocery_detail_page_args.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:get/get.dart';

/// Static JSON for Khana Khazana section
List<Map<String, dynamic>> khanaKhazanaJson = [
  {
    'id': 'kk_1',
    'name': 'Chole Bhature',
    'description': 'Luv De Chole Bhature',
    'image': 'Assets/Extras/kk_1.png',
    'originalPrice': 199,
    'discountedPrice': 99,
    'rating': 4.3,
    'isVegetarian': true,
  },
  {
    'id': 'kk_2',
    'name': 'Punjabi Thali',
    'description': 'Luv De Chole Bhature',
    'image': 'Assets/Extras/kk_2.png',
    'originalPrice': 199,
    'discountedPrice': 99,
    'rating': 4.3,
    'isVegetarian': true,
  },
  {
    'id': 'kk_3',
    'name': 'Shawarma',
    'description': 'Luv De Chole Bhature',
    'image': 'Assets/Extras/kk_3.png',
    'originalPrice': 199,
    'discountedPrice': 99,
    'rating': 4.3,
    'isVegetarian': false,
  },
];

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
  List<Map<String, dynamic>> get _items =>
      widget.items == null || widget.items!.isEmpty ? khanaKhazanaJson : widget.items!;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
      decoration: BoxDecoration(
        color: HexColor.fromHex('#E2F2FF'),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Khana Khazana title with yellow fill and dark outline
                    Stack(
                      children: [
                        // Dark outline (stroke)
                        Text(
                          'Khana Khazana',
                          style: commonTextStyle(
                            fontColor: Colors.transparent,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ).copyWith(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1.5
                              ..color = blackFontColor.shade50,
                          ),
                        ),
                        // Yellow fill
                        Text(
                          'Khana Khazana',
                          style: commonTextStyle(
                            fontColor: yellowColor.shade50,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 18, color: HexColor.fromHex('#324F98')),
                        const SizedBox(width: 6),
                        Text(
                          'Meals at ₹99 + Free Delivery',
                          style: commonTextStyle(
                            fontSize: 12,
                            fontColor: HexColor.fromHex('#3D4152'),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'See All',
                          style: commonTextStyle(
                            fontSize: 14,
                            fontColor: HexColor.fromHex('#3D4152'),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward_ios, size: 10, color: HexColor.fromHex('#3D4152')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Horizontal food item list
            widget.isLoading
                ? SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: HexColor.fromHex('#324F98')),
                    ),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
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
      onTap: () => Get.toNamed(
            Routes.GROCERY_DETAIL_PAGE,
            arguments: GroceryDetailPageArgs.fromKhanaMap(item),
          ),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Food image with add button overlay
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
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.add, color: HexColor.fromHex('#16A34A'), size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Dietary indicator + Food name
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:isVeg ? HexColor.fromHex('#16A34A') : HexColor.fromHex('#DC2626'),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
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
              // Container(
              //   width: 8,
              //   height: 8,
              //   decoration: BoxDecoration(
              //     color: isVeg ? greenColor.shade900 : redColor.shade900,
              //     borderRadius: BorderRadius.circular(2),
              //   ),
              //   child: Icon(icon),
              // ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  (item['name'] ?? '').toString(),
                  style: commonTextStyle(
                    fontSize: 14,
                    fontColor: HexColor.fromHex('#3D4152'),
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            (item['description'] ?? '').toString(),
            style: commonTextStyle(
              fontSize: 11,
              fontColor: HexColor.fromHex('#686B78'),
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${item['originalPrice'] ?? 0}',
                    style: commonTextStyle(
                      fontSize: 12,
                      fontColor: HexColor.fromHex('#686B78'),
                      fontWeight: FontWeight.w400,
                    ).copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: greyFontColor.shade50,
                    ),
                  ),
                  Text(
                    '₹${item['discountedPrice'] ?? 0}',
                    style: commonTextStyle(
                      fontSize: 14,
                      fontColor: HexColor.fromHex('#3D4152'),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                width: 45,
                height: 20,
                decoration: BoxDecoration(
                  color:HexColor.fromHex('#F0FDF4'),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 14, color: HexColor.fromHex('#15803D')),
                    const SizedBox(width: 2),
                    Text(
                      '${item['rating'] ?? 0}',
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: HexColor.fromHex('#15803D'),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
