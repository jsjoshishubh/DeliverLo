import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_home_cart_utils.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_item_detailed_bottom_bar.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class GroceryYouMightNeedSection extends StatefulWidget {
  const GroceryYouMightNeedSection({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  State<GroceryYouMightNeedSection> createState() => _GroceryYouMightNeedSectionState();
}

class _GroceryYouMightNeedSectionState extends State<GroceryYouMightNeedSection> {
  final GetStorage _storage = GetStorage();

  /// Product keys from this section that already have a line in the cart.
  Set<String> _addedKeys = {};

  @override
  void initState() {
    super.initState();
    _addedKeys = _keysInCartForSection();
    _storage.listenKey(GroceryHomeCartUtils.checkoutCartStorageKey, (dynamic _) {
      if (!mounted) return;
      setState(() => _addedKeys = _keysInCartForSection());
    });
  }

  Set<String> get _sectionKeySet =>
      widget.items.map(GroceryHomeCartUtils.itemKey).toSet();

  Set<String> _keysInCartForSection() {
    return GroceryHomeCartUtils.keysInCartForSection(_storage, _sectionKeySet);
  }

  Future<void> _openItemDetailsBottomSheet(Map<String, dynamic> item) async {
    await showCommonBottomSheet(
      context: context,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.78,
        child: GroceryItemDetailedBottomBarComponent(
          item: item,
          onAddToCart: (customizedItem) {
            Navigator.of(context).pop();
            GroceryHomeCartUtils.mergeOrAppendCartItem(_storage, customizedItem);
            setState(() => _addedKeys = _keysInCartForSection());
          },
        ),
      ),
    );
  }

  void _quickAddFromCard(Map<String, dynamic> item) {
    final key = GroceryHomeCartUtils.itemKey(item);
    if (_addedKeys.contains(key)) return;

    final unit = GroceryHomeCartUtils.parseRupee(item['price']);
    final customized = Map<String, dynamic>.from(item)
      ..['quantityCount'] = 1
      ..['totalPrice'] = unit
      ..['totalPriceFormatted'] = GroceryHomeCartUtils.formatRupee(unit);

    GroceryHomeCartUtils.mergeOrAppendCartItem(_storage, customized);
    setState(() => _addedKeys = _keysInCartForSection());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: HexColor.fromHex('#EDF5F0'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'You might need',
              style: commonTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontColor: blackFontColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 255,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final key = GroceryHomeCartUtils.itemKey(item);
                final isAdded = _addedKeys.contains(key);
                return _GroceryNeedCard(
                  item: item,
                  isAdded: isAdded,
                  onCardTap: () => _openItemDetailsBottomSheet(item),
                  onAddTap: isAdded ? null : () => _quickAddFromCard(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GroceryNeedCard extends StatelessWidget {
  const _GroceryNeedCard({
    required this.item,
    required this.isAdded,
    required this.onCardTap,
    required this.onAddTap,
  });

  final Map<String, dynamic> item;
  final bool isAdded;
  final VoidCallback onCardTap;
  /// Null when already added — button shows "ADDED" and is disabled.
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item['imageUrl'] as String? ?? '';
    final quantity = item['quantity'] as String? ?? '';
    final name = item['name'] as String? ?? '';
    final price = item['price'] as String? ?? '';
    final oldPrice = item['oldPrice'] as String? ?? '';

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HexColor.fromHex('#E5E7EB')),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack height includes overlap so the ADD chip stays inside hit-test bounds
          // (Positioned with negative bottom was outside the 150px stack and taps were lost).
          SizedBox(
            height: 162,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                GestureDetector(
                  onTap: onCardTap,
                  behavior: HitTestBehavior.opaque,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 150,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.local_grocery_store),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onAddTap,
                      borderRadius: BorderRadius.circular(10),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: isAdded ? HexColor.fromHex('#F0FDF4') : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isAdded ? HexColor.fromHex('#86EFAC') : HexColor.fromHex('#22C55E'),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          child: Text(
                            isAdded ? 'ADDED' : 'ADD',
                            style: commonTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontColor: isAdded ? HexColor.fromHex('#166534') : HexColor.fromHex('#22C55E'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: onCardTap,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quantity,
                  style: commonTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontColor: greyFontColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: commonTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontColor: blackFontColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: commonTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontColor: blackFontColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      oldPrice,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: HexColor.fromHex('#9CA3AF'),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
