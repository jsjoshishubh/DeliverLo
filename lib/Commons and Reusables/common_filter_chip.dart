import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// Reusable filter chip with optional icon, active/inactive state, and tap callback.
/// Use for filters like Bestseller, Top R, category filters, etc.
class CommonFilterChip extends StatelessWidget {
  const CommonFilterChip({
    super.key,
    required this.label,
    this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isActive ? HexColor.fromHex('#FFF4E6') : HexColor.fromHex('#F9FAFB'),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? HexColor.fromHex('#E88A2E').withValues(alpha: 0.4)
                  : HexColor.fromHex('#E5E7EB'),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon!,
                  size: 18,
                  color: isActive ? HexColor.fromHex('#E88A2E') : HexColor.fromHex('#6B7280'),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: commonTextStyle(
                  fontSize: 12,
                  fontColor: isActive ? HexColor.fromHex('#E88A2E') : HexColor.fromHex('#374151'),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
