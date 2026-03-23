import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';

class CommonBottomBarItem {
  final IconData icon;
  final String label;

  const CommonBottomBarItem({
    required this.icon,
    required this.label,
  });
}


class CommonBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CommonBottomBarItem> items;
  final Color selectedColor;

  static const double _contentHeight = 80;
  static const double _iconSize = 26;
  static const double _fontSize = 12;
  static final Color _selectedBackgroundColor = HexColor.fromHex('#FFEFEF');
  static final Color _unselectedColor = HexColor.fromHex('#777777');

  const CommonBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.selectedColor = const Color(0xFFBD0D0E),
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: _contentHeight + bottomPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: _contentHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              return _BottomBarTile(
                icon: items[index].icon,
                label: items[index].label,
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                selectedColor: selectedColor,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomBarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;

  const _BottomBarTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalMargin = isSelected
                    ? (constraints.maxWidth * 3.2).clamp(4.0, 10.0)
                    : 0.0;

                final content = Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: CommonBottomBar._iconSize,
                      color: isSelected
                          ? selectedColor
                          : CommonBottomBar._unselectedColor,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          !isSelected ? label : label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: CommonBottomBar._fontSize,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? selectedColor
                                : CommonBottomBar._unselectedColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );

                return isSelected
                    ? Container(
                        margin:EdgeInsets.symmetric(horizontal: horizontalMargin),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: CommonBottomBar._selectedBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: content,
                      )
                    : content;
              },
            ),
          ),
        ),
      ),
    );
  }
}
