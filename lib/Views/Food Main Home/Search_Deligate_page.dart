import 'dart:async';

import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_header_component.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_results_list_component.dart';
import 'package:deliverylo/Controllers/Food_Controller.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchDeligatePage extends StatefulWidget {
  const SearchDeligatePage({
    super.key,
    this.searchQuery = "",
  });

  final String searchQuery;

  @override
  State<SearchDeligatePage> createState() => _SearchDeligatePageState();
}

class _SearchDeligatePageState extends State<SearchDeligatePage> {
  late final TextEditingController _searchController;
  Timer? _debounce;
  double _ratingMin = 0.0;
  bool _filtersChipSelected = false;
  bool _fastDeliverySelected = false;
  late String _searchFieldHint;

  FoodController get _foodController =>
      Get.isRegistered<FoodController>() ? Get.find<FoodController>() : Get.put(FoodController());

  @override
  void initState() {
    super.initState();
    final initial = widget.searchQuery.trim();
    _searchFieldHint = initial.isNotEmpty ? initial : 'food';
    _searchController = TextEditingController(text: widget.searchQuery);
    _foodController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (initial.isNotEmpty) {
        _foodController.searchFoodProducts(initial, ratingMin: _ratingMin);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _commitSearch(String raw) {
    final q = raw.trim();
    setState(() {
      _searchFieldHint = q.isNotEmpty
          ? q
          : (widget.searchQuery.trim().isNotEmpty ? widget.searchQuery.trim() : 'food');
    });
    _foodController.searchFoodProducts(q, ratingMin: _ratingMin);
  }

  void _onSearchTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      _commitSearch(value);
    });
  }

  void _onClearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {
      _searchFieldHint =
          widget.searchQuery.trim().isNotEmpty ? widget.searchQuery.trim() : 'food';
    });
    _foodController.searchFoodProducts('');
  }

  void _toggleRatingFilter() {
    setState(() {
      _ratingMin = _ratingMin >= 4.0 ? 0.0 : 4.0;
    });
    _commitSearch(_searchController.text);
  }

  void _toggleFiltersChip() {
    setState(() {
      _filtersChipSelected = !_filtersChipSelected;
    });
  }

  void _toggleFastDelivery() {
    setState(() {
      _fastDeliverySelected = !_fastDeliverySelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonAppScreenBackground(
        scrollable: false,
        topColor: redColor,
        bottomColor: HexColor.fromHex('#FFFFFF'),
        topHeight: 190,
        topChild: SearchHeaderComponent(
          searchController: _searchController,
          searchFieldHint: _searchFieldHint,
          onBackTap: () => Navigator.of(context).pop(),
          onClearTap: _onClearSearch,
          onSearchSubmitted: _commitSearch,
          onSearchChanged: _onSearchTextChanged,
          onFilterTap: _toggleFiltersChip,
          onRatingTap: _toggleRatingFilter,
          onFastDeliveryTap: _toggleFastDelivery,
          filtersSelected: _filtersChipSelected,
          ratingFilterSelected: _ratingMin >= 4.0,
          fastDeliverySelected: _fastDeliverySelected,
        ),
        bottomChild: GetBuilder<FoodController>(
          builder: (c) {
            return SearchResultsListComponent(
              restaurants: c.foodSearchResults,
              resultCount: c.foodSearchResults.length,
              showViewCart: true,
              itemCount: 1,
              totalAmount: '₹210',
              onRestaurantTap: (item) => Get.toNamed(Routes.SEARCHDETAILSPAGE, arguments: item),
              onViewCartTap: () {},
              onSortTap: () {},
            );
          },
        ),
      ),
    );
  }
}
