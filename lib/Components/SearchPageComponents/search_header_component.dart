import 'package:deliverylo/Commons%20and%20Reusables/commonTextFormField.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class SearchHeaderComponent extends StatelessWidget {
  const SearchHeaderComponent({
    super.key,
    required this.searchController,
    this.searchFieldHint = "Biryani",
    this.onBackTap,
    this.onClearTap,
    this.onSearchSubmitted,
    this.onSearchChanged,
    this.onFilterTap,
    this.onRatingTap,
    this.onFastDeliveryTap,
    this.filtersSelected = false,
    this.ratingFilterSelected = false,
    this.fastDeliverySelected = false,
  });

  final TextEditingController searchController;
  final String searchFieldHint;
  final VoidCallback? onBackTap;
  final VoidCallback? onClearTap;
  final ValueChanged<String>? onSearchSubmitted;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onRatingTap;
  final VoidCallback? onFastDeliveryTap;
  final bool filtersSelected;
  final bool ratingFilterSelected;
  final bool fastDeliverySelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchBar(
            controller: searchController,
            searchFieldHint: searchFieldHint,
            onBackTap: onBackTap ?? () => Navigator.of(context).pop(),
            onClearTap: onClearTap ?? () {},
            onSearchSubmitted: onSearchSubmitted,
            onSearchChanged: onSearchChanged,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FilterChip(
                label: 'Filters',
                icon: Icons.tune,
                selected: filtersSelected,
                onTap: onFilterTap ?? () {},
              ),
              const SizedBox(width: 10),
              _FilterChip(
                label: 'Rating 4.0+',
                selected: ratingFilterSelected,
                onTap: onRatingTap ?? () {},
              ),
              const SizedBox(width: 10),
              _FilterChip(
                label: 'Fast Delivery',
                selected: fastDeliverySelected,
                onTap: onFastDeliveryTap ?? () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.searchFieldHint,
    required this.onBackTap,
    required this.onClearTap,
    this.onSearchSubmitted,
    this.onSearchChanged,
  });

  final TextEditingController controller;
  final String searchFieldHint;
  final VoidCallback onBackTap;
  final VoidCallback onClearTap;
  final ValueChanged<String>? onSearchSubmitted;
  final ValueChanged<String>? onSearchChanged;

  void _onClear() {
    controller.clear();
    onClearTap();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormFieldWidget(
            labelText: "Search '$searchFieldHint'",
            contentPadding: const EdgeInsets.fromLTRB(12.0, 3.0, 20.0, 13.0),
            controller: controller,
            textInputAction: TextInputAction.search,
            prefixIcon: GestureDetector(
              onTap: onBackTap,
              child: Icon(Icons.arrow_back, color: HexColor.fromHex('#9CA3AF'), size: 22),
            ),
            suffixIcon: GestureDetector(
              onTap: _onClear,
              child: Icon(Icons.close, color: HexColor.fromHex('#9CA3AF'), size: 20),
            ),
            onSubmitted: (v) =>
                onSearchSubmitted != null ? onSearchSubmitted!(v?.toString() ?? '') : null,
            onChanged: (v) => onSearchChanged != null ? onSearchChanged!(v?.toString() ?? '') : null,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.icon,
    this.selected = false,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  static final Color _accentRed = HexColor.fromHex('#BD0D0E');

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? _accentRed : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Colors.white : Colors.white.withValues(alpha: 0.55),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon!, size: 18, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: commonTextStyle(
                fontSize: 14,
                fontColor: fg,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
