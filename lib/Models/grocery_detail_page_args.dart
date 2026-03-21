import 'package:deliverylo/Models/food_item_model.dart';

/// Arguments passed via `Get.toNamed(Routes.GROCERY_DETAIL_PAGE, arguments: ...)`.
class GroceryDetailPageArgs {
  const GroceryDetailPageArgs({
    required this.imagePath,
    required this.title,
    this.subtitle,
    this.priceText,
    this.unitLabel,
    this.description,
    this.rating,
    this.reviewCount,
    this.offerText,
    this.badgeText,
  });

  /// Asset path (e.g. `Assets/Extras/foo.png`) or `http(s)` URL.
  final String imagePath;
  final String title;
  final String? subtitle;
  final String? priceText;
  final String? unitLabel;
  final String? description;
  final double? rating;
  final int? reviewCount;
  /// e.g. "FLAT 125 OFF" from search cards.
  final String? offerText;
  /// e.g. "FARM FRESH" — pill badge with green dot (shown before rating).
  final String? badgeText;

  bool get isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  factory GroceryDetailPageArgs.fromFoodItem(FoodItemModel item) {
    return GroceryDetailPageArgs(
      imagePath: item.imageUrl,
      title: item.name,
      subtitle: '${item.category} • ${item.deliveryTime}',
      description: item.discount.isNotEmpty ? item.discount : null,
      rating: item.rating,
    );
  }

  factory GroceryDetailPageArgs.fromKhanaMap(Map<String, dynamic> item) {
    return GroceryDetailPageArgs(
      imagePath: item['image'] as String,
      title: item['name'] as String,
      subtitle: item['description'] as String?,
      priceText: '₹${item['discountedPrice']}',
      unitLabel: 'per item',
      description:
          'Was ₹${item['originalPrice']} — fresh and ready to order.',
      rating: (item['rating'] as num).toDouble(),
    );
  }

  factory GroceryDetailPageArgs.fromWhatsOnMindMap(Map<String, dynamic> item) {
    final offer = item['offerText'] as String?;
    final meta = <String>[];
    if (item['deliveryTime'] != null) {
      meta.add(item['deliveryTime'] as String);
    }
    if (item['deliveryFee'] != null) {
      meta.add(item['deliveryFee'] as String);
    }
    return GroceryDetailPageArgs(
      imagePath: item['imageUrl'] as String,
      title: item['name'] as String,
      subtitle:
          '${item['cuisine']} • ${item['dish']}, ${item['location']}',
      description: meta.isEmpty ? null : meta.join(' • '),
      rating: (item['rating'] as num?)?.toDouble(),
      offerText: offer?.isNotEmpty == true ? offer : null,
    );
  }

  /// When the route is opened without arguments (e.g. deep link).
  static GroceryDetailPageArgs fallback() {
    return const GroceryDetailPageArgs(
      imagePath: 'Assets/Extras/grocery_lowest_prices_1.png',
      title: 'Fresh Organic Avocados',
      subtitle: 'Origin: California, USA',
      priceText: '₹240',
      unitLabel: 'per kg',
      description:
          'Creamy, buttery and rich in healthy fats, our organic avocados are hand-picked at peak ripeness.',
      rating: 5.0,
      reviewCount: 128,
      offerText: null,
      badgeText: 'FARM FRESH',
    );
  }
}
