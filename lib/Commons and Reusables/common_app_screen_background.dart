import 'package:flutter/material.dart';

class CommonAppScreenBackground extends StatelessWidget {
  const CommonAppScreenBackground({
    super.key,
    this.topChild,
    this.bottomChild,
    this.topColor = const Color(0xFFE23744),
    this.bottomColor = Colors.white,
    this.topHeight,
    this.topHeightFraction = 0.4,
    this.curveHeight = 28,
  });

  final Widget? topChild;
  final Widget? bottomChild;
  final Color topColor;
  final Color bottomColor;
  final double? topHeight;
  final double topHeightFraction;
  final double curveHeight;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveTopHeight = topHeight ?? (screenHeight * topHeightFraction.clamp(0.0, 1.0));

    return Column(
      children: [
        // Top section (red) with rounded bottom corners
        Container(
          height: effectiveTopHeight + curveHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: topColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: topChild,
        ),
        // Bottom section (white)
        Container(
          decoration: BoxDecoration(
            color: bottomColor,
          ),
          child: bottomChild ?? const SizedBox.shrink(),
        ),
      ],
    );
  }
}

