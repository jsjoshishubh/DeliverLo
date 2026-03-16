import 'package:flutter/material.dart';

class QuantityStepper extends StatefulWidget {
  final int initialValue;
  final Function(int)? onChanged;

  const QuantityStepper({
    super.key,
    this.initialValue = 1,
    this.onChanged,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFF6EDE7),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.orange,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: decrement,
            child: const Icon(
              Icons.remove,
              color: Colors.orange,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            "$count",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: increment,
            child: const Icon(
              Icons.add,
              color: Colors.orange,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}