import 'dart:ui';

import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_filter_chip.dart';
import 'package:deliverylo/Components/SearchPageComponents/search_details_tab_bar.dart';
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

  const SearchDetailsComponent({
    super.key,
    required this.restaurantDetails,
    required this.menuTabs,
    required this.menuItems,
    this.topImageUrl,
    this.topColor,
    this.topHeight,
  });



  @override
  State<SearchDetailsComponent> createState() => _SearchDetailsComponentState();
}

class _SearchDetailsComponentState extends State<SearchDetailsComponent> {
  bool _pureVeg = false;
  int _selectedTabIndex = 0;
  int _selectedFilterIndex = 0;
  final List<Map<String, dynamic>> _cartItems = [];

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.add(Map<String, dynamic>.from(item));
    });
  }

  int get _cartItemCount => _cartItems.length;
  int get _cartTotalAmount => _cartItems.fold(0, (sum, item) => sum + parsePrice(item['price'] as String?));
  String get _cartTotalFormatted => '₹$_cartTotalAmount';

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
                  offset: const Offset(0, -24),
                  child: _buildContentSection(),
                ),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: SearchDetailsTabBar(
                    tabs: widget.menuTabs,
                    selectedIndex: _selectedTabIndex,
                    onTabChanged: (i) => setState(() => _selectedTabIndex = i),
                    menuItemsByTab: List.generate(
                      widget.menuTabs.length,
                      (_) => widget.menuItems,
                    ),
                    onAddToCart: _addToCart,
                  ),
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
              SearchDetailsTabBar(
                tabs: widget.menuTabs,
                selectedIndex: _selectedTabIndex,
                onTabChanged: (i) => setState(() => _selectedTabIndex = i),
                menuItemsByTab: List.generate(
                  widget.menuTabs.length,
                  (_) => widget.menuItems,
                ),
                onAddToCart: _addToCart,
              ),
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
            padding: const EdgeInsets.fromLTRB(22, 45, 0, 0),
            child: Row(
              children: [
                // Pure Veg: entire chip clickable (icon + text + toggle)
                GestureDetector(
                  onTap: () => setState(() => _pureVeg = !_pureVeg),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical:5),
                    decoration: BoxDecoration(
                      color: HexColor.fromHex('#F9FAFB'),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: HexColor.fromHex('#E5E7EB'), width: 1),
                    ),
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
                        const SizedBox(width: 10),
                        FlutterSwitch(
                          toggleSize:13.0,
                          borderRadius: 30.0,
                          padding: 2.0,
                          value: _pureVeg,
                          onToggle: (v) => setState(() => _pureVeg = v),
                          width: 40,
                          height: 18,
                          activeColor: HexColor.fromHex('#22C55E'),
                          inactiveColor: HexColor.fromHex('#E5E7EB'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CommonFilterChip(
                  label: 'Bestseller',
                  icon: Icons.local_fire_department,
                  isActive: _selectedFilterIndex == 0,
                  onTap: () => setState(() => _selectedFilterIndex = 0),
                ),
                const SizedBox(width: 8),
                CommonFilterChip(
                  label: 'Top Rated',
                  isActive: _selectedFilterIndex == 1,
                  onTap: () => setState(() => _selectedFilterIndex = 1),
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
      onTap: _cartItemCount > 0 ? () {
        Get.toNamed(Routes.CHECKOUT);
      } : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(190, 0, 14, 30),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _cartItemCount > 0 ? HexColor.fromHex('#E88A2D') : HexColor.fromHex('#9CA3AF'),
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
                    fontSize: 12,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _cartItemCount > 0 ? _cartTotalFormatted : '₹0',
                  style: commonTextStyle(
                    fontSize: 14,
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
                      fontSize: 14,
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 19,
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



