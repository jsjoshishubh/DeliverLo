import 'dart:developer';

import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

DioClient dioClient = DioClient();

class ProfileController extends GetxController {
  final RxList<dynamic> _savedAddresses = [].obs;
  List<dynamic> get savedAddresses => _savedAddresses;
  final RxMap<String, dynamic> _userProfileData = <String, dynamic>{}.obs;
  Map<String, dynamic> get userProfileData => _userProfileData;

  final isLoading = false.obs;
  get loading => this.isLoading.value;
  void changeLoading(bool v) => this.isLoading.value = v;

  final TextEditingController flatController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final isFetchingLocation = false.obs;
  final selectedSaveAs = 'Home'.obs;
  final otherPlaceName = 'Other'.obs;
  final latitude = RxnDouble();
  final longitude = RxnDouble();
  final Dio _googleDio = Dio();


  getAddresses()async{
    try{
      changeLoading(true);
      update();
      final url = 'addresses';
      final response = await dioClient.getRequest(url);
      log('getAddresses response ---- ${response}');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final dynamic list = data['data'];
        if (list is List) {
          _savedAddresses.assignAll(list);
        } else {
          _savedAddresses.clear();
        }
      } else {
        _savedAddresses.clear();
      }
      changeLoading(false);
      update();
    }catch(e){
      log(e.toString());
      _savedAddresses.clear();
      changeLoading(false);
      update();
    }
  }

  Future<void> fetchCurrentLocationAndFillAddress() async {
    if (isFetchingLocation.value) return;
    isFetchingLocation.value = true;
    try {
      final addressData = await fetchCurrentFormattedAddress();
      final formattedAddress = (addressData['formatted_address'] ?? '').toString();
      latitude.value = addressData['latitude'] as double?;
      longitude.value = addressData['longitude'] as double?;
      fullAddressController.text = formattedAddress;
      fillFieldsFromFormattedAddress(formattedAddress);
      cityController.text = (addressData['city'] ?? '').toString().trim();
      stateController.text = (addressData['state'] ?? '').toString().trim();
      pincodeController.text = (addressData['pincode'] ?? '').toString().trim();
      if (phoneController.text.trim().isEmpty) {
        final storage = GetStorage();
        phoneController.text = (storage.read('mobile') ?? '').toString().trim();
      }
      toastWidget('Current location fetched successfully');
    } catch (e) {
      showSnackNotification(
        message: e.toString().replaceFirst('Exception: ', ''),
        hasError: true,
      );
    } finally {
      isFetchingLocation.value = false;
      update();
    }
  }

  void fillFieldsFromFormattedAddress(String formattedAddress) {
    if (formattedAddress.trim().isEmpty) return;
    final addressParts = formattedAddress
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    if (addressParts.isEmpty) return;
    flatController.text = addressParts.first;
    areaController.text =
        addressParts.length > 1 ? addressParts.sublist(1).join(', ') : '';
    update();
  }

  List<dynamic> addressSearchResults = <dynamic>[];
  bool isSearchingAddress = false;

  Future<void> searchGoogleAddresses(String query) async {
    final normalized = query.trim();
    if (normalized.length < 2) {
      addressSearchResults = <dynamic>[];
      update();
      return;
    }
    try {
      isSearchingAddress = true;
      update();
      final response = await _googleDio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': normalized,
          'key': googleMpaKey,
          'components': 'country:in',
        },
      );
      final data = response.data;
      final status = (data['status'] ?? '').toString();
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        throw Exception('Unable to fetch address suggestions');
      }
      final predictions = (data['predictions'] is List)
          ? List<dynamic>.from(data['predictions'] as List)
          : <dynamic>[];
      addressSearchResults = predictions;
    } catch (e) {
      addressSearchResults = <dynamic>[];
      showSnackNotification(
        message: e.toString().replaceFirst('Exception: ', ''),
        hasError: true,
      );
    } finally {
      isSearchingAddress = false;
      update();
    }
  }

  Future<Map<String, dynamic>?> getAddressDetailsFromPlaceId(String placeId) async {
    if (placeId.trim().isEmpty) return null;
    try {
      final response = await _googleDio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': googleMpaKey,
          'fields': 'formatted_address,address_components,geometry/location,name',
        },
      );
      final data = response.data;
      final status = (data['status'] ?? '').toString();
      if (status != 'OK') {
        throw Exception('Unable to fetch selected address');
      }
      final result = (data['result'] is Map<String, dynamic>)
          ? data['result'] as Map<String, dynamic>
          : <String, dynamic>{};
      final components = (result['address_components'] is List)
          ? List<dynamic>.from(result['address_components'] as List)
          : <dynamic>[];
      final geometry = (result['geometry'] is Map<String, dynamic>)
          ? result['geometry'] as Map<String, dynamic>
          : <String, dynamic>{};
      final location = (geometry['location'] is Map<String, dynamic>)
          ? geometry['location'] as Map<String, dynamic>
          : <String, dynamic>{};

      String componentValue(List<dynamic> list, List<String> types) {
        for (final item in list) {
          if (item is! Map<String, dynamic>) continue;
          final itemTypes = (item['types'] is List)
              ? List<dynamic>.from(item['types'] as List)
              : <dynamic>[];
          if (types.any((type) => itemTypes.contains(type))) {
            return (item['long_name'] ?? '').toString().trim();
          }
        }
        return '';
      }

      final houseNo = componentValue(components, ['street_number']);
      final street = componentValue(components, ['route']);
      final locality = componentValue(
        components,
        ['sublocality', 'sublocality_level_1', 'neighborhood'],
      );
      final city = componentValue(
        components,
        ['locality', 'administrative_area_level_2'],
      );
      final state = componentValue(components, ['administrative_area_level_1']);
      final pincode = componentValue(components, ['postal_code']);
      final landmark = componentValue(components, ['point_of_interest', 'premise']);
      final placeName = (result['name'] ?? '').toString().trim();

      final line1 = [houseNo, street]
          .where((part) => part.trim().isNotEmpty)
          .join(', ');
      final line2 = locality.isNotEmpty ? locality : city;

      return {
        'formattedAddress': (result['formatted_address'] ?? '').toString().trim(),
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'pincode': pincode,
        'landmark': landmark,
        'placeName': placeName,
        'latitude': (location['lat'] as num?)?.toDouble(),
        'longitude': (location['lng'] as num?)?.toDouble(),
      };
    } catch (e) {
      showSnackNotification(
        message: e.toString().replaceFirst('Exception: ', ''),
        hasError: true,
      );
      return null;
    }
  }

  void applyAddressPrefill(Map<String, dynamic> data) {
    final line1 = (data['line1'] ?? '').toString().trim();
    final line2 = (data['line2'] ?? '').toString().trim();
    final city = (data['city'] ?? '').toString().trim();
    final state = (data['state'] ?? '').toString().trim();
    final pincode = (data['pincode'] ?? data['postalCode'] ?? '').toString().trim();
    final landmark = (data['landmark'] ?? '').toString().trim();
    final fullAddress = (data['fullAddress'] ?? data['formattedAddress'] ?? '').toString().trim();
    final label = (data['label'] ?? '').toString().trim();
    final lat = (data['latitude'] as num?)?.toDouble();
    final lng = (data['longitude'] as num?)?.toDouble();

    flatController.text = line1;
    areaController.text = line2;
    cityController.text = city;
    stateController.text = state;
    pincodeController.text = pincode;
    landmarkController.text = landmark;
    fullAddressController.text = fullAddress;
    if (lat != null) latitude.value = lat;
    if (lng != null) longitude.value = lng;

    if (label.isNotEmpty) {
      if (label == 'Home' || label == 'Work') {
        selectedSaveAs.value = label;
      } else {
        otherPlaceName.value = label;
        selectedSaveAs.value = label;
      }
    }

    if (phoneController.text.trim().isEmpty) {
      final storage = GetStorage();
      phoneController.text = (storage.read('mobile') ?? '').toString().trim();
    }
    update();
  }

  void selectSaveAs(String label) {
    selectedSaveAs.value = label;
    update();
  }

  void setOtherPlaceName(String customName) {
    otherPlaceName.value = customName;
    selectedSaveAs.value = customName;
    update();
  }

  dynamic buildAddAddressPayload() {
    final fullAddress = fullAddressController.text.trim().isNotEmpty
        ? fullAddressController.text.trim()
        : [
            flatController.text.trim(),
            areaController.text.trim(),
            if (landmarkController.text.trim().isNotEmpty)
              landmarkController.text.trim(),
          ].join(', ');

    return {
      "label": selectedSaveAs.value,
      "line1": flatController.text.trim(),
      "line2": areaController.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "pincode": pincodeController.text.trim(),
      "country": "India",
      "phone": phoneController.text.trim(),
      "isDefault": true,
      "latitude": latitude.value ?? 0,
      "longitude": longitude.value ?? 0,
      "landmark": landmarkController.text.trim(),
      "fullAddress": fullAddress,
    };
  }

  Future<bool> validateAndSaveAddress() async {
    if (flatController.text.trim().isEmpty || areaController.text.trim().isEmpty) {
      showSnackNotification(
        message: 'Please enter flat/house and area details',
        hasError: true,
      );
      return false;
    }
    final payload = buildAddAddressPayload();
    return await addAddress(payload);
  }

  Future<bool> addAddress(dynamic data)async{
    try{
      changeLoading(true);
      update();
      final url = 'addresses';
      final reqObj = data;
      log('addAddress req ---- ${reqObj}');
      final response = await dioClient.postRequest(url, data: reqObj);
      log('addAddress response ---- ${response}');
      await getAddresses();
      toastWidget('Address saved successfully', false);
      changeLoading(false);
      update();
      return true;
    }catch(e){
      log(e.toString());
      showSnackNotification(
        message: 'Unable to save address, please try again',
        hasError: true,
      );
      changeLoading(false);
      update();
      return false;
    }
  }


  Future<void> getUserProfileData() async {
    try{
      changeLoading(true);
      update();
      final url = 'users/me';
      final response = await dioClient.getRequest(url);
      log('getUserFrofileData response ---- ${response}');
      final data = response.data;
      log('getUserFrofileData data ---- ${data}');
      if (data is Map<String, dynamic>) {
        final dynamic profile = data['data'];
        if (profile is Map<String, dynamic>) {
          _userProfileData.assignAll(profile);
        } else {
          _userProfileData.assignAll(data);
        }
      } else {
        _userProfileData.clear();
      }
    }catch(e){
      log(e.toString());
      _userProfileData.clear();
    } finally {
      changeLoading(false);
      update();
    }
  }


  Future<bool> updateUserProfile(Map<String, dynamic> payload) async {
    try{
      changeLoading(true);
      update();
      final url = 'users/me';
      final response = await dioClient.patchRequest(url, data: payload);
      log('updateUserProfile response ---- ${response}');
      _userProfileData.addAll(payload);
      await getUserProfileData();
      toastWidget('Profile updated successfully', false);
      return true;
    }catch(e){
      log(e.toString());
      onHandleError(e, error: e);
      return false;
    } finally {
      changeLoading(false);
      update();
    }
  }


  deleteUserProfile()async {
    try{
      changeLoading(true);
      update();
      final url = 'users/me';
      final response = await dioClient.deleteRequest(url);
      log('deleteUserProfile response ---- ${response}');
      toastWidget('Profile deleted successfully', false);
      Get.offAllNamed(Routes.SIGNUPAMDLOGIN);
    }catch(e){
      log(e.toString());
      onHandleError(e, error: e);
      return false;
    } finally {
      changeLoading(false);
      update();
    }
    return true;
  }

  @override
  void onClose() {
    flatController.dispose();
    areaController.dispose();
    landmarkController.dispose();
    fullAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}