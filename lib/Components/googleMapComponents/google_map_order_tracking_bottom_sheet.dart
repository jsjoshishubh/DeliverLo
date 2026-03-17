import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Components/checkout and orderSuccess componenets/oerderTracking_stapper_component.dart';
import 'package:flutter/material.dart';

class GoogleMapOrderTrackingBottomSheet extends StatelessWidget {
  const GoogleMapOrderTrackingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Rider is picking up your order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: HexColor.fromHex('#0F172A'),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Hold on! Your food is almost on its way.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: HexColor.fromHex('#64748B'),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const OrderTrackingStepperComponent(
              currentStep: 2, // Out for Delivery
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            ),
            const SizedBox(height: 8),
            _RiderCard(),
            const SizedBox(height: 24),
            _OrderSummaryRow(),
          ],
        ),
      ),
    );
  }
}

class _RiderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: HexColor.fromHex('#F8FBFF'),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              Positioned(
                bottom: -4,
                left: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rider 09',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: blackFontColor[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: #DX-8829',
                  style: TextStyle(
                    fontSize: 12,
                    color: greyFontColor[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _IconButton(
            icon: Icons.chat_bubble_outline,
            background: Colors.white,
            iconColor: blackFontColor[500]!,
            borderColor: HexColor.fromHex('#E2E8F0'),
          ),
          const SizedBox(width: 10),
          _IconButton(
            icon: Icons.phone,
            background: Colors.orange,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final Color? borderColor;

  const _IconButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        boxShadow: background == Colors.orange
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 0,
                thickness: 1,
                color: Colors.grey.shade200,
              ),
              const SizedBox(height: 14),
              Text(
                'YOUR ORDER',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: greyFontColor[500],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2 Items • 300',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: blackFontColor[500],
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Details',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ],
        )
      ],
    );
  }
}

