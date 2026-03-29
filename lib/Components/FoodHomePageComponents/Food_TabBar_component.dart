import 'dart:developer';

import 'package:deliverylo/Controllers/Food_Controller.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:deliverylo/Models/grocery_detail_page_args.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodTabBarComponent extends StatefulWidget {
  final List<Map<String, dynamic>>? tabss;
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
  final FoodController _foodController = Get.isRegistered<FoodController>() ? Get.find<FoodController>() : Get.put(FoodController());

  static final List<Map<String, dynamic>> _defaultTabs = [
    {'tab_title': 'Highly Ordered', 'tab_type': '0', 'api_type': 'highlight'},
    {'tab_title': 'Fast Delivery', 'tab_type': '1', 'api_type': 'fast_delivery'},
  ];

  Color get _accent => widget.accentColor ?? HexColor.fromHex('#BD0D0E');

  @override
  void initState() {
    super.initState();
    _tabs = List<Map<String, dynamic>>.from(widget.tabss ?? _defaultTabs);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prefetchSelectedTab(0);
    });
  }

  @override
  void didUpdateWidget(covariant FoodTabBarComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabss != widget.tabss) {
      setState(() {
        _tabs = List<Map<String, dynamic>>.from(widget.tabss ?? _defaultTabs);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _prefetchSelectedTab(0);
      });
    }
  }

  void _prefetchSelectedTab(int index) {
    if (_tabs.isEmpty || index < 0 || index >= _tabs.length) return;
    final apiType = (_tabs[index]['api_type'] ?? '').toString().trim();
    if (apiType.isEmpty) return;
    _foodController.getFoodDataByTab(apiType);
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
            margin: const EdgeInsets.only(right: 20, left: 20,top: 8,bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              onTap: _prefetchSelectedTab,
              isScrollable: false,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(26),),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
              labelColor: _accent,
              unselectedLabelColor: greyFontColor,
              labelStyle: commonTextStyle(fontColor: HexColor.fromHex('#3D4152'),fontSize: 12,fontWeight: FontWeight.w800,),
              unselectedLabelStyle: commonTextStyle(fontColor:  HexColor.fromHex('#3D4152'),fontSize: 12,fontWeight: FontWeight.w600,),
              tabs: _tabs.map<Widget>((e) => Tab(text: e['tab_title'] != null ? e['tab_title'] as String : e['tab_type'].toString(),),).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: _tabs.map((e) => FoodTabList(
                  tabType: e['tab_type'] != null ? e['tab_type'].toString() : e['tab_title']?.toString(),
                  apiType: (e['api_type'] ?? '').toString(),
                  initialItems: _parseStaticItems(e['items']),
                  accentColor: greenColor,
                  showFavoriteOnCard: widget.showFavoriteOnCards,
                  itemCardErrorIcon: widget.itemCardErrorIcon,
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodTabList extends StatefulWidget {
  final String? tabType;
  final String? apiType;
  final List<FoodItemModel>? initialItems;
  final Color accentColor;
  final bool showFavoriteOnCard;
  final IconData itemCardErrorIcon;

  const FoodTabList({super.key, this.tabType, this.apiType, this.initialItems, this.accentColor = const Color(0xFFBD0D0E), this.showFavoriteOnCard = true, this.itemCardErrorIcon = Icons.restaurant,});

  @override
  State<FoodTabList> createState() => _FoodTabListState();
}

class _FoodTabListState extends State<FoodTabList> {
  final FoodController _foodController = Get.isRegistered<FoodController>() ? Get.find<FoodController>() : Get.put(FoodController());
  bool get _hasProvidedItems => widget.initialItems != null;
  String get _apiType => (widget.apiType ?? '').trim();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant FoodTabList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final didApiTypeChange = oldWidget.apiType != widget.apiType;
    final didPresetChange = oldWidget.initialItems != widget.initialItems;
    if (didApiTypeChange || didPresetChange) {
      _loadData(forceRefresh: didApiTypeChange);
    }
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    if (_hasProvidedItems) return;
    if (_apiType.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _foodController.getFoodDataByTab(_apiType, forceRefresh: forceRefresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasProvidedItems) {
      final tabsDetails = List<FoodItemModel>.from(widget.initialItems ?? const <FoodItemModel>[]);
      if (tabsDetails.isEmpty) {
        return Center(
          child: Text(
            'No items found',
            style: TextStyle(color: widget.accentColor, fontSize: 14),
          ),
        );
      }
      return SizedBox(
        height: 260,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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

    return GetBuilder<FoodController>(
      init: _foodController,
      builder: (controller) {
        final isLoading = controller.isTabLoading(_apiType);
        final tabsDetails = controller.foodItemsForTabType(_apiType);
        if (isLoading) {
          return Center(
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
          );
        }
        if (tabsDetails.isEmpty) {
          return Center(
            child: Text(
              'No items found',
              style: TextStyle(color: widget.accentColor, fontSize: 14),
            ),
          );
        }
        return SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
      },
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
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.SEARCHDETAILSPAGE),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
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
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.60),borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),topRight: Radius.circular(6)),),
                  child: Text(item.discount.capitalizeFirst.toString(),style: commonTextStyle(fontSize: 12,fontColor: Colors.white,fontWeight: FontWeight.w900,),),
                ),
              ),
              if (showFavorite)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.60),borderRadius: BorderRadius.circular(15),),
                    child: Icon(Icons.favorite_border,color: Colors.white,size: 16,),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:8,top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: commonTextStyle(fontSize: 14,fontColor: blackFontColor,fontWeight: FontWeight.w700,),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: starColor),
                    const SizedBox(width: 4),
                    Text('${item.rating}',style: commonTextStyle(fontSize: 12,fontColor: starColor,fontWeight: FontWeight.w700,),),
                    const SizedBox(width: 8),
                    Text(item.deliveryTime,style: commonTextStyle(fontSize: 12,fontColor: HexColor.fromHex('#686B78'),fontWeight: FontWeight.w400,),),
                  ],
                ),
                const SizedBox(height: 5),
                Text(item.category,style: commonTextStyle(fontSize: 11,fontColor: HexColor.fromHex('#686B78'),fontWeight: FontWeight.w600,),),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}
