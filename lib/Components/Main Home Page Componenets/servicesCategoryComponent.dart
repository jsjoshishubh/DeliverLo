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

    return SizedBox(
      height: 138,
      child: ListView.builder(
        itemCount: serviceCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = serviceCategories[index];
          return Padding(
            padding: EdgeInsets.only(right: index == serviceCategories.length - 1 ? 0 : 22,),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: item.bgColor,borderRadius: BorderRadius.circular(20),),
                  child: Icon(item.icon,size: 32,color: item.iconColor,),
                ),
                const SizedBox(height: 10),
                Text(item.title,style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w700,fontColor: blackFontColor,),
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
