import 'package:flutter/material.dart';

/// Product-detail style background: a **flat** top image (no curved bottom on the image)
/// with a **white sheet** that overlaps the lower part of the image, rounded top corners,
/// and a soft shadow—matching typical grocery product screens.
class GroceryDetailScreenBackground extends StatelessWidget {
  const GroceryDetailScreenBackground({
    super.key,
    this.topChild,
    this.bottomChild,
    this.topImageAsset,
    this.topImageUrl,
    this.topColor = const Color(0xFF0D1117),
    this.bottomColor = Colors.white,
    this.scaffoldBackgroundColor = Colors.white,
    this.topHeight,
    this.topHeightFraction = 0.42,
    /// How far the white sheet slides **up** over the image (≈10–15% of image height looks right).
    this.sheetOverlap,
    this.sheetOverlapFraction = 0.12,
    /// Large radius on top-left / top-right of the sheet (pill-like card).
    this.sheetTopCornerRadius = 36,
    this.sheetShadowBlur = 18,
    this.sheetShadowOffsetY = 6,
    this.sheetShadowOpacity = 0.10,
    this.scrollable = false,
  }) : assert(
          topImageAsset == null || topImageUrl == null,
          'Use either topImageAsset or topImageUrl, not both.',
        );

  final Widget? topChild;
  final Widget? bottomChild;
  final String? topImageAsset;
  final String? topImageUrl;
  final Color topColor;
  final Color bottomColor;
  final Color scaffoldBackgroundColor;
  final double? topHeight;
  final double topHeightFraction;
  /// Fixed overlap in logical pixels. If null, [sheetOverlapFraction] × image height is used.
  final double? sheetOverlap;
  final double sheetOverlapFraction;
  final double sheetTopCornerRadius;
  final double sheetShadowBlur;
  final double sheetShadowOffsetY;
  final double sheetShadowOpacity;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight =
        topHeight ?? (screenHeight * topHeightFraction.clamp(0.2, 0.65));

    final rawOverlap = sheetOverlap ??
        (imageHeight * sheetOverlapFraction.clamp(0.04, 0.25));
    // Keep overlap sensible vs image height (design: ~10–15% of image).
    final overlap = rawOverlap.clamp(8.0, imageHeight * 0.35);
    final radius = sheetTopCornerRadius.clamp(16.0, 56.0);

    Widget topBackground = Container(color: topColor);
    if (topImageAsset != null || topImageUrl != null) {
      topBackground = Image(
        image: topImageAsset != null
            ? AssetImage(topImageAsset!)
            : NetworkImage(topImageUrl!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: topColor),
      );
    }

    // Flat image strip — no bottom curve on the image itself.
    final imageLayer = SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          topBackground,
          if (topChild != null) topChild!,
        ],
      ),
    );

    final sheetDecoration = BoxDecoration(
      color: bottomColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(radius),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: sheetShadowOpacity),
          blurRadius: sheetShadowBlur,
          offset: Offset(0, sheetShadowOffsetY),
        ),
      ],
    );

    Widget sheetContent = bottomChild ?? const SizedBox.shrink();
    if (scrollable) {
      sheetContent = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: bottomChild ?? const SizedBox.shrink(),
      );
    }

    final sheetLayer = Positioned(
      left: 0,
      right: 0,
      top: imageHeight - overlap,
      bottom: 0,
      child: Material(
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: sheetDecoration,
          child: sheetContent,
        ),
      ),
    );

    return ColoredBox(
      color: scaffoldBackgroundColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: imageLayer,
          ),
          sheetLayer,
        ],
      ),
    );
  }
}
