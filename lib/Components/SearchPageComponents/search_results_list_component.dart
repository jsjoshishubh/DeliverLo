import 'package:deliverylo/Components/SearchPageComponents/search_restaurant_card.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_results_header_component.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_view_cart_button.dart';
import 'package:deliverylo/Data/search_page_data.dart';
import 'package:flutter/material.dart';

class SearchResultsListComponent extends StatelessWidget {
  const SearchResultsListComponent({
    super.key,
    this.restaurants,
    this.resultCount,
    this.showViewCart = false,
    this.itemCount = 1,
    this.totalAmount = '₹210',
    this.onRestaurantTap,
    this.onViewCartTap,
    this.onSortTap,
  });

  final List<Map<String, dynamic>>? restaurants;
  final int? resultCount;
  final bool showViewCart;
  final int itemCount;
  final String totalAmount;
  final ValueChanged<Map<String, dynamic>>? onRestaurantTap;
  final VoidCallback? onViewCartTap;
  final VoidCallback? onSortTap;

  @override
  Widget build(BuildContext context) {
    final list = restaurants ?? searchResultsJson;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          SearchResultsHeaderComponent(
            resultCount: resultCount ?? list.length,
            onSortTap: onSortTap,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return SearchRestaurantCard(
                  item: list[index],
                  onTap: onRestaurantTap != null ? () => onRestaurantTap!(list[index]) : null,
                );
              },
            ),
          ),
          // if (showViewCart)
          //   SearchViewCartButton(
          //     itemCount: itemCount,
          //     totalAmount: totalAmount,
          //     onTap: onViewCartTap,
          //   ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
