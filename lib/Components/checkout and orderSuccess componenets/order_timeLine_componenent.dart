import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class OrderTimeline extends StatelessWidget {
  final List<OrderTimelineItem> items;

  const OrderTimeline({required this.items});

  Color _dotColor(OrderTimelineStatus status) {
    switch (status) {
      case OrderTimelineStatus.completed:
      case OrderTimelineStatus.current:
        return HexColor.fromHex('#F97316'); // orange
      case OrderTimelineStatus.inactive:
        return HexColor.fromHex('#E2E8F0'); // light gray
    }
  }

  Color _titleColor(OrderTimelineStatus status) {
    switch (status) {
      case OrderTimelineStatus.completed:
      case OrderTimelineStatus.current:
        return HexColor.fromHex('#0F172A');
      case OrderTimelineStatus.inactive:
        return HexColor.fromHex('#94A3B8');
    }
  }

  Color _subtitleColor(OrderTimelineStatus status) {
    return HexColor.fromHex('#64748B');
  }

  Color _timeColor(OrderTimelineStatus status) {
    switch (status) {
      case OrderTimelineStatus.completed:
      case OrderTimelineStatus.current:
        return HexColor.fromHex('#64748B');
      case OrderTimelineStatus.inactive:
        return HexColor.fromHex('#CBD5F5');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIMELINE',
            style: commonTextStyle(
              fontColor: HexColor.fromHex('#94A3B8'),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              final isLast = index == items.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _dotColor(item.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: HexColor.fromHex('#E2E8F0'),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: commonTextStyle(
                            fontColor: _titleColor(item.status),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              item.subtitle,
                              style: commonTextStyle(
                                fontColor: _subtitleColor(item.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 4,),
                            Container(
                              height: 4,
                              width: 4,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: _subtitleColor(item.status),),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            SizedBox(width: 4,),
                            Text(
                              item.time,
                              style: commonTextStyle(
                                fontColor: _timeColor(item.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (!isLast) const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}


enum OrderTimelineStatus { completed, current, inactive }

class OrderTimelineItem {
  final String title;
  final String subtitle;
  final String time;
  final OrderTimelineStatus status;

  const OrderTimelineItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.status,
  });
}