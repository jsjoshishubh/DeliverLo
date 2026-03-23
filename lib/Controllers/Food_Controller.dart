import 'dart:developer';
import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Model%20Classes/food_home_settings_model.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:get/get.dart';

DioClient dioClient = DioClient();

class FoodController extends GetxController {

  final isLoading = false.obs;
  get loading => this.isLoading.value;
  void changeLoading(bool v) => this.isLoading.value = v;
  final Rxn<FoodHomeSettingsResponseModel> _foodHomeResponse = Rxn<FoodHomeSettingsResponseModel>();
  FoodHomeSettingsResponseModel? get foodHomeResponse => _foodHomeResponse.value;

  final RxList<FoodCategoryModel> categories = <FoodCategoryModel>[].obs;
  final RxList<HomeOfferBannerModel> homeOfferBanners = <HomeOfferBannerModel>[].obs;
  final RxString _homeAccentHex = kFoodHomeAccentHex.obs;
  String get homeAccentHex => _homeAccentHex.value;

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
}