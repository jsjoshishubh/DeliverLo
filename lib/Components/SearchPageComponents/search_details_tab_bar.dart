import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_doted_divider.dart';
import 'package:deliverylo/Controllers/Food_Controller.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchDetailsTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<List<Map<String, dynamic>>> menuItemsByTab;
  final void Function(Map<String, dynamic> item) onAddToCart;

  /// When true, [vendorMenuItems] / [vendorMenuLoading] drive the list (vendor store menu API).
  final bool vendorMenuMode;
  final List<Map<String, dynamic>> vendorMenuItems;
  final bool vendorMenuLoading;

  const SearchDetailsTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.menuItemsByTab,
    required this.onAddToCart,
    this.vendorMenuMode = false,
    this.vendorMenuItems = const <Map<String, dynamic>>[],
    this.vendorMenuLoading = false,
  });

  
  @override
  State<SearchDetailsTabBar> createState() => _SearchDetailsTabBarState();
}

Widget _menuItemImage(String url, {required double width, required double height}) {
  final u = url.trim();
  if (u.isEmpty) {
    return Container(
      width: width,
      height: height,
      color: greyFontColor.shade50,
      child: Icon(Icons.fastfood, color: greyFontColor.shade400),
    );
  }
  final isNet = u.startsWith('http://') || u.startsWith('https://');
  if (isNet) {
    return Image.network(
      u,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: greyFontColor.shade50,
        child: Icon(Icons.fastfood, color: greyFontColor.shade400),
      ),
    );
  }
  return Image.asset(
    u,
    width: width,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      width: width,
      height: height,
      color: greyFontColor.shade50,
      child: Icon(Icons.fastfood, color: greyFontColor.shade400),
    ),
  );
}

class _SearchDetailsTabBarState extends State<SearchDetailsTabBar> with SingleTickerProviderStateMixin {
  late TabController _controller;
  static const double _dividerHeight = 1;
  static const double _indicatorHeight = 3;
  static const Color _dividerColor = Color(0xFFE5E7EB);
  static const Color _unselectedColor = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.selectedIndex.clamp(0, widget.tabs.length - 1),
    );
  }

  @override
  void didUpdateWidget(SearchDetailsTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != oldWidget.tabs.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedIndex.clamp(0, widget.tabs.length - 1),
      );
    } else if (_controller.index != widget.selectedIndex && widget.selectedIndex >= 0 && widget.selectedIndex < widget.tabs.length) {
      _controller.animateTo(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentTabItems {
    if (widget.vendorMenuMode) {
      return widget.vendorMenuItems;
    }
    if (widget.selectedIndex < 0 || widget.selectedIndex >= widget.menuItemsByTab.length) {
      return widget.menuItemsByTab.isNotEmpty ? widget.menuItemsByTab.first : [];
    }
    return widget.menuItemsByTab[widget.selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                left: 10,
                right: 10,
                bottom: 0,
                child: Container(
                  height: _dividerHeight,
                  color: _dividerColor,
                ),
              ),
              TabBar(
                controller: _controller,
                onTap: widget.onTabChanged,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: HexColor.fromHex('#E88A2E'),width: _indicatorHeight,),),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                dividerColor: Colors.transparent,
                labelColor: HexColor.fromHex('#E88A2E'),
                unselectedLabelColor: _unselectedColor,
                labelStyle: commonTextStyle(fontSize: 15,fontColor: HexColor.fromHex('#F48C25'),fontWeight: FontWeight.w700,),
                unselectedLabelStyle: commonTextStyle(fontSize: 14,fontColor: HexColor.fromHex('#64748B'),fontWeight: FontWeight.w500,),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                tabs: widget.tabs.map((label) => Tab(child: Text(label,overflow: TextOverflow.visible,),),).toList(),
              ),
            ],
          ),
        ),
        if (widget.vendorMenuMode && widget.vendorMenuLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: HexColor.fromHex('#F48C25')),
            ),
          )
        else if (widget.vendorMenuMode && _currentTabItems.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Text(
              'No dishes in this category yet.',
              style: commonTextStyle(
                fontSize: 14,
                fontColor: HexColor.fromHex('#64748B'),
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        else
          ..._currentTabItems.asMap().entries.map(
                (entry) => SearchDetailsMenuItemCard(
                  item: entry.value,
                  onAddTap: () => widget.onAddToCart(entry.value),
                  topPadding: entry.key == 0 ? 4 : null,
                  showBottomDivider: entry.key < _currentTabItems.length - 1,
                ),
              ),
      ],
    );
  }
}


class SearchDetailsMenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onAddTap;
  final double? topPadding;
  final bool showBottomDivider;
  const SearchDetailsMenuItemCard({
    super.key,
    required this.item,
    required this.onAddTap,
    this.topPadding,
    this.showBottomDivider = true,
  });



  getItemDetailsBottomSheet(context){
    return showCommonBottomSheet(
      context: context, 
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        child: SearchedItemDetailedBottomBarComponent(
          productId: (item['id'] ?? '').toString(),
          item: item,
          onAddToCart: (customizedItem) {
            Navigator.of(context).pop();
            onAddTap();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVeg = item['isVeg'] as bool? ?? true;
    final isBestseller = item['isBestseller'] as bool? ?? false;
    final titleDish = (item['dish'] ?? item['name'] ?? '').toString().trim();
    final descText = (item['description'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => getItemDetailsBottomSheet(context),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isVeg)
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: HexColor.fromHex('#16A34A'), width: 1.5),
                              ),
                              child: Icon(Icons.circle, size: 8, color: HexColor.fromHex('#16A34A')),
                            ),
                          if (isVeg && isBestseller) const SizedBox(width: 8),
                          if (isBestseller)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4.5),
                              decoration: BoxDecoration(
                                color: HexColor.fromHex('#F48C25').withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'BESTSELLER',
                                style: commonTextStyle(
                                  fontSize: 11,
                                  fontColor: HexColor.fromHex('#F48C25'),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        titleDish,
                        style: commonTextStyle(
                          fontSize: 18,
                          fontColor: HexColor.fromHex('#1E293B'),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['price'] is String ? item['price'] as String : '${item['price']}',
                        style: commonTextStyle(
                          fontSize: 14,
                          fontColor: HexColor.fromHex('#0F172A'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        descText,
                        style: commonTextStyle(
                          fontSize: 14,
                          fontColor: HexColor.fromHex('#64748B'),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: _menuItemImage(
                        item['imageUrl'] as String? ?? '',
                        width: 130,
                        height: 130,
                      ),
                    ),
                    Positioned(
                      right: 24,
                      bottom: -12,
                      child: GestureDetector(
                        onTap: onAddTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:Colors.grey.shade300.withValues(alpha: 1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'ADD',
                            style: commonTextStyle(
                              fontSize: 14,
                              fontColor: HexColor.fromHex('#F48C25'),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showBottomDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: DottedLinePainter(color: HexColor.fromHex('#E5E7EB')),
            ),
          ),
      ],
    );
  }
}



class SearchedItemDetailedBottomBarComponent extends StatefulWidget {
  /// Product id for [FoodController.getDetailScreenItemDetails].
  final String productId;
  /// Listing-row snapshot until the detail API returns.
  final Map<String, dynamic>? item;
  final void Function(Map<String, dynamic> customizedItem) onAddToCart;

  const SearchedItemDetailedBottomBarComponent({
    super.key,
    required this.productId,
    this.item,
    required this.onAddToCart,
  });

  @override
  State<SearchedItemDetailedBottomBarComponent> createState() => _SearchedItemDetailedBottomBarComponentState();
}

class _SearchedItemDetailedBottomBarComponentState extends State<SearchedItemDetailedBottomBarComponent> {
  late Map<String, dynamic> _item;

  @override
  void initState() {
    super.initState();
    _item = Map<String, dynamic>.from(widget.item ?? <String, dynamic>{});
    _rebuildVariantSelectionFromCurrentItem();
    _rebuildOptionSelectionsFromCurrentItem();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    final id = widget.productId.trim();
    if (id.isEmpty) return;
    final FoodController food = Get.isRegistered<FoodController>()
        ? Get.find<FoodController>()
        : Get.put(FoodController());
    final details = await food.getDetailScreenItemDetails(id);
    if (!mounted || details == null) return;
    setState(() {
      _item = details;
      _rebuildVariantSelectionFromCurrentItem();
      _rebuildOptionSelectionsFromCurrentItem();
    });
  }

  /// Selected variant `_id` when [variants] exist; otherwise null (use product price).
  String? _selectedVariantId;

  /// Option group `_id` → selected option item `_id`s.
  Map<String, Set<String>> _selectedOptionIdsByGroup = {};

  List<Map<String, dynamic>> get _parsedVariants {
    final raw = _item['variants'];
    if (raw is! List) return <Map<String, dynamic>>[];
    final list = <Map<String, dynamic>>[];
    for (final e in raw) {
      if (e is Map<String, dynamic>) {
        list.add(e);
      } else if (e is Map) {
        list.add(Map<String, dynamic>.from(e));
      }
    }
    return list.where((v) {
      final st = v['status']?.toString().toLowerCase().trim() ?? 'active';
      return st.isEmpty || st == 'active';
    }).toList();
  }

  bool _variantIsAvailable(Map<String, dynamic> v) {
    final inv = v['inventory'];
    if (inv is! Map) return true;
    final invMap = Map<String, dynamic>.from(inv);
    final avail = invMap['available'];
    if (avail is num) return avail.toInt() > 0;
    final stock = invMap['stock'];
    if (stock is num) return stock.toInt() > 0;
    return true;
  }

  double _variantUnitPrice(Map<String, dynamic> v) {
    final sp = v['salePrice'];
    if (sp is num) return sp.toDouble();
    final p = v['price'];
    if (p is num) return p.toDouble();
    return double.tryParse(sp?.toString() ?? '') ??
        double.tryParse(p?.toString() ?? '0') ??
        0;
  }

  Map<String, dynamic>? get _selectedVariantMap {
    final id = _selectedVariantId;
    if (id == null || id.isEmpty) return null;
    for (final v in _parsedVariants) {
      if (v['_id']?.toString() == id) return v;
    }
    return null;
  }

  void _rebuildVariantSelectionFromCurrentItem() {
    final vars = _parsedVariants;
    if (vars.isEmpty) {
      _selectedVariantId = null;
      return;
    }
    String? pick;
    for (final v in vars) {
      if (v['isDefault'] == true && _variantIsAvailable(v)) {
        final id = v['_id']?.toString();
        if (id != null && id.isNotEmpty) pick = id;
        break;
      }
    }
    if (pick == null) {
      for (final v in vars) {
        if (_variantIsAvailable(v)) {
          final id = v['_id']?.toString();
          if (id != null && id.isNotEmpty) {
            pick = id;
            break;
          }
        }
      }
    }
    pick ??= vars.first['_id']?.toString();
    _selectedVariantId = (pick != null && pick.isNotEmpty) ? pick : null;
  }

  double get _basePrice {
    final p = _item['price'];
    if (p is num) return p.toDouble();
    final priceString = p?.toString() ?? '0';
    final numeric = RegExp(r'[0-9]+(\.[0-9]+)?').firstMatch(priceString)?.group(0);
    return double.tryParse(numeric ?? '0') ?? 0;
  }

  String get _displayTitle {
    final d = _item['dish']?.toString().trim();
    if (d != null && d.isNotEmpty) return d;
    return (_item['name'] ?? 'Item').toString();
  }

  String get _ratingLabel {
    final r = _item['rating'];
    final v = r is num ? r.toDouble() : double.tryParse(r?.toString() ?? '') ?? 0;
    if (v == v.roundToDouble()) return '${v.toInt()}';
    return v.toStringAsFixed(1);
  }

  String get _traitsLabel {
    final labels = _item['displayLabels'];
    if (labels is List && labels.isNotEmpty) {
      return labels.map((e) => e.toString()).join(', ');
    }
    final cuisine = _item['cuisine']?.toString().trim();
    if (cuisine != null && cuisine.isNotEmpty) return cuisine;
    return 'Spicy';
  }

  String get _descriptionText {
    final d = _item['description']?.toString().trim();
    if (d != null && d.isNotEmpty) return d;
    return 'Authentic Basmati rice cooked with marinated chicken pieces, fresh herbs, and traditional spices. Served with Mirchi ka Salan and Raita.';
  }

  List<Map<String, dynamic>> get _parsedOptionGroups {
    final raw = _item['optionGroups'];
    if (raw is! List) return <Map<String, dynamic>>[];
    final list = <Map<String, dynamic>>[];
    for (final e in raw) {
      if (e is Map<String, dynamic>) {
        list.add(e);
      } else if (e is Map) {
        list.add(Map<String, dynamic>.from(e));
      }
    }
    list.sort((a, b) {
      final ia = _intFromDynamic(a['sortOrder'], 0);
      final ib = _intFromDynamic(b['sortOrder'], 0);
      return ia.compareTo(ib);
    });
    return list;
  }

  List<Map<String, dynamic>> _sortedOptionItems(dynamic raw) {
    if (raw is! List) return <Map<String, dynamic>>[];
    final list = <Map<String, dynamic>>[];
    for (final e in raw) {
      if (e is Map<String, dynamic>) {
        list.add(e);
      } else if (e is Map) {
        list.add(Map<String, dynamic>.from(e));
      }
    }
    list.sort((a, b) {
      final ia = _intFromDynamic(a['sortOrder'], 0);
      final ib = _intFromDynamic(b['sortOrder'], 0);
      return ia.compareTo(ib);
    });
    return list;
  }

  int _intFromDynamic(dynamic v, int fallback) {
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  double _priceModifierOf(Map<String, dynamic> optionItem) {
    final pm = optionItem['priceModifier'];
    if (pm is num) return pm.toDouble();
    return double.tryParse(pm?.toString() ?? '0') ?? 0;
  }

  void _rebuildOptionSelectionsFromCurrentItem() {
    final next = <String, Set<String>>{};
    for (final g in _parsedOptionGroups) {
      final gid = g['_id']?.toString() ?? '';
      if (gid.isEmpty) continue;
      final minSel = _intFromDynamic(g['minSelect'], 0);
      final items = _sortedOptionItems(g['items']);
      final selected = <String>{};
      for (final it in items) {
        if (it['isDefault'] == true) {
          final id = it['_id']?.toString() ?? '';
          if (id.isNotEmpty) selected.add(id);
        }
      }
      if (selected.isEmpty && minSel > 0) {
        for (var i = 0; i < minSel && i < items.length; i++) {
          final id = items[i]['_id']?.toString() ?? '';
          if (id.isNotEmpty) selected.add(id);
        }
      }
      next[gid] = selected;
    }
    _selectedOptionIdsByGroup = next;
  }

  void _onOptionItemTap(
    String groupId,
    String optionItemId,
    int minSelect,
    int maxSelect,
    List<Map<String, dynamic>> itemsInGroup,
  ) {
    final maxCap = maxSelect > 0 ? maxSelect : (itemsInGroup.isEmpty ? 1 : itemsInGroup.length);

    setState(() {
      final current = Set<String>.from(_selectedOptionIdsByGroup[groupId] ?? {});

      if (maxSelect == 1) {
        if (current.contains(optionItemId)) {
          if (minSelect == 0) current.remove(optionItemId);
        } else {
          current
            ..clear()
            ..add(optionItemId);
        }
      } else {
        if (current.contains(optionItemId)) {
          if (current.length > minSelect) current.remove(optionItemId);
        } else if (current.length < maxCap) {
          current.add(optionItemId);
        }
      }

      _selectedOptionIdsByGroup[groupId] = current;
    });
  }

  String _optionItemSubtitle(Map<String, dynamic> it) {
    final p = _priceModifierOf(it);
    if (p <= 0) return 'No extra charge';
    return '+ ${_formatPrice(p)}';
  }

  Widget _optionSelectControl(bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? HexColor.fromHex('#22C55E') : Colors.grey,
          ),
          color: selected ? HexColor.fromHex('#DCFCE7') : Colors.white,
        ),
        child: Icon(
          selected ? Icons.check : Icons.add,
          size: 18,
          color: selected ? HexColor.fromHex('#16A34A') : HexColor.fromHex('#9CA3AF'),
        ),
      ),
    );
  }

  List<Widget> _buildOptionGroupSection(Map<String, dynamic> g) {
    final gid = g['_id']?.toString() ?? '';
    if (gid.isEmpty) return <Widget>[];

    final items = _sortedOptionItems(g['items']);
    if (items.isEmpty) return <Widget>[];

    final name = g['name']?.toString().trim().isNotEmpty == true
        ? g['name'].toString().trim()
        : 'Options';
    final minSel = _intFromDynamic(g['minSelect'], 0);
    final maxSel = _intFromDynamic(g['maxSelect'], 0);

    final hintParts = <String>[];
    if (minSel > 0) hintParts.add('Choose at least $minSel');
    if (maxSel == 1) {
      hintParts.add('Select one');
    } else if (maxSel > 1) {
      hintParts.add('Up to $maxSel');
    }
    final hint = hintParts.join(' · ');

    final children = <Widget>[
      Text(
        name,
        style: commonTextStyle(
          fontColor: HexColor.fromHex('#111827'),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      if (hint.isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(
          hint,
          style: commonTextStyle(
            fontColor: HexColor.fromHex('#6B7280'),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
      const SizedBox(height: 10),
    ];

    for (final it in items) {
      final oid = it['_id']?.toString() ?? '';
      if (oid.isEmpty) continue;
      final isOn = _selectedOptionIdsByGroup[gid]?.contains(oid) ?? false;
      children.add(
        buildAddOnCard(
          title: it['name']?.toString() ?? 'Option',
          subtitle: _optionItemSubtitle(it),
          icon: Icons.tune_rounded,
          iconBackground: HexColor.fromHex('#DBEAFE'),
          iconColor: HexColor.fromHex('#2563EB'),
          trailing: _optionSelectControl(
            isOn,
            () => _onOptionItemTap(gid, oid, minSel, maxSel, items),
          ),
        ),
      );
      children.add(const SizedBox(height: 10));
    }

    children.add(const SizedBox(height: 4));
    return children;
  }

  double get _optionsPrice {
    var total = 0.0;
    for (final g in _parsedOptionGroups) {
      final gid = g['_id']?.toString() ?? '';
      if (gid.isEmpty) continue;
      final selected = _selectedOptionIdsByGroup[gid];
      if (selected == null || selected.isEmpty) continue;
      for (final it in _sortedOptionItems(g['items'])) {
        final id = it['_id']?.toString() ?? '';
        if (id.isNotEmpty && selected.contains(id)) {
          total += _priceModifierOf(it);
        }
      }
    }
    return total;
  }

  bool get _optionRulesSatisfied {
    for (final g in _parsedOptionGroups) {
      final gid = g['_id']?.toString() ?? '';
      if (gid.isEmpty) continue;
      final minSel = _intFromDynamic(g['minSelect'], 0);
      final n = _selectedOptionIdsByGroup[gid]?.length ?? 0;
      if (n < minSel) return false;
    }
    return true;
  }

  bool get _variantRulesSatisfied {
    if (_parsedVariants.isEmpty) return true;
    final m = _selectedVariantMap;
    if (m == null) return false;
    return _variantIsAvailable(m);
  }

  bool get _canAddToCart {
    if (!_variantRulesSatisfied) return false;
    if (_parsedOptionGroups.isNotEmpty && !_optionRulesSatisfied) return false;
    return true;
  }

  /// Product line price: selected variant when present, else listing `price`.
  double get _lineBasePrice {
    final sv = _selectedVariantMap;
    if (sv != null) return _variantUnitPrice(sv);
    return _basePrice;
  }

  double get _totalPrice {
    return _lineBasePrice + _optionsPrice;
  }

  String _variantChipLabel(Map<String, dynamic> v) {
    final dn = v['displayName']?.toString().trim();
    final label = (dn != null && dn.isNotEmpty)
        ? dn
        : (v['sku']?.toString().trim().isNotEmpty == true
            ? v['sku'].toString().trim()
            : 'Size');
    return '$label\n${_formatPrice(_variantUnitPrice(v))}';
  }

  List<Widget> _buildVariantPortionSection() {
    final vars = _parsedVariants;
    if (vars.isEmpty) return <Widget>[];

    final activeColor = HexColor.fromHex('#FF5200');
    final selectedId = _selectedVariantId ?? '';

    return <Widget>[
      Text(
        'Portion Size',
        style: commonTextStyle(
          fontColor: HexColor.fromHex('#111827'),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < vars.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: Opacity(
                opacity: _variantIsAvailable(vars[i]) ? 1 : 0.45,
                child: IgnorePointer(
                  ignoring: !_variantIsAvailable(vars[i]),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildPortionChip(
                        label: _variantChipLabel(vars[i]),
                        value: vars[i]['_id']?.toString() ?? '',
                        onTap: (dynamic c) {
                          final vid = c.toString();
                          setState(() => _selectedVariantId = vid);
                        },
                        activeColor: activeColor,
                        selectedPortion: selectedId,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      const SizedBox(height: 14),
    ];
  }

  String _formatPrice(double value) {
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final itemName = _displayTitle;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 15),
          height: 8,
          width: 60,
          decoration: BoxDecoration(
            color: HexColor.fromHex('#D1D5DB'),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Text(itemName, style: commonTextStyle(fontColor: HexColor.fromHex('#111827'),fontSize: 24,fontWeight: FontWeight.w700,),),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.star_border,color: HexColor.fromHex('#16A34A'),size: 18,),
                const SizedBox(width: 5),
                Text(_ratingLabel,style: commonTextStyle(fontColor: HexColor.fromHex('#16A34A'),fontSize: 14,fontWeight: FontWeight.w700,),),
              ],
            ),
            const SizedBox(width: 10),
            Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey.shade400,),
            ),
            const SizedBox(width: 10),
            Text('1.2k Reviews',style: commonTextStyle(fontColor: HexColor.fromHex('#A6A6A6'),fontSize: 14,fontWeight: FontWeight.w500,),
            ),
            const SizedBox(width: 10),
            Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey.shade400,),
            ),
            const SizedBox(width: 10),
            Text(_traitsLabel,style: commonTextStyle(fontColor: HexColor.fromHex('#F48C25'),fontSize: 14,fontWeight: FontWeight.w500,),),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 10),
          child: Text(
            _descriptionText,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontColor: HexColor.fromHex('#4B5563'),),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildVariantPortionSection(),
                    if (_parsedOptionGroups.isNotEmpty) ...[
                    
                      const SizedBox(height: 10),
                      for (final g in _parsedOptionGroups) ..._buildOptionGroupSection(g),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left:20,right: 20,bottom: 35),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: commonTextStyle(
                      fontColor: HexColor.fromHex('#6B7280'),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatPrice(_totalPrice),
                    style: commonTextStyle(
                      fontColor: HexColor.fromHex('#111827'),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (!_canAddToCart) return;
                  final selections = <String, List<String>>{};
                  _selectedOptionIdsByGroup.forEach((k, v) {
                    selections[k] = v.toList();
                  });
                  final customizedItem = Map<String, dynamic>.from(_item)
                    ..['selectedVariantId'] = _selectedVariantId
                    ..['selectedOptionIdsByGroup'] = selections
                    ..['totalPrice'] = _totalPrice;
                  widget.onAddToCart(customizedItem);
                },
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex('#E88A2D').withValues(
                      alpha: _canAddToCart ? 1 : 0.45,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


  
