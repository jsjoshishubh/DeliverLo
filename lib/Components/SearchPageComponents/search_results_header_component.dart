import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class SearchResultsHeaderComponent extends StatelessWidget {
  const SearchResultsHeaderComponent({
    super.key,
    required this.resultCount,
    this.sortBy = 'Relevance',
    this.onSortTap,
  });

  final int resultCount;
  final String sortBy;
  final VoidCallback? onSortTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$resultCount Restaurants found',
            style: commonTextStyle(
              fontSize: 18,
              fontColor: HexColor.fromHex('#111827'),
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onSortTap ?? () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: HexColor.fromHex('#F1F5F9'),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sort by: ',
                    style: commonTextStyle(
                      fontSize: 12,
                      fontColor: HexColor.fromHex('#6B7280'),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    sortBy,
                    style: commonTextStyle(
                      fontSize: 12,
                      fontColor: HexColor.fromHex('#1F2937'),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 20, color: HexColor.fromHex('#6B7280')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
