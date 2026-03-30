import 'package:deliverylo/Utils/utils.dart';
import 'package:get_storage/get_storage.dart';

/// Shared cart helpers for grocery home sections ("You might need", "Lowest prices", etc.).
class GroceryHomeCartUtils {
  GroceryHomeCartUtils._();

  static const String checkoutCartStorageKey = 'checkout_cart_items';

  static String itemKey(Map<String, dynamic> item) {
    final id = item['id']?.toString().trim() ?? '';
    if (id.isNotEmpty) return id;
    return '${item['name']}|${item['imageUrl']}';
  }

  static Set<String> keysInCartForSection(
    GetStorage storage,
    Set<String> allowedKeys,
  ) {
    final raw = storage.read(checkoutCartStorageKey);
    final out = <String>{};
    if (raw is! List) return out;
    for (final e in raw) {
      if (e is! Map) continue;
      final k = itemKey(Map<String, dynamic>.from(e));
      if (allowedKeys.contains(k)) out.add(k);
    }
    return out;
  }

  static List<Map<String, dynamic>> readCartList(GetStorage storage) {
    final raw = storage.read(checkoutCartStorageKey);
    final cart = <Map<String, dynamic>>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map) cart.add(Map<String, dynamic>.from(e));
      }
    }
    return cart;
  }

  static int lineQty(Map<String, dynamic> m) {
    final qc = m['quantityCount'];
    if (qc is int && qc > 0) return qc;
    if (qc is num && qc > 0) return qc.toInt();
    final q = m['quantity'];
    if (q is int && q > 0) return q;
    if (q is num && q > 0) return q.toInt();
    return 1;
  }

  static int incomingQty(Map<String, dynamic> m) {
    final qc = m['quantityCount'];
    if (qc is int && qc > 0) return qc;
    if (qc is num && qc > 0) return qc.toInt();
    return 1;
  }

  static String formatRupee(double v) {
    if (v == v.roundToDouble()) return '₹${v.round()}';
    return '₹${v.toStringAsFixed(0)}';
  }

  static double parseRupee(dynamic v) {
    final s = v?.toString() ?? '0';
    final m = RegExp(r'[0-9]+(\.?[0-9]+)?').firstMatch(s);
    return double.tryParse(m?.group(0) ?? '0') ?? 0;
  }

  static void mergeOrAppendCartItem(
    GetStorage storage,
    Map<String, dynamic> incoming,
  ) {
    final cart = readCartList(storage);
    final key = itemKey(incoming);
    final addQty = incomingQty(incoming);

    final idx = cart.indexWhere((e) => itemKey(e) == key);
    if (idx >= 0) {
      final row = Map<String, dynamic>.from(cart[idx]);
      final u = parseRupee(row['price']);
      final nextQty = lineQty(row) + addQty;
      final total = u * nextQty;
      row['quantityCount'] = nextQty;
      row['totalPrice'] = total;
      row['totalPriceFormatted'] = formatRupee(total);
      cart[idx] = row;
    } else {
      cart.add(Map<String, dynamic>.from(incoming));
    }

    storage.write(checkoutCartStorageKey, cart);
    toastWidget('Item added to cart', false);
  }
}
