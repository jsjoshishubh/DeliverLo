import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// Reusable bottom bar card: left (label + price) and right (gradient action button).
/// Use for product detail, checkout, or any add-to-cart style flow.
class CommonAddToBasketCard extends StatelessWidget {
  const CommonAddToBasketCard({
    super.key,
    this.priceLabel = 'TOTAL PRICE',
    this.priceValue = '₹240',
    this.buttonText = 'Add to Basket',
    this.icon = Icons.shopping_basket_outlined,
    this.onPressed,
    this.containerBackgroundColor = Colors.white,
    this.containerShadowColor,
    this.containerBorderRadius = 50,
    this.labelTextStyle,
    this.priceTextStyle,
    this.buttonGradient,
    this.buttonTextStyle,
    this.buttonIconColor = Colors.white,
    this.buttonIconSize = 22,
    this.buttonShadowColor,
    this.padding,
    this.leftChild,
    this.rightChild,
  });

  /// Left section label (e.g. "TOTAL PRICE"). Ignored if [leftChild] is set.
  final String? priceLabel;
  /// Left section value (e.g. "₹240"). Ignored if [leftChild] is set.
  final String? priceValue;
  /// Right button text.
  final String buttonText;
  /// Right button icon.
  final IconData icon;
  /// Callback when button is tapped.
  final VoidCallback? onPressed;

  /// Main container background.
  final Color containerBackgroundColor;
  /// Shadow color; defaults to black 6% if null.
  final Color? containerShadowColor;
  /// Main container border radius (pill = 50+).
  final double containerBorderRadius;

  /// Style for price label. Default: small grey uppercase.
  final TextStyle? labelTextStyle;
  /// Style for price value. Default: large bold dark.
  final TextStyle? priceTextStyle;

  /// Button gradient. Default: light lime to medium green.
  final Gradient? buttonGradient;
  /// Button text style.
  final TextStyle? buttonTextStyle;
  /// Button icon color.
  final Color buttonIconColor;
  /// Button icon size.
  final double buttonIconSize;
  /// Button shadow color; default green-tinted if null.
  final Color? buttonShadowColor;

  /// Internal padding of the card.
  final EdgeInsetsGeometry? padding;

  /// Optional custom left widget (replaces label+price).
  final Widget? leftChild;
  /// Optional custom right widget (replaces button).
  final Widget? rightChild;

  static Gradient get _defaultButtonGradient =>  LinearGradient(
        colors: [Color(0xFFA3E635), Color(0xFF15803D)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  @override
  Widget build(BuildContext context) {
    final left = leftChild ?? _buildLeftSection();
    final right = rightChild ?? _buildButton();

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: containerBackgroundColor,
        borderRadius: BorderRadius.circular(containerBorderRadius),
        boxShadow: [
          BoxShadow(
            color: (containerShadowColor ?? Colors.black)
                .withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          left,
          right,
        ],
      ),
    );
  }

  Widget _buildLeftSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (priceLabel ?? 'TOTAL PRICE').toUpperCase(),
          style: labelTextStyle ??
              commonTextStyle(
                fontSize: 12,
                fontColor: greyFontColor,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          priceValue ?? '₹240',
          style: priceTextStyle ??
              commonTextStyle(
                fontSize: 22,
                fontColor: blackFontColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    final gradient = buttonGradient ?? _defaultButtonGradient;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: (buttonShadowColor ?? const Color(0xFF4CAF50))
                  .withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText,
              style: buttonTextStyle ??
                  commonTextStyle(
                    fontSize: 16,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(width: 10),
            Icon(
              icon,
              color: buttonIconColor,
              size: buttonIconSize,
            ),
          ],
        ),
      ),
    );
  }
}
