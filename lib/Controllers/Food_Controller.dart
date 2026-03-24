import 'dart:developer';
import 'package:deliverylo/Https%20Requests/dio_client.dart';
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

  List<Map<String, dynamic>> whatsOnYourMindFoodResults = <Map<String, dynamic>>[];
  bool whatsOnYourMindFoodResultsLoading = false;

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
  Future<void> getwhatsOnYourMindFoodResults(
    String categoryId, {
    double ratingMin = 0.0,
    String diet = 'all',
    bool offersOnly = false,
    String? sort,
    bool applyFilters = false,
  }) async {
    final id = categoryId.trim();
    if (id.isEmpty) return;

    whatsOnYourMindFoodResultsLoading = true;
    whatsOnYourMindFoodResults = <Map<String, dynamic>>[];
    update();

    try {
      final dietNorm = diet.trim().toLowerCase();
      var url =
          'products?subCategoryId=$id&type=food&page=1&limit=20&ratingMin=$ratingMin';
      if (dietNorm == 'veg' || dietNorm == 'non_veg') {
        url += '&diet=$dietNorm';
      }
      if (offersOnly) url += '&hasOffers=true';
      if (sort != null && sort.trim().isNotEmpty) {
        url += '&sort=${Uri.encodeQueryComponent(sort.trim())}';
      }
      if (applyFilters) url += '&filter=1';
      final response = await dioClient.getRequest(url);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final parsed = FoodTabDiscoveryResponseModel.fromJson(data);
        final items = parsed.data?.items ?? const <FoodItemModel>[];
        whatsOnYourMindFoodResults =
            items.map(_foodItemToWhatsOnMindResultMap).toList();
      } else {
        whatsOnYourMindFoodResults = <Map<String, dynamic>>[];
      }
    } catch (e) {
      log(e.toString());
      whatsOnYourMindFoodResults = <Map<String, dynamic>>[];
    } finally {
      whatsOnYourMindFoodResultsLoading = false;
      update();
    }
  }

  Map<String, dynamic> _foodItemToWhatsOnMindResultMap(FoodItemModel item) {
    final delivery = item.deliveryTime.trim().isNotEmpty
        ? item.deliveryTime.trim()
        : '20-30 min';
    return <String, dynamic>{
      'id': item.id,
      'name': item.name,
      'cuisine': item.category,
      'dish': item.name,
      'location': delivery,
      'imageUrl': item.imageUrl,
      'rating': item.rating,
      'deliveryTime': delivery,
      'deliveryFee': 'Free Fee',
      'isPureVeg': false,
      'offerText': item.discount,
    };
  }
}