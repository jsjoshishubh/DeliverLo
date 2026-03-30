import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';

class QuantityStepper extends StatefulWidget {
  final int initialValue;
  final Function(int)? onChanged;
  final bool allowRemoveAtOne;
  /// When set (e.g. grocery checkout), replaces default red stepper styling.
  final Color? accentColor;
  final Color? accentSurfaceColor;

  const QuantityStepper({
    super.key,
    this.initialValue = 1,
    this.onChanged,
    this.allowRemoveAtOne = false,
    this.accentColor,
    this.accentSurfaceColor,
  });

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  void increment() {
    setState(() {
      count++;
    });
    widget.onChanged?.call(count);
  }

  void decrement() {
    if (count > 1) {
      setState(() {
        count--;
      });
      widget.onChanged?.call(count);
      return;
    }
    if (count == 1 && widget.allowRemoveAtOne) {
      widget.onChanged?.call(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.accentColor ?? redColor;
    final surface = widget.accentSurfaceColor ?? lightRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      height: 25,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: decrement,
            child: Icon(
              Icons.remove,
              color: border,
              size: 16,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            "$count",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: increment,
            child: Icon(
              Icons.add,
              color: border,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}