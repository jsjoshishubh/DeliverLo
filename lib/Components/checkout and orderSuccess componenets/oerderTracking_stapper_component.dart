import 'package:deliverylo/Styles/app_colors.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

// Colors from design
const Color _kActiveColor = Color(0xFFFF8C00);
const Color _kInactiveLine = Color(0xFFE2E8F0);
const Color _kInactiveIcon = Color(0xFFCBD5E1);
const double _kIconSize = 15.0;
const double _kStepRadius = 30.0;
const double _kLabelFontSize = 12.0;

/// Main order tracking stepper built with easy_stepper.
class OrderTrackingStepperComponent extends StatelessWidget {
  final int currentStep;
  final EdgeInsetsGeometry? padding;

  const OrderTrackingStepperComponent({
    super.key,
    this.currentStep = 1,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final step = currentStep.clamp(0, 3);

    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: EasyStepper(
        activeStep: step,
        reachedSteps: {for (int i = 0; i <= step; i++) i},
        lineStyle: const LineStyle(
          lineType: LineType.normal,
          unreachedLineType: LineType.normal,
          lineLength: 40,
          lineSpace: 0,
          lineThickness: 2,
          defaultLineColor: _kInactiveLine,
          unreachedLineColor: _kInactiveLine,
          activeLineColor: _kActiveColor,
          finishedLineColor: _kActiveColor,
        ),
        // Hide built-in step visuals; we draw them with _StepperIcon
        activeStepBackgroundColor: Colors.transparent,
        finishedStepBackgroundColor: Colors.transparent,
        unreachedStepBackgroundColor: Colors.transparent,
        activeStepBorderColor: Colors.transparent,
        finishedStepBorderColor: Colors.transparent,
        unreachedStepBorderColor: Colors.transparent,
        activeStepIconColor: Colors.transparent,
        finishedStepIconColor: Colors.transparent,
        unreachedStepIconColor: Colors.transparent,
        activeStepTextColor: _kActiveColor,
        unreachedStepTextColor: _kInactiveIcon,
        internalPadding: 0,
        padding: EdgeInsets.zero,
        showLoadingAnimation: false,
        showStepBorder: false,
        borderThickness: 0,
        stepRadius: _kStepRadius,
        stepShape: StepShape.rRectangle,
        enableStepTapping: false,
        steps: [
          EasyStep(
            customStep: _StepperIcon(
              icon: Icons.check,
              isActive: step >= 0,
            ),
            title: 'Placed',
          ),
          EasyStep(
            customStep: _StepperIcon(
              icon: Icons.restaurant,
              isActive: step >= 1,
            ),
            title: 'Preparing',
          ),
          EasyStep(
            customStep: _StepperIcon(
              icon: Icons.pedal_bike,
              isActive: step >= 2,
              isCurrent: step == 2,
            ),
            title: 'Out for Delivery',
          ),
          EasyStep(
            customStep: _StepperIcon(
              icon: Icons.home,
              isActive: step >= 3,
            ),
            title: 'Delivered',
          ),
        ],
        titleTextStyle:  TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: HexColor.fromHex('#0F172A'),
        ),
      ),
    );
  }
}

class _StepperIcon extends StatelessWidget {
  final IconData icon;
  final bool isCurrent;
  final bool isActive;

  const _StepperIcon({
    required this.icon,
    this.isCurrent = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color iconColor;
    BoxBorder? border;
    List<BoxShadow>? shadow;

    if (isCurrent) {
      bg = Colors.white;
      iconColor = _kActiveColor;
      border = Border.all(color: _kActiveColor, width: 1.5);
      shadow = [
        BoxShadow(
          color: _kActiveColor.withOpacity(0.35),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
    } else if (isActive) {
      bg = _kActiveColor;
      iconColor = Colors.white;
    } else {
      bg = _kInactiveLine;
      iconColor = _kInactiveIcon;
    }

    return Container(
      width: _kIconSize + 20,
      height: _kIconSize + 20,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: border,
        boxShadow: shadow,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: _kIconSize,
        color: iconColor,
      ),
    );
  }
}
