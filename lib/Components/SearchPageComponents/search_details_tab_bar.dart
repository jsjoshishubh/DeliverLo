import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// Tab bar with a full-width grey bottom divider and an orange underline
/// for the selected tab. Shows menu item cards below according to [selectedIndex].
class SearchDetailsTabBar extends StatefulWidget {
  const SearchDetailsTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.menuItemsByTab,
    required this.onAddToCart,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  /// One list of menu items per tab; [selectedIndex] determines which list is shown.
  final List<List<Map<String, dynamic>>> menuItemsByTab;
  final void Function(Map<String, dynamic> item) onAddToCart;

  @override
  State<SearchDetailsTabBar> createState() => _SearchDetailsTabBarState();
}

class _SearchDetailsTabBarState extends State<SearchDetailsTabBar>
    with SingleTickerProviderStateMixin {
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
    } else if (_controller.index != widget.selectedIndex &&
        widget.selectedIndex >= 0 &&
        widget.selectedIndex < widget.tabs.length) {
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
                  borderSide: BorderSide(
                    color: HexColor.fromHex('#E88A2E'),
                    width: _indicatorHeight,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                dividerColor: Colors.transparent,
                labelColor: HexColor.fromHex('#E88A2E'),
                unselectedLabelColor: _unselectedColor,
                labelStyle: commonTextStyle(
                  fontSize: 16,
                  fontColor: HexColor.fromHex('#E88A2E'),
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: commonTextStyle(
                  fontSize: 14,
                  fontColor: _unselectedColor,
                  fontWeight: FontWeight.w500,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                tabs: widget.tabs
                    .map(
                      (label) => Tab(
                        child: Text(
                          label,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    )
                    .toList(),
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
  const SearchDetailsMenuItemCard({
    super.key,
    required this.item,
    required this.onAddTap,
    this.topPadding,
    this.showBottomDivider = true,
  });

  final Map<String, dynamic> item;
  final VoidCallback onAddTap;
  final double? topPadding;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    final isVeg = item['isVeg'] as bool? ?? true;
    final isBestseller = item['isBestseller'] as bool? ?? false;
    final top = topPadding ?? 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Veg icon first, then BESTSELLER tag (per image)
                    Row(
                      children: [
                        if (isVeg)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: HexColor.fromHex('#22C55E'), width: 1.5),
                            ),
                            child: Icon(Icons.circle, size: 8, color: HexColor.fromHex('#22C55E')),
                          ),
                        if (isVeg && isBestseller) const SizedBox(width: 8),
                        if (isBestseller)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: HexColor.fromHex('#FED7AA'),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'BESTSELLER',
                              style: commonTextStyle(
                                fontSize: 10,
                                fontColor: HexColor.fromHex('#C2410C'),
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
                            color:Colors.grey.shade300.withValues(alpha: 0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'ADD',
                          style: commonTextStyle(
                            fontSize: 14,
                            fontColor: HexColor.fromHex('#111827'),
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
        if (showBottomDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DottedLinePainter(color: HexColor.fromHex('#E5E7EB')),
            ),
          ),
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const dashWidth = 4.0;
    const gap = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

