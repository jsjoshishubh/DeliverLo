import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class MainHomeServicesCategoryComponent extends StatelessWidget {
  const MainHomeServicesCategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ServiceCategoryItem> serviceCategories = [
      const _ServiceCategoryItem(
        title: 'Food',
        icon: Icons.restaurant,
        iconColor: Color(0xFFEF7C00),
        bgColor: Color(0xFFF5F1EA),
      ),
      const _ServiceCategoryItem(
        title: 'Grocery',
        icon: Icons.shopping_basket_outlined,
        iconColor: Color(0xFF0EA36B),
        bgColor: Color(0xFFE8F4EF),
      ),
      const _ServiceCategoryItem(
        title: 'Electronics',
        icon: Icons.devices_outlined,
        iconColor: Color(0xFF2E66DD),
        bgColor: Color(0xFFEAF0FA),
      ),
      const _ServiceCategoryItem(
        title: 'Medicine',
        icon: Icons.medication_outlined,
        iconColor: Color(0xFFE32E63),
        bgColor: Color(0xFFF8EEF1),
      ),
    ];

    return Container(
      height: 118,
      child: ListView.builder(
        itemCount: serviceCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = serviceCategories[index];
          return Padding(
            padding: EdgeInsets.only(right: index == serviceCategories.length - 1 ? 0 : 14,left:14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(color: item.bgColor,borderRadius: BorderRadius.circular(12),),
                  child: Icon(item.icon,size: 28,color: item.iconColor,),
                ),
                const SizedBox(height: 10),
                Text(item.title,style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w700,fontColor: greyFontColor,),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ServiceCategoryItem {
  const _ServiceCategoryItem({required this.title,required this.icon,required this.iconColor,required this.bgColor,});

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
}
