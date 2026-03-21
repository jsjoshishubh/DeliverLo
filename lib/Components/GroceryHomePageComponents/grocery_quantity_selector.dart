import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// Quantity selector row: "Quantity" label on left, minus/value/plus counter on right.
class GroceryQuantitySelector extends StatefulWidget {
  const GroceryQuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.onChanged,
  });

  final int initialQuantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int>? onChanged;

  @override
  State<GroceryQuantitySelector> createState() => _GroceryQuantitySelectorState();
}

class _GroceryQuantitySelectorState extends State<GroceryQuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity.clamp(widget.minQuantity, widget.maxQuantity);
  }

  void _decrement() {
    if (_quantity > widget.minQuantity) {
      setState(() => _quantity--);
      widget.onChanged?.call(_quantity);
    }
  }

  void _increment() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
      widget.onChanged?.call(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Quantity',
              style: commonTextStyle(
                fontSize: 16,
                fontColor: blackFontColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CounterButton(
                  icon: Icons.remove,
                  isPrimary: false,
                  onTap: _decrement,
                  enabled: _quantity > widget.minQuantity,
                ),
                const SizedBox(width: 16),
                Text(
                  '$_quantity',
                  style: commonTextStyle(
                    fontSize: 16,
                    fontColor: blackFontColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 16),
                _CounterButton(
                  icon: Icons.add,
                  isPrimary: true,
                  onTap: _increment,
                  enabled: _quantity < widget.maxQuantity,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.isPrimary,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isPrimary ? const Color(0xFF66BB6A) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: isPrimary ? Colors.white : const Color(0xFF37474F),
          ),
        ),
      ),
    );
  }
}
