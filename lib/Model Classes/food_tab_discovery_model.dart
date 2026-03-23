import 'package:deliverylo/Models/food_item_model.dart';

class FoodTabDiscoveryResponseModel {
  bool? success;
  String? message;
  FoodTabDiscoveryDataModel? data;
  String? timestamp;

  FoodTabDiscoveryResponseModel({
    this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory FoodTabDiscoveryResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic dataField = json['data'];
    final dynamic metaField = json['meta'];
    final dataMap = <String, dynamic>{
      'items': dataField is List ? dataField : const <dynamic>[],
      'page': metaField is Map ? metaField['page'] : json['page'],
      'limit': metaField is Map ? metaField['limit'] : json['limit'],
      'total': metaField is Map ? metaField['total'] : json['total'],
    };

    return FoodTabDiscoveryResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: dataField is Map<String, dynamic>
          ? FoodTabDiscoveryDataModel.fromJson(dataField)
          : FoodTabDiscoveryDataModel.fromJson(dataMap),
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }
}

class FoodTabDiscoveryDataModel {
  List<FoodItemModel> items;
  int page;
  int limit;
  int total;

  FoodTabDiscoveryDataModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory FoodTabDiscoveryDataModel.fromJson(Map<String, dynamic> json) {
    final rawList = _firstList(json, const [
      'items',
      'products',
      'vendors',
      'results',
      'docs',
      'data',
    ]);

    final parsedItems = rawList
        .whereType<Map>()
        .map((e) => FoodItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return FoodTabDiscoveryDataModel(
      items: parsedItems,
      page: _toInt(json['page']) ?? 1,
      limit: _toInt(json['limit']) ?? parsedItems.length,
      total: _toInt(json['total']) ?? parsedItems.length,
    );
  }

  static List _firstList(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is List) return value;
    }
    return const [];
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
    }
}
