import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class CommonPopupMenuItemData {
  final String value;
  final String title;
  final IconData icon;

  const CommonPopupMenuItemData({
    required this.value,
    required this.title,
    required this.icon,
  });
}

class CommonPopupMenuTrigger extends StatelessWidget {
  final Widget child;
  final List<CommonPopupMenuItemData> items;
  final ValueChanged<String> onSelected;

  const CommonPopupMenuTrigger({
    super.key,
    required this.child,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) {
        return items
            .map(
              (item) => PopupMenuItem<String>(
                value: item.value,
                child: Row(
                  children: [
                    Icon(item.icon, size: 18, color: HexColor.fromHex('#1F2937')),
                    const SizedBox(width: 10),
                    Text(
                      item.title,
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#1F2937'),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
      child: child,
    );
  }
}
