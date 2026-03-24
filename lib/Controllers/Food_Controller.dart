import 'dart:developer';
import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Https%20Requests/food_products_url_builder.dart';
import 'package:deliverylo/Model%20Classes/food_home_settings_model.dart';
import 'package:deliverylo/Model%20Classes/food_tab_discovery_model.dart';
import 'package:deliverylo/Model%20Classes/khana_khajana_model.dart';
import 'package:deliverylo/Model%20Classes/whats_on_your_mind_categories_model.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

DioClient dioClient = DioClient();

class FoodController extends GetxController {
  static const String _selectedAddressStorageKey = 'food_selected_address';
  static const double _defaultLat = 24.5766363;
  static const double _defaultLng = 73.6853438;
  final GetStorage _storage = GetStorage();

  final isLoading = false.obs;
  get loading => isLoading.value;
  void changeLoading(bool v) => isLoading.value = v;
  final Rxn<FoodHomeSettingsResponseModel> _foodHomeResponse = Rxn<FoodHomeSettingsResponseModel>();
  FoodHomeSettingsResponseModel? get foodHomeResponse => _foodHomeResponse.value;

  final RxList<FoodCategoryModel> categories = <FoodCategoryModel>[].obs;
  final RxList<HomeOfferBannerModel> homeOfferBanners = <HomeOfferBannerModel>[].obs;
  final Rxn<KhanaKhajanaResponseModel> _khanaKhajanaResponse =
      Rxn<KhanaKhajanaResponseModel>();
  final Map<String, List<FoodItemModel>> _foodItemsByApiType = <String, List<FoodItemModel>>{};
  final Map<String, bool> _tabLoadingByApiType = <String, bool>{};
  final RxString _homeAccentHex = kFoodHomeAccentHex.obs;
  String get homeAccentHex => _homeAccentHex.value;
  KhanaKhajanaResponseModel? get khanaKhajanaResponse => _khanaKhajanaResponse.value;
  List<KhanaKhajanaVendorModel> get khanaKhajanaVendors =>
      List<KhanaKhajanaVendorModel>.from(_khanaKhajanaResponse.value?.data ?? const <KhanaKhajanaVendorModel>[]);
  List<FoodItemModel> foodItemsForTabType(String apiType) =>
      List<FoodItemModel>.from(_foodItemsByApiType[apiType] ?? const <FoodItemModel>[]);
  bool isTabLoading(String apiType) => _tabLoadingByApiType[apiType] == true;

  final RxList<WhatsOnYourMindCategoryModel> whatsOnYourMindCategories =
      <WhatsOnYourMindCategoryModel>[].obs;
  bool whatsOnYourMindCategoriesLoading = false;

  /// Products loaded for a "What's on your mind" subcategory (horizontal rail / full page).
  List<Map<String, dynamic>> foodProductsBySubCategoryResults = <Map<String, dynamic>>[];
  bool foodProductsBySubCategoryLoading = false;

  /// Text search on the food search delegate screen (`SearchDeligatePage`).
  List<Map<String, dynamic>> foodSearchResults = <Map<String, dynamic>>[];
  bool foodSearchResultsLoading = false;

  void setHomeAccentHex(String hexColor) {
    final next = hexColor.trim();
    if (next.isEmpty || next == _homeAccentHex.value) return;
    _homeAccentHex.value = next;
    update();
  }

