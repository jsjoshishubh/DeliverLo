import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

bool _isNetworkImage(String path) {
  final p = path.trim().toLowerCase();
  return p.startsWith('http://') || p.startsWith('https://');
}

class WhatsOnYourMindCategoryItem extends StatelessWidget {
  const WhatsOnYourMindCategoryItem({
    super.key,
    required this.name,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: HexColor.fromHex('#BD0D0E'), width: 2) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isNetworkImage(imagePath)
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: greyFontColor.shade50.withValues(alpha: 0.2),
                          child: Icon(Icons.restaurant, color: greyFontColor.shade50),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: greyFontColor.shade50.withValues(alpha: 0.2),
                          child: Icon(Icons.restaurant, color: greyFontColor.shade50),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 80,
              child: Text(
                name,
                style: commonTextStyle(
                  fontSize: 12,
                  fontColor: HexColor.fromHex('#494949'),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
