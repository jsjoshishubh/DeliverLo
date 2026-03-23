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
    this.scrollable = false,
    this.topImageUrl,
  });

  final Widget? topChild;
  final Widget? bottomChild;
  final Color topColor;
  final Color bottomColor;
  final double? topHeight;
  final double topHeightFraction;
  final double curveHeight;
  final bool scrollable;
  /// Optional image for the top section. When set, the image is shown as background with [topChild] stacked on top.
  final String? topImageUrl;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveTopHeight = topHeight ?? (screenHeight * topHeightFraction.clamp(0.0, 1.0));

    final topRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(40),
      bottomRight: Radius.circular(40),
    );
    final topSection = Container(
      height: effectiveTopHeight + curveHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: topColor,
        borderRadius: topRadius,
      ),
      child: ClipRRect(
        borderRadius: topRadius,
        child: topImageUrl != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    topImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                  if (topChild != null) topChild!,
                ],
              )
            : topChild,
      ),
    );

    final bottomSection = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bottomColor,
      ),
      child: bottomChild ?? const SizedBox.shrink(),
    );

    if (scrollable) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [topSection, bottomSection],
        ),
      );
    }

    return Column(
      children: [
        topSection,
        Expanded(child: bottomSection),
      ],
    );
  }
}

