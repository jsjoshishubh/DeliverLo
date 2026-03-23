import 'dart:developer';
import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Model%20Classes/food_home_settings_model.dart';
import 'package:deliverylo/Model%20Classes/food_tab_discovery_model.dart';
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
  get loading => this.isLoading.value;
  void changeLoading(bool v) => this.isLoading.value = v;
  final Rxn<FoodHomeSettingsResponseModel> _foodHomeResponse = Rxn<FoodHomeSettingsResponseModel>();
  FoodHomeSettingsResponseModel? get foodHomeResponse => _foodHomeResponse.value;

  final RxList<FoodCategoryModel> categories = <FoodCategoryModel>[].obs;
  final RxList<HomeOfferBannerModel> homeOfferBanners = <HomeOfferBannerModel>[].obs;
  final Map<String, List<FoodItemModel>> _foodItemsByApiType = <String, List<FoodItemModel>>{};
  final Map<String, bool> _tabLoadingByApiType = <String, bool>{};
  final RxString _homeAccentHex = kFoodHomeAccentHex.obs;
  String get homeAccentHex => _homeAccentHex.value;
  List<FoodItemModel> foodItemsForTabType(String apiType) =>
      List<FoodItemModel>.from(_foodItemsByApiType[apiType] ?? const <FoodItemModel>[]);
  bool isTabLoading(String apiType) => _tabLoadingByApiType[apiType] == true;

  void setHomeAccentHex(String hexColor) {
    final next = hexColor.trim();
    if (next.isEmpty || next == _homeAccentHex.value) return;
    _homeAccentHex.value = next;
    update();
  }

  getCategoriesAndHomeOfferBanners()async{
    changeLoading(true);
    update();
    try{
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
    }finally{
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
}