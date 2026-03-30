import 'package:deliverylo/Commons%20and%20Reusables/common_QuantityStepper.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_doted_divider.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

int checkoutLineUnitRupees(Map<String, dynamic> item) {
  final tp = item['totalPrice'];
  if (tp is num) return tp.round();
  return parsePrice(item['price']?.toString());
}

String checkoutLineTitle(Map<String, dynamic> item) {
  final d = item['dish']?.toString().trim();
  if (d != null && d.isNotEmpty) return d;
  final n = item['name']?.toString().trim();
  if (n != null && n.isNotEmpty) return n;
  return 'Item';
}

String checkoutLineSubtitle(Map<String, dynamic> item) {
  final parts = <String>[];

  final vid = item['selectedVariantId']?.toString();
  if (vid != null && vid.isNotEmpty) {
    final vars = item['variants'];
    if (vars is List) {
      for (final v in vars) {
        if (v is Map) {
          final m = Map<String, dynamic>.from(v);
          if (m['_id']?.toString() == vid) {
            final dn = m['displayName']?.toString().trim();
            if (dn != null && dn.isNotEmpty) parts.add(dn);
            break;
          }
        }
      }
    }
  }

  final sel = item['selectedOptionIdsByGroup'];
  if (sel is Map) {
    final groups = item['optionGroups'];
    if (groups is List) {
      for (final g in groups) {
        if (g is! Map) continue;
        final gm = Map<String, dynamic>.from(g);
        final gid = gm['_id']?.toString() ?? '';
        if (gid.isEmpty) continue;
        final selectedRaw = sel[gid];
        if (selectedRaw is! List || selectedRaw.isEmpty) continue;
        final selectedIds = selectedRaw.map((e) => e.toString()).toSet();
        final optItems = gm['items'];
        if (optItems is! List) continue;
        for (final opt in optItems) {
          if (opt is! Map) continue;
          final om = Map<String, dynamic>.from(opt);
          final oid = om['_id']?.toString();
          if (oid != null && selectedIds.contains(oid)) {
            final name = om['name']?.toString().trim();
            if (name != null && name.isNotEmpty) parts.add(name);
          }
        }
      }
    }
  }

  final cuisine = item['cuisine']?.toString().trim();
  if (parts.isEmpty && cuisine != null && cuisine.isNotEmpty) return cuisine;

  return parts.join(' · ');
}

Widget checkoutLineImage(String? url, {double size = 56}) {
  final u = url?.trim() ?? '';
  if (u.startsWith('http://') || u.startsWith('https://')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        u,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _checkoutImagePlaceholder(size),
      ),
    );
  }
  if (u.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        u,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _checkoutImagePlaceholder(size),
      ),
    );
  }
  return _checkoutImagePlaceholder(size);
}

Widget _checkoutImagePlaceholder(double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(Icons.fastfood, color: Colors.grey.shade400, size: size * 0.4),
  );
}

class CheckoutOrderSumeryComponent extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final ValueChanged<int>? onSubtotalChanged;

  const CheckoutOrderSumeryComponent({
    super.key,
    required this.cartItems,
    this.onSubtotalChanged,
  });

  @override
  State<CheckoutOrderSumeryComponent> createState() => _CheckoutOrderSumeryComponentState();
}

class _CheckoutOrderSumeryComponentState extends State<CheckoutOrderSumeryComponent> {
  late List<int> _quantities;

  @override
  void initState() {
    super.initState();
    _quantities = List<int>.filled(widget.cartItems.length, 1);
    WidgetsBinding.instance.addPostFrameCallback((_) => _emitSubtotal());
  }

  @override
  void didUpdateWidget(CheckoutOrderSumeryComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartItems.length != widget.cartItems.length) {
      _quantities = List<int>.filled(widget.cartItems.length, 1);
      _emitSubtotal();
    }
  }

  int _computeSubtotal() {
    var s = 0;
    for (var i = 0; i < widget.cartItems.length; i++) {
      final q = i < _quantities.length ? _quantities[i] : 1;
      s += checkoutLineUnitRupees(widget.cartItems[i]) * q;
    }
    return s;
  }

  void _emitSubtotal() {
    widget.onSubtotalChanged?.call(_computeSubtotal());
  }

  void _onQtyChanged(int index, int value) {
    setState(() {
      while (_quantities.length <= index) {
        _quantities.add(1);
      }
      _quantities[index] = value;
    });
    _emitSubtotal();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cartItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Text(
          'No items in cart.',
          style: commonTextStyle(
            fontSize: 14,
            fontColor: HexColor.fromHex('#64748B'),
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        final title = checkoutLineTitle(item);
        final subtitle = checkoutLineSubtitle(item);
        final unit = checkoutLineUnitRupees(item);
        final qty = index < _quantities.length ? _quantities[index] : 1;
        final lineTotal = unit * qty;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20,top: 10,bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        checkoutLineImage(item['imageUrl']?.toString()),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                title,
                                style: commonTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  fontColor: HexColor.fromHex('#1D1D1D'),
                                ),
                              ),
                              if (subtitle.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: commonTextStyle(
                                    fontSize: 12,
                                    fontColor: Colors.grey.shade500,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      QuantityStepper(
                        key: ValueKey<String>('qty_${index}_$qty'),
                        initialValue: qty,
                        onChanged: (v) => _onQtyChanged(index, v),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '₹ $lineTotal',
                        style: commonTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontColor: blackFontColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.cartItems.length - 1 != index)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: DottedLinePainter(color: Colors.grey.shade300),
                ),
              ),
          ],
        );
      },
    );
  }
}
