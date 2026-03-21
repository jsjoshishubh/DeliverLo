import 'dart:developer';

import 'package:deliverylo/Data/static_food_data.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// Tab entry shape:
/// - Food (default): `{ 'tab_title': String, 'tab_type': String }` — loads from [fetchFoodDataByTab].
/// - Custom list: `{ 'tab_title': String, 'items': List<FoodItemModel> }` — shows items without API.
class FoodTabBarComponent extends StatefulWidget {
  final List<Map<String, dynamic>>? tabss;
  /// Selected tab label color (and loading accent). Defaults to food red.
  final Color? accentColor;
  final bool showFavoriteOnCards;
  final IconData itemCardErrorIcon;

  const FoodTabBarComponent({
    super.key,
    this.tabss,
    this.accentColor,
    this.showFavoriteOnCards = true,
    this.itemCardErrorIcon = Icons.restaurant,
  });

  @override
  State<FoodTabBarComponent> createState() => _FoodTabBarComponentState();
}

class _FoodTabBarComponentState extends State<FoodTabBarComponent> {
  late List<Map<String, dynamic>> _tabs;

  static final List<Map<String, dynamic>> _defaultTabs = [
    {'tab_title': 'Min Rs 100 OFF', 'tab_type': '0'},
    {'tab_title': 'Fast Delivery', 'tab_type': '1'},
  ];

  Color get _accent => widget.accentColor ?? HexColor.fromHex('#BD0D0E');

  @override
  void initState() {
    super.initState();
    _tabs = List<Map<String, dynamic>>.from(widget.tabss ?? _defaultTabs);
  }

  @override
  void didUpdateWidget(covariant FoodTabBarComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabss != widget.tabss) {
      setState(() {
        _tabs = List<Map<String, dynamic>>.from(widget.tabss ?? _defaultTabs);
      });
    }
  }

  List<FoodItemModel>? _parseStaticItems(dynamic raw) {
    if (raw == null) return null;
    if (raw is List<FoodItemModel>) return raw;
    if (raw is List) {
      final out = <FoodItemModel>[];
      for (final e in raw) {
        if (e is FoodItemModel) out.add(e);
      }
      return out.isEmpty ? null : out;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: HexColor.fromHex('#F3F3F3'),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              isScrollable: false,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
              labelColor: _accent,
              unselectedLabelColor: HexColor.fromHex('#3D4152'),
              labelStyle: commonTextStyle(
                fontColor: HexColor.fromHex('#3D4152'),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelStyle: commonTextStyle(
                fontColor:  HexColor.fromHex('#3D4152'),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              tabs: _tabs
                  .map<Widget>(
                    (e) => Tab(
                      text: e['tab_title'] != null
                          ? e['tab_title'] as String
                          : e['tab_type'].toString(),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: _tabs
                  .map(
                    (e) => FoodTabList(
                      tabType: e['tab_type'] != null
                          ? e['tab_type'].toString()
                          : e['tab_title']?.toString(),
                      initialItems: _parseStaticItems(e['items']),
                      accentColor: _accent,
                      showFavoriteOnCard: widget.showFavoriteOnCards,
                      itemCardErrorIcon: widget.itemCardErrorIcon,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodTabList extends StatefulWidget {
  final String? tabType;
  /// When set, these items are shown immediately (no fetch by [tabType]).
  final List<FoodItemModel>? initialItems;
  final Color accentColor;
  final bool showFavoriteOnCard;
  final IconData itemCardErrorIcon;

  const FoodTabList({
    super.key,
    this.tabType,
    this.initialItems,
    this.accentColor = const Color(0xFFBD0D0E),
    this.showFavoriteOnCard = true,
    this.itemCardErrorIcon = Icons.restaurant,
  });

  @override
  State<FoodTabList> createState() => _FoodTabListState();
}

class _FoodTabListState extends State<FoodTabList> {
  bool isLoading = false;
  List<FoodItemModel> tabsDetails = <FoodItemModel>[];

  @override
  void initState() {
    super.initState();
    final preset = widget.initialItems;
    if (preset != null && preset.isNotEmpty) {
      tabsDetails = List<FoodItemModel>.from(preset);
    } else {
      getFoodByTabType();
    }
  }

  @override
  void didUpdateWidget(covariant FoodTabList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final preset = widget.initialItems;
    if (preset != null && preset.isNotEmpty) {
      if (oldWidget.initialItems != widget.initialItems) {
        setState(() {
          tabsDetails = List<FoodItemModel>.from(preset);
          isLoading = false;
        });
      }
    }
  }

  Future<void> getFoodByTabType() async {
    if (widget.initialItems != null && widget.initialItems!.isNotEmpty) return;
    try {
      setState(() {
        isLoading = true;
      });
      final tabIndex = int.tryParse(widget.tabType ?? '0') ?? 0;
      final data = await fetchFoodDataByTab(tabIndex);
      if (mounted) {
        setState(() {
          tabsDetails = data;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: widget.accentColor),
                const SizedBox(height: 12),
                Text(
                  'Loading...',
                  style: TextStyle(color: widget.accentColor, fontSize: 14),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical:4),
              itemCount: tabsDetails.length,
              itemBuilder: (context, index) {
                final item = tabsDetails[index];
                return FoodItemCard(
                  item: item,
                  accentColor: widget.accentColor,
                  showFavorite: widget.showFavoriteOnCard,
                  errorIcon: widget.itemCardErrorIcon,
                );
              },
            ),
          );
  }
}

class FoodItemCard extends StatelessWidget {
  const FoodItemCard({
    super.key,
    required this.item,
    this.accentColor,
    this.showFavorite = true,
    this.errorIcon = Icons.restaurant,
  });

  final FoodItemModel item;
  final Color? accentColor;
  final bool showFavorite;
  final IconData errorIcon;

  @override
  Widget build(BuildContext context) {
    final starColor = accentColor ?? HexColor.fromHex('#15803D');
    final isNetworkImage = item.imageUrl.startsWith('http');
    log('item: ${item.imageUrl}');
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: isNetworkImage
                    ? Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        width: 180,
                        height: 140,
                        errorBuilder: (_, _, _) => Container(
                          width: 180,
                          height: 130,
                          color: Colors.grey.shade300,
                          child: Icon(errorIcon, color: Colors.grey.shade600),
                        ),
                      )
                    : Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        width: 180,
                        height: 140,
                        errorBuilder: (_, _, _) => Container(
                          width: 180,
                          height: 130,
                          color: Colors.grey.shade300,
                          child: Icon(errorIcon, color: Colors.grey.shade600),
                        ),
                      ),
              ),
              Positioned(
                left: 1,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex('#FFFFFF').withOpacity(0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.discount,
                    style: commonTextStyle(
                      fontSize: 12,
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              if (showFavorite)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: HexColor.fromHex('#FFFFFF').withOpacity(0.35),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: commonTextStyle(
                    fontSize: 16,
                    fontColor: HexColor.fromHex('#3D4152'),
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: starColor),
                    const SizedBox(width: 4),
                    Text(
                      '${item.rating}',
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: starColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.deliveryTime,
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: HexColor.fromHex('#686B78'),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.category,
                  style: commonTextStyle(
                    fontSize: 12,
                    fontColor: HexColor.fromHex('#686B78'),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
