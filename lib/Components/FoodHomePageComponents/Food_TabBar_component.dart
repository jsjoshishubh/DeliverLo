import 'dart:developer';

import 'package:deliverylo/Data/static_food_data.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class FoodTabBarComponent extends StatefulWidget {
  final List? tabss;

  const FoodTabBarComponent({super.key, this.tabss});

  @override
  State<FoodTabBarComponent> createState() => _FoodTabBarComponentState();
}

class _FoodTabBarComponentState extends State<FoodTabBarComponent> {
  List newTabs = [];
  List tabs = [
    {'tab_title': 'Min Rs 100 OFF', 'tab_type': '0'},
    {'tab_title': 'Fast Delivery', 'tab_type': '1'},
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      newTabs = widget.tabss ?? tabs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: newTabs.length,
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
              labelColor: HexColor.fromHex('#BD0D0E'),
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
              tabs: newTabs
                  .map<Widget>(
                    (e) => Tab(
                      text: e['tab_title'] != null ? e['tab_title'] : e['tab_type'].toString(),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: newTabs
                  .map(
                    (e) => FoodTabList(
                      tabType: e['tab_type'] != null ? e['tab_type'].toString() : e['tab_title'].toString(),
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

  const FoodTabList({super.key, this.tabType});

  @override
  State<FoodTabList> createState() => _FoodTabListState();
}

class _FoodTabListState extends State<FoodTabList> {
  bool isLoading = false;
  List<FoodItemModel> tabsDetails = <FoodItemModel>[];

  @override
  void initState() {
    super.initState();
    getFoodByTabType();
  }

  getFoodByTabType() async {
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
                CircularProgressIndicator(color: HexColor.fromHex('#BD0D0E'),),
                const SizedBox(height: 12),
                Text('Loading...', style: TextStyle(color: HexColor.fromHex('#BD0D0E'), fontSize: 14)),
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
                return FoodItemCard(item: item);
              },
            ),
          );
  }
}

class FoodItemCard extends StatelessWidget {
  const FoodItemCard({super.key, required this.item});

  final FoodItemModel item;

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: 180,
                  height: 140,
                  errorBuilder: (_, __, ___) => Container(
                    width: 180,
                    height: 130,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.restaurant, color: Colors.grey.shade600),
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
                    Icon(Icons.star, size: 14, color: HexColor.fromHex('#15803D'),),
                    const SizedBox(width: 4),
                    Text(
                      '${item.rating}',
                      style: commonTextStyle(
                        fontSize: 12,
                        fontColor: HexColor.fromHex('#15803D'),
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
