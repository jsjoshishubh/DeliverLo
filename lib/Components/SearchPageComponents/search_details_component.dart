import 'dart:ui';

import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_filter_chip.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_details_tab_bar.dart';
import 'package:deliverylo/Controllers/Food_Controller.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class SearchDetailsComponent extends StatefulWidget {
  final Map<String, dynamic> restaurantDetails;
  final List<String> menuTabs;
  final List<Map<String, dynamic>> menuItems;
  final String? topImageUrl;
  final Color? topColor;
  final double? topHeight;

  /// When set with [subCategoryIds], loads menu via [FoodController.fetchFoodProductsBySubCategory] with `vendorId`.
  final String? vendorId;
  final List<String>? subCategoryIds;

  const SearchDetailsComponent({
    super.key,
    required this.restaurantDetails,
    required this.menuTabs,
    required this.menuItems,
    this.topImageUrl,
    this.topColor,
    this.topHeight,
    this.vendorId,
    this.subCategoryIds,
  });



  @override
  State<SearchDetailsComponent> createState() => _SearchDetailsComponentState();
}

class _SearchDetailsComponentState extends State<SearchDetailsComponent> {
  final FoodController _foodController =
      Get.isRegistered<FoodController>() ? Get.find<FoodController>() : Get.put(FoodController());

  bool _pureVeg = false;
  int _selectedTabIndex = 0;
  /// -1 = no chip; 0 = Bestseller (`hasOffers`); 1 = Top Rated (`ratingMin` + `sort`).
  int _selectedFilterChip = -1;
  final List<Map<String, dynamic>> _cartItems = [];
  final Set<String> _addedItemIds = <String>{};

