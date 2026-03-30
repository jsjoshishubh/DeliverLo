import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// Grocery product detail bottom sheet (static listing data — no product API).
class GroceryItemDetailedBottomBarComponent extends StatefulWidget {
  const GroceryItemDetailedBottomBarComponent({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  final Map<String, dynamic> item;
  final void Function(Map<String, dynamic> customizedItem) onAddToCart;

  @override
  State<GroceryItemDetailedBottomBarComponent> createState() =>
      _GroceryItemDetailedBottomBarComponentState();
}

class _GroceryItemDetailedBottomBarComponentState
    extends State<GroceryItemDetailedBottomBarComponent> {
  late int _qty;

  static final Color _accent = HexColor.fromHex('#15803D');
  static final Color _accentLight = HexColor.fromHex('#DCFCE7');
  static final Color _surfaceMuted = HexColor.fromHex('#F8FAFC');
  static final Color _textMuted = HexColor.fromHex('#64748B');

  @override
  void initState() {
    super.initState();
    _qty = 1;
  }

  double _parseRupee(dynamic v) {
    final s = v?.toString() ?? '0';
    final m = RegExp(r'[0-9]+(\.?[0-9]+)?').firstMatch(s);
    return double.tryParse(m?.group(0) ?? '0') ?? 0;
  }

  String get _imageUrl => (widget.item['imageUrl'] ?? '').toString();

  String get _pack => (widget.item['quantity'] ?? '').toString();

  String get _title => (widget.item['name'] ?? 'Item').toString();

  String get _priceLabel => (widget.item['price'] ?? '₹0').toString();

  String get _oldPriceLabel => (widget.item['oldPrice'] ?? '').toString();

  int? get _savingsPercent {
    final oldP = _parseRupee(widget.item['oldPrice']);
    final newP = _unitPrice;
    if (oldP <= 0 || newP >= oldP) return null;
    return ((1 - newP / oldP) * 100).round();
  }

  String get _description {
    final d = widget.item['description']?.toString().trim();
    if (d != null && d.isNotEmpty) return d;
    final pack = _pack;
    if (pack.isNotEmpty) {
      return 'Quality grocery — $pack. Fresh stock, fast delivery to your doorstep.';
    }
    return 'Quality grocery essentials. Fresh stock, fast delivery to your doorstep.';
  }

  double get _unitPrice => _parseRupee(widget.item['price']);

  double get _totalPrice => _unitPrice * _qty;

  String _formatTotal() {
    final t = _totalPrice;
    if (t == t.roundToDouble()) return '₹${t.round()}';
    return '₹${t.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final isNetwork = _imageUrl.startsWith('http');
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final savings = _savingsPercent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: HexColor.fromHex('#E2E8F0'),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: AspectRatio(
                            aspectRatio: 1.9,
                            child: isNetwork
                                ? Image.network(
                                    _imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => _imagePlaceholder(),
                                  )
                                : (_imageUrl.isNotEmpty
                                    ? Image.asset(
                                        _imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => _imagePlaceholder(),
                                      )
                                    : _imagePlaceholder()),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.eco_outlined, size: 15, color: _accent),
                                const SizedBox(width: 4),
                                Text(
                                  'Fresh',
                                  style: commonTextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontColor: _accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (savings != null && savings > 0)
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color:_accent,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:_accent.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                '$savings% OFF',
                                style: commonTextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  fontColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  _title,
                  style: commonTextStyle(
                    fontColor: blackFontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ).copyWith(height: 1.2),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(
                      icon: Icons.scale_outlined,
                      label: _pack.isNotEmpty ? _pack : 'Standard pack',
                      emphasized: true,
                    ),
                    _chip(
                      icon: Icons.storefront_outlined,
                      label: 'Grocery',
                      emphasized: false,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _priceLabel,
                      style: commonTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontColor: _accent,
                      ),
                    ),
                    if (_oldPriceLabel.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          _oldPriceLabel,
                          style: commonTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontColor: _textMuted,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _surfaceMuted,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: HexColor.fromHex('#E2E8F0')),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, size: 18, color: _textMuted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _description,
                          style: commonTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontColor: HexColor.fromHex('#475569'),
                          ).copyWith(height: 1.45),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Quantity',
                  style: commonTextStyle(
                    fontColor: blackFontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _qtyButton(
                        icon: Icons.remove_rounded,
                        enabled: _qty > 1,
                        onTap: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Text(
                          '$_qty',
                          style: commonTextStyle(
                            fontColor: HexColor.fromHex('#0F172A'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _qtyButton(
                        icon: Icons.add_rounded,
                        enabled: true,
                        onTap: () => setState(() => _qty++),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Divider(color: greyFontColor.withOpacity(0.2),height: 1,),
        ),
        Material(
          elevation: 12,
          shadowColor: Colors.black.withValues(alpha: 0.12),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 16 + bottomInset),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     
                      Text(
                        'Total',
                        style: commonTextStyle(
                          fontColor: greyFontColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ).copyWith(letterSpacing: 0.3),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTotal(),
                        style: commonTextStyle(
                          fontColor: HexColor.fromHex('#0F172A'),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (_qty > 1)
                        Text(
                          '$_qty × $_priceLabel',
                          style: commonTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontColor: _textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final customized = Map<String, dynamic>.from(widget.item)
                        ..['quantityCount'] = _qty
                        ..['totalPrice'] = _totalPrice
                        ..['totalPriceFormatted'] = _formatTotal();
                      widget.onAddToCart(customized);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_accent, HexColor.fromHex('#0F766E')],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Add to cart',
                              style: commonTextStyle(
                                fontColor: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: HexColor.fromHex('#F1F5F9'),
      child: Icon(Icons.local_grocery_store_rounded, color: HexColor.fromHex('#94A3B8'), size: 56),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required bool emphasized,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: emphasized ? _accentLight : _surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: emphasized ? _accent.withValues(alpha: 0.25) : HexColor.fromHex('#E2E8F0'),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: emphasized ? _accent : _textMuted),
          const SizedBox(width: 6),
          Text(
            label,
            style: commonTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontColor: emphasized ? _accent : _textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.5),
            border: Border.all(
              color: enabled ? _accent.withValues(alpha: 0.35) : HexColor.fromHex('#CBD5E1'),
              width: 1.0,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            width: 30,
            height: 44,
            child: Icon(
              icon,
              color: enabled ? _accent : HexColor.fromHex('#CBD5E1'),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