  getCategoriesAndHomeOfferBanners() async {
    changeLoading(true);
    update();
    try {
      final url = 'settings';
      final response = await dioClient.getRequest(url);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        _foodHomeResponse.value = FoodHomeSettingsResponseModel.fromJson(data);

        final parsedCategories = _foodHomeResponse.value?.data?.categories ?? <FoodCategoryModel>[];
        final parsedBanners = _foodHomeResponse.value?.data?.homeOfferBanners ?? <HomeOfferBannerModel>[];

        // Keep only valid/usable categories.
        categories.assignAll(
          parsedCategories.where(
            (e) => (e.id ?? '').trim().isNotEmpty && (e.status ?? '').toLowerCase() == 'active',
          ),
        );

        // Keep only active banners with image URL.
        homeOfferBanners.assignAll(
          parsedBanners.where(
            (e) =>
                (e.id ?? '').trim().isNotEmpty &&
                (e.imageUrl ?? '').trim().isNotEmpty &&
                (e.isWithinSchedule ?? true),
          ),
        );
      } else {
        _foodHomeResponse.value = null;
        categories.clear();
        homeOfferBanners.clear();
      }
      update();
    }catch(e){
      log(e.toString());
      _foodHomeResponse.value = null;
      categories.clear();
      homeOfferBanners.clear();
      update();
    } finally {
      changeLoading(false);
      update();
    }
  }

  Future<void> getFoodDataByTab(String apiType, {bool forceRefresh = false}) async {
    final String normalizedType = apiType.trim().isEmpty ? 'highlight' : apiType.trim();
    if (!forceRefresh &&
        (_foodItemsByApiType[normalizedType]?.isNotEmpty ?? false || isTabLoading(normalizedType))) {
      return;
    }
    _tabLoadingByApiType[normalizedType] = true;
    update();
    try {
      final coords = _getSelectedAddressCoords();
      final String url =
          'products/discovery?type=$normalizedType&page=1&limit=20&lat=${coords.$1}&lng=${coords.$2}';
      final response = await dioClient.getRequest(url);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = FoodTabDiscoveryResponseModel.fromJson(data);
        _foodItemsByApiType[normalizedType] =
            List<FoodItemModel>.from(parsed.data?.items ?? const <FoodItemModel>[]);
      } else {
        _foodItemsByApiType[normalizedType] = <FoodItemModel>[];
      }
      update();
    } catch (e) {
      log(e.toString());
      _foodItemsByApiType[normalizedType] = <FoodItemModel>[];
      update();
    } finally {
      _tabLoadingByApiType[normalizedType] = false;
      update();
    }
  }

  Future<void> getFoodDataByTabTypes(List<String> apiTypes) async {
    final normalized = apiTypes.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    if (normalized.isEmpty) return;
    await Future.wait(normalized.map(getFoodDataByTab));
  }

  (double, double) _getSelectedAddressCoords() {
    final dynamic selectedAddress = _storage.read(_selectedAddressStorageKey);
    if (selectedAddress is! Map) return (_defaultLat, _defaultLng);
    final lat = _toDouble(selectedAddress['latitude']) ??
        _toDouble(selectedAddress['lat']) ??
        _defaultLat;
    final lng = _toDouble(selectedAddress['longitude']) ??
        _toDouble(selectedAddress['lng']) ??
        _defaultLng;
    return (lat, lng);
  }

  double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  Future<void> getKhanaKhajanaData() async {
    changeLoading(true);
    update();
    try {
      final url = 'users/featured-vendors';
      final response = await dioClient.getRequest(url);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        _khanaKhajanaResponse.value = KhanaKhajanaResponseModel.fromJson(data);
      } else {
        _khanaKhajanaResponse.value = null;
      }
      update();
    } catch (e) {
      log(e.toString());
      _khanaKhajanaResponse.value = null;
      update();
    } finally {
      changeLoading(false);
      update();
    }
  }

  Future<void> getwhatsOnYourMindCategories() async {
    whatsOnYourMindCategoriesLoading = true;
    update();
    try {
      const url = 'categories/whats-on-your-mind?vertical=food';
      final response = await dioClient.getRequest(url);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = WhatsOnYourMindCategoriesResponseModel.fromJson(data);
        final list = parsed.data ?? <WhatsOnYourMindCategoryModel>[];
        whatsOnYourMindCategories.assignAll(
          list.where(
            (e) =>
                (e.id ?? '').trim().isNotEmpty &&
                (e.name ?? '').trim().isNotEmpty &&
                ((e.status ?? '').trim().isEmpty ||
                    (e.status ?? '').toLowerCase() == 'active'),
          ),
        );
      } else {
        whatsOnYourMindCategories.clear();
      }
    } catch (e) {
      log(e.toString());
      whatsOnYourMindCategories.clear();
    } finally {
      whatsOnYourMindCategoriesLoading = false;
      update();
    }
  }
  /// Loads food products for a selected "What's on your mind" subcategory.
  Future<void> fetchFoodProductsBySubCategory(
    String categoryId, {
    double ratingMin = 0.0,
    String diet = 'all',
    bool offersOnly = false,
    String? sort,
    bool applyFilters = false,
  }) async {
    final id = categoryId.trim();
    if (id.isEmpty) return;

    foodProductsBySubCategoryLoading = true;
    foodProductsBySubCategoryResults = <Map<String, dynamic>>[];
    update();

    try {
      final url = buildFoodProductsSubCategoryUrl(
        subCategoryId: id,
        page: 1,
        limit: 20,
        ratingMin: ratingMin,
        diet: diet,
        offersOnly: offersOnly,
        sort: sort,
        applyFilters: applyFilters,
      );
      final response = await dioClient.getRequest(url);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = FoodTabDiscoveryResponseModel.fromJson(data);
        final items = parsed.data?.items ?? const <FoodItemModel>[];
        foodProductsBySubCategoryResults =
            items.map(_foodItemToSearchCardMap).toList();
      } else {
        foodProductsBySubCategoryResults = <Map<String, dynamic>>[];
      }
    } catch (e) {
      log(e.toString());
      foodProductsBySubCategoryResults = <Map<String, dynamic>>[];
    } finally {
      foodProductsBySubCategoryLoading = false;
      update();
    }
  }

  /// Food search for [SearchDeligatePage]. Uses [buildFoodProductsSearchUrl] (`search` param).
  Future<void> searchFoodProducts(
    String query, {
    double ratingMin = 0.0,
    String diet = 'all',
    bool offersOnly = false,
    String? sort,
    bool applyFilters = false,
  }) async {
    final q = query.trim();
    if (q.isEmpty) {
      foodSearchResults = <Map<String, dynamic>>[];
      foodSearchResultsLoading = false;
      update();
      return;
    }

    foodSearchResultsLoading = true;
    foodSearchResults = <Map<String, dynamic>>[];
    update();

    try {
      final url = buildFoodProductsSearchUrl(
        searchTerm: q,
        page: 1,
        limit: 20,
        ratingMin: ratingMin,
        diet: diet,
        offersOnly: offersOnly,
        sort: sort,
        applyFilters: applyFilters,
      );
      final response = await dioClient.getRequest(url);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = FoodTabDiscoveryResponseModel.fromJson(data);
        final items = parsed.data?.items ?? const <FoodItemModel>[];
        foodSearchResults = items.map(_foodItemToSearchCardMap).toList();
      } else {
        foodSearchResults = <Map<String, dynamic>>[];
      }
    } catch (e) {
      log(e.toString());
      foodSearchResults = <Map<String, dynamic>>[];
    } finally {
      foodSearchResultsLoading = false;
      update();
    }
  }

  Map<String, dynamic> _foodItemToSearchCardMap(FoodItemModel item) {
    final deliveryRaw = item.deliveryTime.trim();
    final locationRaw = item.location.trim();
    final discount = item.discount.trim();

    String offerBadge = '';
    final int? pct = item.offerPercentage;
    final num? amt = item.offerAmount;
    final bool hasPct = pct != null && pct > 0;
    final bool hasAmt = amt != null && amt > 0;
    if (hasPct) {
      offerBadge = '$pct% OFF';
    } else if (hasAmt) {
      final num a = amt;
      offerBadge =
          a == a.roundToDouble() ? '₹${a.toInt()} OFF' : '₹${a.toStringAsFixed(0)} OFF';
    }

    String priceForTwo = '';
    if (item.price != null && item.price! > 0) {
      final p = item.price!;
      priceForTwo = p == p.roundToDouble() ? '₹${p.toInt()} for two' : '₹${p.toStringAsFixed(0)} for two';
    }

    return <String, dynamic>{
      'id': item.id,
      'vendorId': item.vendorId,
      'name': item.name,
      'cuisine': item.category,
      'dish': item.dish.trim().isNotEmpty ? item.dish : item.name,
      'location': locationRaw,
      'imageUrl': item.imageUrl,
      'rating': item.rating,
      'deliveryTime': deliveryRaw,
      'price': item.price,
      'priceForTwo': priceForTwo,
      'deliveryFee': 'Free Fee',
      'isPureVeg': item.isPureVeg,
      'offerText': discount,
      'offerBadge': offerBadge,
    };
  }
}