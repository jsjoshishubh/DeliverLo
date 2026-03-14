import 'package:deliverylo/Commons%20and%20Reusables/commonTextFormField.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class SearchHeaderComponent extends StatelessWidget {
  const SearchHeaderComponent({
    super.key,
    this.searchQuery = "Biryani",
    this.onBackTap,
    this.onClearTap,
    this.onFilterTap,
    this.onRatingTap,
    this.onFastDeliveryTap,
  });

  final String searchQuery;
  final VoidCallback? onBackTap;
  final VoidCallback? onClearTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onRatingTap;
  final VoidCallback? onFastDeliveryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchBar(
            searchQuery: searchQuery,
            onBackTap: onBackTap ?? () => Navigator.of(context).pop(),
            onClearTap: onClearTap ?? () {},
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FilterChip(
                label: 'Filters',
                icon: Icons.tune,
                onTap: onFilterTap ?? () {},
              ),
              const SizedBox(width: 10),
              _FilterChip(
                label: 'Rating 4.0+',
                onTap: onRatingTap ?? () {},
              ),
              const SizedBox(width: 10),
              _FilterChip(
                label: 'Fast Delivery',
                onTap: onFastDeliveryTap ?? () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.searchQuery,
    required this.onBackTap,
    required this.onClearTap,
  });

  final String searchQuery;
  final VoidCallback onBackTap;
  final VoidCallback onClearTap;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    widget.onClearTap();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // GestureDetector(
        //   onTap: widget.onBackTap,
        //   child: Icon(Icons.arrow_back, color: HexColor.fromHex('#3D4152'), size: 24),
        // ),
        // const SizedBox(width: 12),
        Expanded(
          child: TextFormFieldWidget(
            labelText: "Search '${widget.searchQuery}'",
            contentPadding:  EdgeInsets.fromLTRB(12.0, 3.0, 20.0, 13.0),
            controller: _controller,
            prefixIcon: Icon(Icons.arrow_back, color: HexColor.fromHex('#9CA3AF'), size: 22),
            suffixIcon: GestureDetector(
              onTap: _onClear,
              child: Icon(Icons.close, color: HexColor.fromHex('#9CA3AF'), size: 20),
            ),
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
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon!, size: 18, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: commonTextStyle(
                fontSize: 14,
                fontColor: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
