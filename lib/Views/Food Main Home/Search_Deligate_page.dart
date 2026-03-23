import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_header_component.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_results_list_component.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchDeligatePage extends StatefulWidget {
  const SearchDeligatePage({
    super.key,
    this.searchQuery = "Biryani",
  });

  final String searchQuery;

  @override
  State<SearchDeligatePage> createState() => _SearchDeligatePageState();
}

class _SearchDeligatePageState extends State<SearchDeligatePage> {
  bool _showViewCart = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonAppScreenBackground(
        scrollable: false,
        topColor: HexColor.fromHex('#BD0D0E'),
        bottomColor: HexColor.fromHex('#F8F8F8'),
        topHeight: 180,
        topChild: SearchHeaderComponent(
          searchQuery: widget.searchQuery,
          onBackTap: () => Navigator.of(context).pop(),
          onClearTap: () {},
          onFilterTap: () {},
          onRatingTap: () {},
          onFastDeliveryTap: () {},
        ),
        bottomChild: SearchResultsListComponent(
          resultCount: 142,
          showViewCart: _showViewCart,
          itemCount: 1,
          totalAmount: '₹210',
          onRestaurantTap: (item) => Get.toNamed(Routes.SEARCHDETAILSPAGE, arguments: item),
          onViewCartTap: () {},
          onSortTap: () {},
        ),
      ),
    );
  }
}
