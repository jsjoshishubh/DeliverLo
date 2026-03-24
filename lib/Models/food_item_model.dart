class FoodItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final String category;
  final String discount;
  final String vendorId;
  final String dish;
  final String location;
  final bool isPureVeg;
  final num? price;
  final int? offerPercentage;
  final num? offerAmount;

  FoodItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.category,
    required this.discount,
    this.vendorId = '',
    this.dish = '',
    this.location = '',
    this.isPureVeg = false,
    this.price,
    this.offerPercentage,
    this.offerAmount,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'] is Map ? Map<String, dynamic>.from(json['rating']) : const <String, dynamic>{};
    final categoryMap = json['categoryId'] is Map ? Map<String, dynamic>.from(json['categoryId']) : const <String, dynamic>{};
    final offerMap = json['offer'] is Map ? Map<String, dynamic>.from(json['offer']) : const <String, dynamic>{};
    final deliveryMap = json['delivery'] is Map ? Map<String, dynamic>.from(json['delivery']) : const <String, dynamic>{};
    final images = json['images'] is List ? List<dynamic>.from(json['images']) : const <dynamic>[];

    final discountLabel = _toString(
      json['discount'],
      fallback: _toString(
        json['offerText'],
        fallback: _toString(
          json['badgeText'],
          fallback: _toString(offerMap['label'], fallback: ''),
        ),
      ),
    );

    final priceVal = json['price'];
    num? priceNum;
    if (priceVal is num) {
      priceNum = priceVal;
    } else {
      priceNum = num.tryParse(_toString(priceVal));
    }

    return FoodItemModel(
      id: _toString(json['id'], fallback: _toString(json['_id'])),
      name: _toString(
        json['name'],
        fallback: _toString(json['title'], fallback: _toString(json['vendorName'], fallback: '')),
      ),
      imageUrl: _toString(
        json['imageUrl'],
        fallback: _toString(
          json['image'],
          fallback: _toString(
            json['thumbnail'],
            fallback: _toString(
              images.isNotEmpty ? images.first : null,
              fallback: _toString(json['logoUrl'], fallback: _toString(json['logo'])),
            ),
          ),
        ),
      ),
      rating: _toDouble(
        json['rating'],
        fallback: _toDouble(
          ratingMap['avg'],
          fallback: _toDouble(json['avgRating'], fallback: 0.0),
        ),
      ),
      deliveryTime: _toString(
        json['deliveryTime'],
        fallback: _toString(
          json['eta'],
          fallback: _toString(
            json['deliveryTimeText'],
            fallback: _buildEtaText(deliveryMap),
          ),
        ),
      ),
      category: _toString(
        json['category'],
        fallback: _toString(
          categoryMap['name'],
          fallback: _toString(
            json['cuisine'],
            fallback: _toString(json['categoryName'], fallback: ''),
          ),
        ),
      ),
      discount: discountLabel,
      vendorId: _toString(json['vendorId']),
      dish: _toString(json['dish']),
      location: _toString(json['location']),
      isPureVeg: json['isPureVeg'] == true,
      price: priceNum,
      offerPercentage: _toInt(offerMap['percentage']),
      offerAmount: offerMap['amount'] is num
          ? offerMap['amount'] as num
          : num.tryParse(_toString(offerMap['amount'])),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static String _toString(dynamic value, {String fallback = ''}) {
    final v = value?.toString().trim() ?? '';
    return v.isEmpty ? fallback : v;
  }

  static double _toDouble(dynamic value, {double fallback = 0.0}) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static String _buildEtaText(Map<String, dynamic> deliveryMap) {
    final minEta = _toString(deliveryMap['etaMinutesMin']);
    final maxEta = _toString(deliveryMap['etaMinutesMax']);
    if (minEta.isEmpty && maxEta.isEmpty) return '';
    if (minEta.isNotEmpty && maxEta.isNotEmpty) return '$minEta-$maxEta mins';
    final one = minEta.isNotEmpty ? minEta : maxEta;
    return '$one mins';
  }
}
