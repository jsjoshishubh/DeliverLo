import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Commons and Reusables/commonButton.dart';
import 'package:deliverylo/Commons and Reusables/common_doted_divider.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class PastOrdersTabComponent extends StatefulWidget {
  const PastOrdersTabComponent({super.key});

  @override
  State<PastOrdersTabComponent> createState() => _PastOrdersTabComponentState();
}

class _PastOrdersTabComponentState extends State<PastOrdersTabComponent> {
  final List<Map<String, String>> _tabs = const [
    {'tab_title': 'Food'},
    {'tab_title': 'Grocery'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'PAST ORDERS',
              style: commonTextStyle(
                fontSize: 14,
                fontColor: HexColor.fromHex('#6B7280'),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TabBar(
              isScrollable: false,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: HexColor.fromHex('#111827'),
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.60),
              labelColor: Colors.white,
              unselectedLabelColor: HexColor.fromHex('#6B7280'),
              labelStyle: commonTextStyle(
                fontSize: 14,
                fontColor: HexColor.fromHex('#FFFFFF'),
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: commonTextStyle(
                fontSize: 14,
                fontColor: HexColor.fromHex('#6B7280'),
                fontWeight: FontWeight.w600,
              ),
              tabs: _tabs.map((e) => Tab(text: e['tab_title'] ?? ''),).toList(),
            ),
          ),
          const SizedBox(height: 14),
          Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context);
              if (tabController == null) {
                return  _PastOrdersList();
              }
              return AnimatedBuilder(
                animation: tabController,
                builder: (context, _) {
                  final index = tabController.index;
                  return IndexedStack(
                    index: index,
                    children: const [
                      _PastOrdersList(),
                      _PastOrdersList(),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PastOrdersList extends StatefulWidget {
  const _PastOrdersList();

  @override
  State<_PastOrdersList> createState() => _PastOrdersListState();
}

class _PastOrdersListState extends State<_PastOrdersList> {
  bool isLoading = true;

  final List<_PastOrder> _orders = [
    const _PastOrder(
      image: 'Assets/Extras/order_delivered.png',
      title: 'Facebook Fast Food',
      subtitle: 'Nana Varachha',
      status: 'DELIVERED',
      itemsSummary: '2 × Grilled Puff\n1 × FB Special Mayo Sandwich\n& 1 more',
      orderedInfo: 'Ordered: June 17, 4:41 PM · Bill Total: ₹327',
    ),
    const _PastOrder(
      image: 'Assets/Extras/rider.png',
      title: 'Shri Pahelvan Chhole...',
      subtitle: 'Surat City',
      status: 'DELIVERED',
      itemsSummary: '2 × Chole Samosa\n1 × Paneer Chole Bhature',
      orderedInfo: 'Ordered: June 10, 1:21 PM · Bill Total: ₹275',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: HexColor.fromHex('#BD0D0E'),
            ),
            const SizedBox(height: 12),
            Text(
              'Loading past orders...',
              style: commonTextStyle(
                fontColor: HexColor.fromHex('#6B7280'),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _PastOrderCard(order: order);
      },
    );
  }
}

class _PastOrder {
  final String image;
  final String title;
  final String subtitle;
  final String status;
  final String itemsSummary;
  final String orderedInfo;

  const _PastOrder({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.itemsSummary,
    required this.orderedInfo,
  });
}

class _PastOrderCard extends StatelessWidget {
  final _PastOrder order;

  const _PastOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    order.image,
                    height: 44,
                    width: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 44,
                      width: 44,
                      color: HexColor.fromHex('#E5E7EB'),
                      child: Icon(
                        Icons.fastfood,
                        color: HexColor.fromHex('#9CA3AF'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.title,
                              style: commonTextStyle(
                                fontColor: HexColor.fromHex('#1F2937'),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: HexColor.fromHex('#ECFDF3'),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  order.status,
                                  style: commonTextStyle(
                                    fontColor: HexColor.fromHex('#15803D'),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: HexColor.fromHex('#16A34A'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.subtitle,
                        style: commonTextStyle(
                          fontColor: HexColor.fromHex('#6B7280'),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:18.0),
            child: SizedBox(
              height: 1,
              width: double.infinity,
              child: CustomPaint(
                painter: DottedLinePainter(
                  color: HexColor.fromHex('#E5E7EB'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: _buildItemsSummary(order),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:18.0),
            child: Divider(
              height: 1,
              color: HexColor.fromHex('#E5E7EB'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 19),
            child: Row(
              children: [
                _buildRatingColumn(
                  title: 'Food Rating',
                  
                  color: HexColor.fromHex('#1F2937'),
                ),
                Container(
                  width: 1,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  color: HexColor.fromHex('#E5E7EB'),
                ),
                _buildRatingColumn(
                  title: 'Delivery Rating',
                  color: HexColor.fromHex('#1F2937'),
                ),
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal:18.0),
            child: Divider(
              height: 1,
              color: HexColor.fromHex('#E5E7EB'),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: LoadingButton(
              title: 'Reorder',
              titleColor: HexColor.fromHex('#F15700'),
              buttonColor: HexColor.fromHex('#F15700').withValues( alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              height: 44,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(
              order.orderedInfo,
              style: commonTextStyle(
                fontColor: HexColor.fromHex('#9CA3AF'),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingColumn({required String title, required Color color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: commonTextStyle(
              fontColor: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: List.generate(
              5,
              (index) => Container(
                margin: EdgeInsets.only(right: index == 4 ? 0 : 8),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: HexColor.fromHex('#E5E7EB'),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSummary(_PastOrder order) {
    final lines = order.itemsSummary.split('\n');

    final itemLines = <String>[];
    String? moreLine;

    for (final line in lines) {
      if (line.trim().startsWith('&')) {
        moreLine = line.trim();
      } else if (line.trim().isNotEmpty) {
        itemLines.add(line.trim());
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...itemLines.map((line) {
          final parts = line.split('×');
          String qty = '';
          String name = line;
          if (parts.length == 2) {
            qty = parts[0].trim();
            name = parts[1].trim();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(color: HexColor.fromHex('#F3F4F6'),borderRadius: BorderRadius.circular(8),),
                  child: Text(
                    '${qty.isEmpty ? '' : qty} x',
                    style: commonTextStyle(fontColor: HexColor.fromHex('#6B7280'),fontSize: 12,fontWeight: FontWeight.w600,),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    name,
                    style: commonTextStyle(fontColor: HexColor.fromHex('#6B7280'),fontSize: 12,fontWeight: FontWeight.w500,),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
        if (moreLine != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              moreLine,
              style: commonTextStyle(fontColor: HexColor.fromHex('#6B7280'),fontSize: 12,fontWeight: FontWeight.w400,),
            ),
          ),
      ],
    );
  }
}
