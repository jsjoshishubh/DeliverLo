import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_doted_divider.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SearchDetailsTabBar extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<List<Map<String, dynamic>>> menuItemsByTab;
  final void Function(Map<String, dynamic> item) onAddToCart;

  const SearchDetailsTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.menuItemsByTab,
    required this.onAddToCart,
  });

  
  @override
  State<SearchDetailsTabBar> createState() => _SearchDetailsTabBarState();
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
                        item['name'] as String,
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
                        item['price'] as String,
                        style: commonTextStyle(
                          fontSize: 14,
                          fontColor: HexColor.fromHex('#0F172A'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['description'] as String,
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
                      child: Image.asset(
                        item['imageUrl'] as String,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 120,
                          height: 120,
                          color: greyFontColor.shade50,
                          child: Icon(Icons.fastfood, color: greyFontColor.shade50),
                        ),
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
  final Map<String, dynamic>? item;
  final void Function(Map<String, dynamic> customizedItem) onAddToCart;

  const SearchedItemDetailedBottomBarComponent({
    super.key,
    this.item,
    required this.onAddToCart,
  });

  @override
  State<SearchedItemDetailedBottomBarComponent> createState() => _SearchedItemDetailedBottomBarComponentState();
}

class _SearchedItemDetailedBottomBarComponentState extends State<SearchedItemDetailedBottomBarComponent> {
  Map<String, dynamic> get _item => widget.item ?? <String, dynamic>{};
  bool _extraSpicy = false;
  bool _extraRaita = true;
  bool _addBoiledEgg = false;
  String _selectedPortion = 'single'; // single, double, family

  double get _basePrice {
    final priceString = _item['price'] as String? ?? '0';
    final numeric = RegExp(r'[0-9]+(\.[0-9]+)?').firstMatch(priceString)?.group(0);
    return double.tryParse(numeric ?? '0') ?? 0;
  }

  double get _portionMultiplier {
    switch (_selectedPortion) {
      case 'double':
        return 2;
      case 'family':
        return 4;
      case 'single':
      default:
        return 1;
    }
  }

  double get _addOnsPrice {
    double total = 0;
    if (_extraRaita) total += 20;
    if (_addBoiledEgg) total += 15;
    return total;
  }

  double get _totalPrice {
    return (_basePrice * _portionMultiplier) + _addOnsPrice;
  }

  String _formatPrice(double value) {
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final itemName = _item['name'] as String? ?? 'Item';

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
                Text('4.8',style: commonTextStyle(fontColor: HexColor.fromHex('#16A34A'),fontSize: 14,fontWeight: FontWeight.w700,),),
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
            Text('Spicy',style: commonTextStyle(fontColor: HexColor.fromHex('#F48C25'),fontSize: 14,fontWeight: FontWeight.w500,),),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 10),
          child: Text(
            'Authentic Basmati rice cooked with marinated chicken pieces, fresh herbs, and traditional spices. Served with Mirchi ka Salan and Raita.',
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
                    Text('Customize Order',style: commonTextStyle(fontColor: HexColor.fromHex('#111827'),fontSize: 18,fontWeight: FontWeight.w700,),),
                    const SizedBox(height: 10),
                    buildAddOnCard(
                      title: 'Extra Spicy',
                      subtitle: 'Add more green chillies',
                      icon: Icons.local_fire_department_outlined,
                      iconBackground: HexColor.fromHex('#FEE2E2'),
                      iconColor: HexColor.fromHex('#DC2626'),
                      trailing: FlutterSwitch(
                        height: 22,
                        width: 50,
                        toggleSize: 20,
                        padding:2,
                        value: _extraSpicy,
                        inactiveColor: HexColor.fromHex('#E5E7EB'),
                        activeColor: HexColor.fromHex('#F48C25'),
                        onToggle: (bool val) { 
                           setState(() {
                            _extraSpicy = val;
                          });
                         },
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildAddOnCard(
                      title: 'Add Extra Raita',
                      subtitle: '+ ₹20',
                      icon: Icons.science_rounded,
                      iconBackground: HexColor.fromHex('#DBEAFE'),
                      iconColor: HexColor.fromHex('#2563EB'),
                      trailing: FlutterSwitch(
                        value: _extraRaita,
                        height: 22,
                        width: 50,
                        toggleSize: 20,
                        padding:2,
                        inactiveColor: HexColor.fromHex('#E5E7EB'),
                        activeColor: HexColor.fromHex('#F48C25'),
                         onToggle: (bool val) { 
                          setState(() {
                            _extraRaita = val;
                          });
                         },
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildAddOnCard(
                      title: 'Add Boiled Egg',
                      subtitle: '+ ₹15',
                      icon: Icons.science_rounded,
                      iconBackground: HexColor.fromHex('#DBEAFE'),
                      iconColor: HexColor.fromHex('#2563EB'),
                      trailing: GestureDetector(
                        onTap: () {
                          setState(() {
                            _addBoiledEgg = !_addBoiledEgg;
                          });
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _addBoiledEgg ? HexColor.fromHex('#22C55E') : Colors.grey), color: _addBoiledEgg ? HexColor.fromHex('#DCFCE7') : Colors.white,),
                          child: Icon(_addBoiledEgg ? Icons.check : Icons.add,size: 18, color: _addBoiledEgg ? HexColor.fromHex('#16A34A') : HexColor.fromHex('#9CA3AF'),),),
                        ),
                    ),
                    const SizedBox(height: 14),
                    Text('Portion Size',style: commonTextStyle(fontColor: HexColor.fromHex('#111827'),fontSize: 18,fontWeight: FontWeight.w700,),),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: buildPortionChip(
                            label: 'Single (1)',
                            value: 'single', 
                            onTap: (c){
                              setState(() {
                                _selectedPortion = c;
                              });
                            }, activeColor: HexColor.fromHex('#FF5200'), 
                            selectedPortion: _selectedPortion,
                            
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildPortionChip(
                            label: 'Double (2)',
                            value: 'double',
                            selectedPortion: _selectedPortion,
                            onTap: (c){
                              setState(() {
                                _selectedPortion = c;
                              });
                            }, 
                            activeColor: HexColor.fromHex('#FF5200'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildPortionChip(
                            label: 'Family (4)',
                            value: 'family',
                            selectedPortion: _selectedPortion,
                            onTap: (c){
                              setState(() {
                                _selectedPortion = c;
                              });
                            }, 
                            activeColor: HexColor.fromHex('#FF5200'),
                          ),
                        ),
                      ],
                    ),
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
                onTap: (){
                  final customizedItem = Map<String, dynamic>.from(_item)
                      ..['extraSpicy'] = _extraSpicy
                      ..['extraRaita'] = _extraRaita
                      ..['boiledEgg'] = _addBoiledEgg
                      ..['portion'] = _selectedPortion
                      ..['totalPrice'] = _totalPrice;
                    widget.onAddToCart(customizedItem);
                },
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(color: HexColor.fromHex('#E88A2D'),borderRadius: BorderRadius.circular(12)),
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


  
