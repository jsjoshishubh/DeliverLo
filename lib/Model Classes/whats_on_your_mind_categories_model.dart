class WhatsOnYourMindCategoriesResponseModel {
  bool? success;
  String? message;
  List<WhatsOnYourMindCategoryModel>? data;
  String? timestamp;

  WhatsOnYourMindCategoriesResponseModel({
    this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory WhatsOnYourMindCategoriesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<WhatsOnYourMindCategoryModel> parsed = _parseCategoryList(json['data']);

    return WhatsOnYourMindCategoriesResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: parsed,
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }

  static List<WhatsOnYourMindCategoryModel> _parseCategoryList(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => WhatsOnYourMindCategoryModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }
    if (raw is Map<String, dynamic>) {
      const keys = <String>[
        'categories',
        'items',
        'results',
        'docs',
        'data',
      ];
      for (final key in keys) {
        final inner = raw[key];
        if (inner is List) {
          return inner
              .whereType<Map>()
              .map((e) => WhatsOnYourMindCategoryModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList();
        }
      }
    }
    return <WhatsOnYourMindCategoryModel>[];
  }
}

class WhatsOnYourMindCategoryModel {
  String? id;
  String? name;
  String? slug;
  String? imageUrl;
  String? icon;
  String? status;
  int? sortOrder;

  WhatsOnYourMindCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.imageUrl,
    this.icon,
    this.status,
    this.sortOrder,
  });

  factory WhatsOnYourMindCategoryModel.fromJson(Map<String, dynamic> json) {
    final image = _firstNonEmptyString(<dynamic>[
      json['imageUrl'],
      json['image'],
      json['thumbnail'],
      json['coverImage'],
      json['icon'],
    ]);

    return WhatsOnYourMindCategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: image,
      icon: json['icon']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ??
          (json['order'] as num?)?.toInt(),
    );
  }

  /// Image suitable for [WhatsOnYourMindCategoryItem] (network URL or asset path).
  String get displayImage => (imageUrl ?? '').trim().isNotEmpty
      ? (imageUrl ?? '').trim()
      : (icon ?? '').trim();

  static String _firstNonEmptyString(List<dynamic> values) {
    for (final v in values) {
      final s = v?.toString().trim() ?? '';
      if (s.isNotEmpty) return s;
    }
    return '';
  }
}
