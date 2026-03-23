class FoodHomeSettingsResponseModel {
  bool? success;
  String? message;
  FoodHomeSettingsDataModel? data;
  String? timestamp;

  FoodHomeSettingsResponseModel({
    this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory FoodHomeSettingsResponseModel.fromJson(Map<String, dynamic> json) =>
      FoodHomeSettingsResponseModel(
        success: json['success'] ?? false,
        message: json['message']?.toString() ?? '',
        data: json['data'] is Map<String, dynamic>
            ? FoodHomeSettingsDataModel.fromJson(json['data'])
            : null,
        timestamp: json['timestamp']?.toString() ?? '',
      );
}

class FoodHomeSettingsDataModel {
  String? id;
  bool? codEnabled;
  num? deliveryRadiusKm;
  num? deliveryFee;
  num? minOrderAmount;
  num? taxPercent;
  String? createdAt;
  String? updatedAt;
  List<HomeOfferBannerModel>? homeOfferBanners;
  List<FoodCategoryModel>? categories;

  FoodHomeSettingsDataModel({
    this.id,
    this.codEnabled,
    this.deliveryRadiusKm,
    this.deliveryFee,
    this.minOrderAmount,
    this.taxPercent,
    this.createdAt,
    this.updatedAt,
    this.homeOfferBanners,
    this.categories,
  });

  factory FoodHomeSettingsDataModel.fromJson(Map<String, dynamic> json) =>
      FoodHomeSettingsDataModel(
        id: json['_id']?.toString() ?? '',
        codEnabled: json['codEnabled'] ?? false,
        deliveryRadiusKm: json['deliveryRadiusKm'] ?? 0,
        deliveryFee: json['deliveryFee'] ?? 0,
        minOrderAmount: json['minOrderAmount'] ?? 0,
        taxPercent: json['taxPercent'] ?? 0,
        createdAt: json['createdAt']?.toString() ?? '',
        updatedAt: json['updatedAt']?.toString() ?? '',
        homeOfferBanners: json['homeOfferBanners'] is List
            ? (json['homeOfferBanners'] as List)
                .map((e) => HomeOfferBannerModel.fromJson(
                    (e is Map<String, dynamic>) ? e : <String, dynamic>{}))
                .toList()
            : <HomeOfferBannerModel>[],
        categories: json['categories'] is List
            ? (json['categories'] as List)
                .map((e) => FoodCategoryModel.fromJson(
                    (e is Map<String, dynamic>) ? e : <String, dynamic>{}))
                .toList()
            : <FoodCategoryModel>[],
      );
}

class HomeOfferBannerModel {
  String? id;
  String? rootCategoryId;
  int? sortOrder;
  String? backgroundColor;
  String? title;
  String? subtitleLeft;
  String? subtitleRight;
  String? imageUrl;
  String? badgeText;
  String? ctaLabel;
  String? ctaUrl;
  String? linkType;
  String? action;
  String? linkVendorId;
  String? linkOfferId;
  bool? noExpire;
  String? validFrom;
  String? validTo;
  HomeOfferBannerDeepLinkModel? deepLink;
  bool? isWithinSchedule;

  HomeOfferBannerModel({
    this.id,
    this.rootCategoryId,
    this.sortOrder,
    this.backgroundColor,
    this.title,
    this.subtitleLeft,
    this.subtitleRight,
    this.imageUrl,
    this.badgeText,
    this.ctaLabel,
    this.ctaUrl,
    this.linkType,
    this.action,
    this.linkVendorId,
    this.linkOfferId,
    this.noExpire,
    this.validFrom,
    this.validTo,
    this.deepLink,
    this.isWithinSchedule,
  });

  factory HomeOfferBannerModel.fromJson(Map<String, dynamic> json) =>
      HomeOfferBannerModel(
        id: json['id']?.toString() ?? '',
        rootCategoryId: json['rootCategoryId']?.toString() ?? '',
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
        backgroundColor: json['backgroundColor']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        subtitleLeft: json['subtitleLeft']?.toString() ?? '',
        subtitleRight: json['subtitleRight']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        badgeText: json['badgeText']?.toString() ?? '',
        ctaLabel: json['ctaLabel']?.toString() ?? '',
        ctaUrl: json['ctaUrl']?.toString() ?? '',
        linkType: json['linkType']?.toString() ?? '',
        action: json['action']?.toString() ?? '',
        linkVendorId: json['linkVendorId']?.toString() ?? '',
        linkOfferId: json['linkOfferId']?.toString() ?? '',
        noExpire: json['noExpire'] ?? false,
        validFrom: json['validFrom']?.toString() ?? '',
        validTo: json['validTo']?.toString() ?? '',
        deepLink: json['deepLink'] is Map<String, dynamic>
            ? HomeOfferBannerDeepLinkModel.fromJson(json['deepLink'])
            : null,
        isWithinSchedule: json['isWithinSchedule'] ?? false,
      );
}

class HomeOfferBannerDeepLinkModel {
  String? kind;
  String? vendorId;

  HomeOfferBannerDeepLinkModel({this.kind, this.vendorId});

  factory HomeOfferBannerDeepLinkModel.fromJson(Map<String, dynamic> json) =>
      HomeOfferBannerDeepLinkModel(
        kind: json['kind']?.toString() ?? '',
        vendorId: json['vendorId']?.toString() ?? '',
      );
}

class FoodCategoryModel {
  String? id;
  String? name;
  String? slug;
  String? parentId;
  String? icon;
  String? imageUrl;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  FoodCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.parentId,
    this.icon,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) =>
      FoodCategoryModel(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        slug: json['slug']?.toString() ?? '',
        parentId: json['parentId']?.toString() ?? '',
        icon: json['icon']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        createdAt: json['createdAt']?.toString() ?? '',
        updatedAt: json['updatedAt']?.toString() ?? '',
        v: (json['__v'] as num?)?.toInt() ?? 0,
      );
}
