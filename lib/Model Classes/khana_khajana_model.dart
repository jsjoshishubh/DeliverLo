class KhanaKhajanaResponseModel {
  bool? success;
  String? message;
  List<KhanaKhajanaVendorModel>? data;
  String? timestamp;

  KhanaKhajanaResponseModel({
    this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory KhanaKhajanaResponseModel.fromJson(Map<String, dynamic> json) {
    return KhanaKhajanaResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map>()
              .map((e) => KhanaKhajanaVendorModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <KhanaKhajanaVendorModel>[],
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }
}

class KhanaKhajanaVendorModel {
  String? id;
  String? storeName;
  String? offerTag;
  num? ratingAvg;
  int? deliveryEtaMinutesMin;
  int? deliveryEtaMinutesMax;
  List<KhanaKhajanaProductModel>? products;

  KhanaKhajanaVendorModel({
    this.id,
    this.storeName,
    this.offerTag,
    this.ratingAvg,
    this.deliveryEtaMinutesMin,
    this.deliveryEtaMinutesMax,
    this.products,
  });

  factory KhanaKhajanaVendorModel.fromJson(Map<String, dynamic> json) {
    return KhanaKhajanaVendorModel(
      id: json['id']?.toString() ?? '',
      storeName: json['storeName']?.toString() ?? '',
      offerTag: json['offerTag']?.toString() ?? '',
      ratingAvg: json['ratingAvg'] as num? ?? 0,
      deliveryEtaMinutesMin: (json['deliveryEtaMinutesMin'] as num?)?.toInt() ?? 0,
      deliveryEtaMinutesMax: (json['deliveryEtaMinutesMax'] as num?)?.toInt() ?? 0,
      products: json['products'] is List
          ? (json['products'] as List)
              .whereType<Map>()
              .map((e) => KhanaKhajanaProductModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <KhanaKhajanaProductModel>[],
    );
  }
}

class KhanaKhajanaProductModel {
  String? id;
  String? name;
  String? description;
  String? thumbnail;
  List<KhanaKhajanaVariantModel>? variants;
  KhanaKhajanaOfferModel? offer;

  KhanaKhajanaProductModel({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.variants,
    this.offer,
  });

  factory KhanaKhajanaProductModel.fromJson(Map<String, dynamic> json) {
    return KhanaKhajanaProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['shortDescription']?.toString().trim().isNotEmpty == true
          ? json['shortDescription']?.toString() ?? ''
          : json['description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      variants: json['variants'] is List
          ? (json['variants'] as List)
              .whereType<Map>()
              .map((e) => KhanaKhajanaVariantModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <KhanaKhajanaVariantModel>[],
      offer: json['offer'] is Map<String, dynamic>
          ? KhanaKhajanaOfferModel.fromJson(json['offer'] as Map<String, dynamic>)
          : null,
    );
  }
}

class KhanaKhajanaVariantModel {
  num? price;
  num? salePrice;
  String? displayName;

  KhanaKhajanaVariantModel({
    this.price,
    this.salePrice,
    this.displayName,
  });

  factory KhanaKhajanaVariantModel.fromJson(Map<String, dynamic> json) {
    return KhanaKhajanaVariantModel(
      price: json['price'] as num? ?? 0,
      salePrice: json['salePrice'] as num? ?? 0,
      displayName: json['displayName']?.toString() ?? '',
    );
  }
}

class KhanaKhajanaOfferModel {
  bool? hasOffer;
  num? minCompareAtPrice;
  num? minEffectivePrice;
  String? label;

  KhanaKhajanaOfferModel({
    this.hasOffer,
    this.minCompareAtPrice,
    this.minEffectivePrice,
    this.label,
  });

  factory KhanaKhajanaOfferModel.fromJson(Map<String, dynamic> json) {
    return KhanaKhajanaOfferModel(
      hasOffer: json['hasOffer'] == true,
      minCompareAtPrice: json['minCompareAtPrice'] as num? ?? 0,
      minEffectivePrice: json['minEffectivePrice'] as num? ?? 0,
      label: json['label']?.toString() ?? '',
    );
  }
}
