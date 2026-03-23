import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';

class GoogleMapOnTheWayCard extends StatelessWidget {
  const GoogleMapOnTheWayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'On the way',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: blackFontColor[500],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #29384 • 3 items',
                      style: TextStyle(
                        fontSize: 13,
                        color: greyFontColor[500],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '15 min',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: blackFontColor[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Estimated Arrival',
                    style: TextStyle(
                      fontSize: 11,
                      color: greyFontColor[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusText(
                label: 'Preparing',
                isActive: false,
              ),
              _StatusText(
                label: 'On the way',
                isActive: true,
              ),
              _StatusText(
                label: 'Delivered',
                isActive: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(999),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Michael R.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackFontColor[500],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '4.9 (124 deliveries)',
                          style: TextStyle(
                            fontSize: 11,
                            color: greyFontColor[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _IconButton(
                icon: Icons.phone,
                background: Colors.white,
                iconColor: Colors.orange,
              ),
              const SizedBox(width: 8),
              _IconButton(
                icon: Icons.chat_bubble_outline,
                background: Colors.white,
                iconColor: blackFontColor[500]!,
                borderColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  final String label;
  final bool isActive;

  const _StatusText({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? Colors.orange : greyFontColor[500],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}