  bool _useVendorMenuApi() {
    final v = widget.vendorId?.trim() ?? '';
    final ids = widget.subCategoryIds;
    if (v.isEmpty || ids == null || ids.isEmpty) return false;
    if (ids.length != widget.menuTabs.length) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (_useVendorMenuApi()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_useVendorMenuApi()) return;
        _fetchVendorMenuForCurrentTab();
      });
    }
  }

  void _refetchVendorMenuIfNeeded() {
    if (!_useVendorMenuApi()) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_useVendorMenuApi()) return;
      _fetchVendorMenuForCurrentTab();
    });
  }

  void _fetchVendorMenuForCurrentTab() {
    if (!_useVendorMenuApi()) return;
    final i = _selectedTabIndex.clamp(0, widget.subCategoryIds!.length - 1);
    final subId = widget.subCategoryIds![i];
    final diet = _pureVeg ? 'veg' : 'all';
    final offersOnly = _selectedFilterChip == 0;
    final ratingMin = _selectedFilterChip == 1 ? 4.0 : 0.0;
    final sort = _selectedFilterChip == 1 ? 'rating' : null;
    _foodController.fetchFoodProductsBySubCategory(
      subId,
      vendorId: widget.vendorId,
      diet: diet,
      offersOnly: offersOnly,
      ratingMin: ratingMin,
      sort: sort,
    );
  }

  void _onFilterChipTap(int chipIndex) {
    setState(() {
      _selectedFilterChip = _selectedFilterChip == chipIndex ? -1 : chipIndex;
    });
    _refetchVendorMenuIfNeeded();
  }

  void _addToCart(Map<String, dynamic> item) {
    final itemId = (item['id'] ?? '').toString().trim();
    if (itemId.isNotEmpty && _addedItemIds.contains(itemId)) return;
    setState(() {
      _cartItems.add(Map<String, dynamic>.from(item));
      if (itemId.isNotEmpty) _addedItemIds.add(itemId);
    });
  }

  int get _cartItemCount => _cartItems.length;

  int get _cartTotalAmount {
    return _cartItems.fold(0, (sum, item) {
      final tp = item['totalPrice'];
      if (tp is num) return sum + tp.round();
      return sum + parsePrice(item['price']?.toString());
    });
  }

  String get _cartTotalFormatted => '₹$_cartTotalAmount';

  void _openCheckout() {
    final list = _cartItems.map((e) => Map<String, dynamic>.from(e)).toList();
    Get.toNamed(
      Routes.CHECKOUT,
      arguments: <String, dynamic>{
        'cartItems': list,
        'restaurantDetails': Map<String, dynamic>.from(widget.restaurantDetails),
      },
    );
  }

  Widget _buildMenuTabBar() {
    if (!_useVendorMenuApi()) {
      return SearchDetailsTabBar(
        tabs: widget.menuTabs,
        selectedIndex: _selectedTabIndex,
        onTabChanged: (i) => setState(() => _selectedTabIndex = i),
        menuItemsByTab: List.generate(widget.menuTabs.length, (_) => widget.menuItems),
        onAddToCart: _addToCart,
        addedItemIds: _addedItemIds,
      );
    }
    return GetBuilder<FoodController>(
      builder: (c) {
        return SearchDetailsTabBar(
          tabs: widget.menuTabs,
          selectedIndex: _selectedTabIndex,
          onTabChanged: (i) {
            setState(() => _selectedTabIndex = i);
            _fetchVendorMenuForCurrentTab();
          },
          menuItemsByTab: List.generate(widget.menuTabs.length, (_) => widget.menuItems),
          onAddToCart: _addToCart,
          addedItemIds: _addedItemIds,
          vendorMenuMode: true,
          vendorMenuItems: c.vendorStoreMenuProducts,
          vendorMenuLoading: c.vendorStoreMenuProductsLoading,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.topImageUrl != null ? _buildWithBackground() : _buildContentOnly();
  }

  Widget _buildWithBackground() {
    return Stack(
      children: [
        CommonAppScreenBackground(
          scrollable: false,
          topColor: widget.topColor ?? HexColor.fromHex('#1A1A1A'),
          bottomColor: Colors.white,
          topHeight: widget.topHeight ?? 320,
          topImageUrl: widget.topImageUrl,
          topChild: _buildTopChild(),
          bottomChild: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, 0),
                  child: _buildContentSection(),
                ),
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: _buildMenuTabBar(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: _buildViewCartBar(),
          ),
        ),
      ],
    );
  }

  Widget _buildContentOnly() {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContentSection(),
              _buildMenuTabBar(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: _buildViewCartBar(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopChild() {
    final details = widget.restaurantDetails;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark gradient overlay: top slightly brighter, progressively darkening to bottom
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.15),
                Colors.black.withValues(alpha: 0.5),
                Colors.black.withValues(alpha: 0.9),
              ],
            ),
          ),
        ),
        // Nav + name + cuisine (fill space; metrics bar is separate at bottom)
        Positioned.fill(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white, size: 24),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        details['name'] as String,
                        textAlign: TextAlign.center,
                        style: commonTextStyle(
                          fontSize: 26,
                          fontColor: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        details['cuisine'] as String,
                        textAlign: TextAlign.center,
                        style: commonTextStyle(
                          fontSize: 14,
                          fontColor: Colors.white.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        // Metrics bar pinned to bottom of top card (per UI)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildMetricsBar(),
        ),
      ],
    );
  }

  Widget _buildMetricsBar() {
    final details = widget.restaurantDetails;
    final metricGreen = HexColor.fromHex('#22C55E');
    const barRadius = BorderRadius.only(
      topLeft: Radius.circular(0),
      topRight: Radius.circular(0),
    );
    // Glass effect: translucent background + backdrop blur so hero image shows through
    return ClipRRect(
      borderRadius: barRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: barRadius,
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              left: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              right: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${details['rating']}',
                      style: commonTextStyle(
                        fontSize: 17,
                        fontColor: metricGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star_border, color: metricGreen, size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  details['ratingCount'] as String,
                  style: commonTextStyle(
                    fontSize: 12,
                    fontColor: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.25)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  details['deliveryTime'] as String,
                  style: commonTextStyle(
                    fontSize: 17,
                    fontColor: metricGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Delivery Time',
                  style: commonTextStyle(
                    fontSize: 12,
                    fontColor: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.25)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  details['costForTwo'] as String,
                  style: commonTextStyle(
                    fontSize: 17,
                    fontColor: metricGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Cost for two',
                  style: commonTextStyle(
                    fontSize: 12,
                    fontColor: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 25, 0, 0),
            child: Row(
              children: [
                // Pure Veg: icon+label tappable; switch uses onToggle only (avoids double-toggle).
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex('#F9FAFB'),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: HexColor.fromHex('#E5E7EB'), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _pureVeg = !_pureVeg);
                          _refetchVendorMenuIfNeeded();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.eco, size: 18, color: HexColor.fromHex('#22C55E')),
                            const SizedBox(width: 4),
                            Text(
                              'Pure Veg',
                              style: commonTextStyle(
                                fontSize: 12,
                                fontColor: HexColor.fromHex('#374151'),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      FlutterSwitch(
                        toggleSize: 13.0,
                        borderRadius: 30.0,
                        padding: 2.0,
                        value: _pureVeg,
                        onToggle: (v) {
                          setState(() => _pureVeg = v);
                          _refetchVendorMenuIfNeeded();
                        },
                        width: 40,
                        height: 18,
                        activeColor: HexColor.fromHex('#22C55E'),
                        inactiveColor: HexColor.fromHex('#E5E7EB'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CommonFilterChip(
                  label: 'Bestseller',
                  icon: Icons.local_fire_department,
                  isActive: _selectedFilterChip == 0,
                  onTap: () => _onFilterChipTap(0),
                ),
                const SizedBox(width: 8),
                CommonFilterChip(
                  label: 'Top Rated',
                  isActive: _selectedFilterChip == 1,
                  onTap: () => _onFilterChipTap(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewCartBar() {
    return GestureDetector(
      onTap: _cartItemCount > 0 ? _openCheckout : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(210, 0, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _cartItemCount > 0 ? redColor : HexColor.fromHex('#9CA3AF'),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_cartItemCount  ITEM${_cartItemCount != 1 ? 'S' : ''}',
                  style: commonTextStyle(
                    fontSize: 11,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _cartItemCount > 0 ? _cartTotalFormatted : '₹0',
                  style: commonTextStyle(
                    fontSize: 12,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white.withValues(alpha: 0.6),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'VIEW CART',
                    style: commonTextStyle(
                      fontSize: 12,
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



