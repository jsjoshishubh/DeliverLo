import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class SearchResultsHeaderComponent extends StatelessWidget {
  final int resultCount;
  final String sortBy;
  final VoidCallback? onSortTap;

  const SearchResultsHeaderComponent({super.key,required this.resultCount,this.sortBy = 'Relevance',this.onSortTap,});

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${resultCount} Restaurants found',style: commonTextStyle(fontSize: 16,fontColor: blackFontColor,fontWeight: FontWeight.w600,),),
          GestureDetector(
            onTap: onSortTap ?? () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Sort by: ',style: commonTextStyle(fontSize: 12,fontColor: greyFontColor,fontWeight: FontWeight.w500,),),
                  Text(sortBy,style: commonTextStyle(fontSize: 12,fontColor: blackFontColor,fontWeight: FontWeight.w500,),),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 18, color: blackFontColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
