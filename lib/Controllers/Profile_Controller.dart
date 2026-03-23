import 'dart:developer';

import 'package:deliverylo/Https%20Requests/dio_client.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

DioClient dioClient = DioClient();

class ProfileController extends GetxController {
  final RxList<dynamic> _savedAddresses = [].obs;
  List<dynamic> get savedAddresses => _savedAddresses;

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
      // "fullAddress": fullAddress,
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