import 'dart:developer';

import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Https%20Requests/food_products_url_builder.dart';
import 'package:deliverylo/Model%20Classes/food_tab_discovery_model.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:get/get.dart';

DioClient dioClient = DioClient();

class MainHomePageController extends GetxController {
  final isLoading = false.obs;

  get loading => isLoading.value;

  void changeLoading(bool v) => isLoading.value = v;

  List<Map<String, dynamic>> popularItems = <Map<String, dynamic>>[];

  Future<void> getMainHomePopularItems() async {
    changeLoading(true);
    update();
    try {
      const categoryUrl = 'categories/whats-on-your-mind?vertical=food';
      final categoryRes = await dioClient.getRequest(categoryUrl);
      final categoryData = categoryRes.data;
      String subCategoryId = '';

      if (categoryData is Map<String, dynamic> && categoryData['data'] is List) {
        for (final raw in categoryData['data'] as List) {
          if (raw is! Map) continue;
          final id = (raw['_id'] ?? raw['id'] ?? '').toString().trim();
          final status = (raw['status'] ?? '').toString().toLowerCase().trim();
          if (id.isNotEmpty && (status.isEmpty || status == 'active')) {
            subCategoryId = id;
            break;
          }
        }
      }

      if (subCategoryId.isEmpty) {
        popularItems = <Map<String, dynamic>>[];
        return;
      }

      final productsUrl = buildFoodProductsSubCategoryUrl(
        subCategoryId: subCategoryId,
        page: 1,
        limit: 20,
      );
      final productsRes = await dioClient.getRequest(productsUrl);
      final productsData = productsRes.data;
      if (productsData is! Map<String, dynamic>) {
        popularItems = <Map<String, dynamic>>[];
        return;
      }

      final parsed = FoodTabDiscoveryResponseModel.fromJson(productsData);
      final items = parsed.data?.items ?? const <FoodItemModel>[];
      popularItems = items.map(_foodItemToSearchCardMap).toList();
    } catch (e) {
      log('Main home popular items error ---- $e');
      popularItems = <Map<String, dynamic>>[];
    } finally {
      changeLoading(false);
      update();
    }
  }

  Map<String, dynamic> _foodItemToSearchCardMap(FoodItemModel item) {
    final discount = item.discount.trim();
    final pct = item.offerPercentage;
    final amt = item.offerAmount;
    final offerBadge = pct != null && pct > 0
        ? '$pct% OFF'
        : (amt != null && amt > 0 ? (amt == amt.roundToDouble() ? '₹${amt.toInt()} OFF' : '₹${amt.toStringAsFixed(0)} OFF') : '');
    final p = item.price;
    final priceForTwo = (p == null || p <= 0)
        ? ''
        : (p == p.roundToDouble() ? '₹${p.toInt()} for two' : '₹${p.toStringAsFixed(0)} for two');
    return <String, dynamic>{
      'id': item.id,
      'vendorId': item.vendorId,
      'name': item.name,
      'cuisine': item.category,
      'dish': item.dish.trim().isNotEmpty ? item.dish : item.name,
      'location': item.location.trim(),
      'imageUrl': item.imageUrl,
      'rating': item.rating,
      'deliveryTime': item.deliveryTime.trim(),
      'price': item.price,
      'priceForTwo': priceForTwo,
      'deliveryFee': 'Free Fee',
      'isPureVeg': item.isPureVeg,
      'offerText': discount,
      'offerBadge': offerBadge,
    };
  }

}