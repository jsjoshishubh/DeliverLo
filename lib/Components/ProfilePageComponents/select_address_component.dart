import 'package:deliverylo/Commons%20and%20Reusables/commonButton.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Profile_Controller.dart';
import '../../Routes/app_routes.dart';

class SelectAddressComponent extends StatefulWidget {
  const SelectAddressComponent({super.key});

  @override
  State<SelectAddressComponent> createState() => _SelectAddressComponentState();
}

class _SelectAddressComponentState extends State<SelectAddressComponent> {
  int _selectedAddressIndex = 0;
  final ProfileController _profileController = Get.put(ProfileController());

  final RxList<dynamic> _savedAddresses = [].obs;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    await _profileController.getAddresses();
    _savedAddresses.assignAll(_profileController.savedAddresses);
    if (_savedAddresses.isNotEmpty && _selectedAddressIndex >= _savedAddresses.length) {
      setState(() {
        _selectedAddressIndex = 0;
      });
    }
  }

  IconData _getAddressIcon(String label) {
    final normalized = label.toLowerCase();
    if (normalized == 'home') return Icons.home_filled;
    if (normalized == 'office') return Icons.business;
    if (normalized == 'work') return Icons.work;
    return Icons.location_on;
  }

  String _getAddressTitle(dynamic item) {
    if (item is! Map) return 'Other';
    final raw = (item['label'] ?? item['title'] ?? 'Other').toString().trim();
    return raw.isEmpty ? 'Other' : raw;
  }

  String _getAddressText(dynamic item) {
    if (item is! Map) return '';
    final fullAddress = (item['fullAddress'] ?? item['formattedAddress'] ?? item['address'] ?? '').toString().trim();
    if (fullAddress.isNotEmpty) return fullAddress;
    return [
      (item['line1'] ?? item['flat'] ?? '').toString().trim(),
      (item['line2'] ?? item['area'] ?? '').toString().trim(),
      (item['landmark'] ?? '').toString().trim(),
      (item['city'] ?? '').toString().trim(),
      (item['state'] ?? '').toString().trim(),
      (item['pincode'] ?? item['postalCode'] ?? '').toString().trim(),
    ].where((part) => part.isNotEmpty).join(', ');
  }

  String _getMetaInfo(dynamic item) {
    if (item is! Map) return '';
    final city = (item['city'] ?? '').toString().trim();
    final state = (item['state'] ?? '').toString().trim();
    final pincode = (item['pincode'] ?? item['postalCode'] ?? '').toString().trim();
    final phone = (item['phone'] ?? item['mobile'] ?? '').toString().trim();
    final parts = <String>[
      if (city.isNotEmpty) 'City: $city',
      if (state.isNotEmpty) 'State: $state',
      if (pincode.isNotEmpty) 'Pincode: $pincode',
      if (phone.isNotEmpty) 'Mobile: $phone',
    ];
    return parts.join('  |  ');
  }

  Map<String, dynamic> _normalizeSelectedAddress(dynamic item) {
    final normalized = <String, dynamic>{};
    if (item is Map) {
      item.forEach((key, value) {
        normalized[key.toString()] = value;
      });
    }
    final title = _getAddressTitle(item);
    final address = _getAddressText(item);
    normalized['title'] = title;
    normalized['label'] = (normalized['label'] ?? title).toString().trim();
    normalized['address'] = address;
    if ((normalized['fullAddress'] ?? '').toString().trim().isEmpty) {
      normalized['fullAddress'] = address;
    }
    return normalized;
  }

  Future<void> _onAddNewAddressTap() async {
    final dynamic result = await Get.toNamed(Routes.ADDADDRESS);
    if (result is! Map) return;

    final String label = (result['label'] ?? 'Other').toString().trim();
    final String fullAddress = (result['fullAddress'] ?? '').toString().trim();
    final String formattedAddress = (result['formattedAddress'] ?? '').toString().trim();
    final String fallbackAddress = [
      (result['line1'] ?? result['flat'] ?? '').toString().trim(),
      (result['line2'] ?? result['area'] ?? '').toString().trim(),
      (result['landmark'] ?? '').toString().trim(),
    ].where((part) => part.isNotEmpty).join(', ');

    final String addressText = fullAddress.isNotEmpty
        ? fullAddress
        : (formattedAddress.isNotEmpty ? formattedAddress : fallbackAddress);
    if (addressText.isEmpty) return;

    setState(() {
      _savedAddresses.insert(0, {
        'label': label,
        'fullAddress': addressText,
        'city': (result['city'] ?? '').toString().trim(),
        'state': (result['state'] ?? '').toString().trim(),
        'pincode': (result['pincode'] ?? result['postalCode'] ?? '').toString().trim(),
        'phone': (result['phone'] ?? result['mobile'] ?? '').toString().trim(),
      });
      _selectedAddressIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 6,
            width: 60,
            decoration: BoxDecoration(
              color: HexColor.fromHex('#D1D5DB'),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Select a delivery address',
                            style: commonTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontColor: blackFontColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color:blackFontColor,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    Divider(
                      color: HexColor.fromHex('#E5E7EB'),
                      height: 1,
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: HexColor.fromHex('#F3F4F6').withOpacity(0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: HexColor.fromHex('#E5E7EB')),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: HexColor.fromHex('#9CA3AF'),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Search for area, street name...',
                              style: commonTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontColor: greyFontColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _onAddNewAddressTap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: HexColor.fromHex('#F59E67')),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: HexColor.fromHex('#F97316'),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Add New Address',
                              style: commonTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontColor: HexColor.fromHex('#FF5200'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'SAVED ADDRESSES',
                      style: commonTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontColor: greyFontColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      if (_profileController.loading && _savedAddresses.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (_savedAddresses.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'No saved addresses found',
                            style: commonTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontColor: greyFontColor,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: _savedAddresses.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final isSelected = _selectedAddressIndex == index;
                          final title = _getAddressTitle(item);
                          final address = _getAddressText(item);
                          final metaInfo = _getMetaInfo(item);
                          final icon = _getAddressIcon(title);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAddressIndex = index;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected
                                      ? HexColor.fromHex('#F97316')
                                      : HexColor.fromHex('#E5E7EB'),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      icon,
                                      color: isSelected
                                          ? HexColor.fromHex('#F97316')
                                          : HexColor.fromHex('#9CA3AF'),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: commonTextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            fontColor: blackFontColor,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          address,
                                          style: commonTextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontColor: greyFontColor,
                                          ),
                                        ),
                                        if (metaInfo.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            metaInfo,
                                            style: commonTextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              fontColor: HexColor.fromHex('#6B7280'),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? HexColor.fromHex('#F97316') : HexColor.fromHex('#D1D5DB'),
                                      ),
                                      color: isSelected ? HexColor.fromHex('#F97316') : Colors.white,
                                    ),
                                    child: isSelected ? const Icon(Icons.circle, size: 10, color: Colors.white) : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: HexColor.fromHex('#E5E7EB')),
              ),
            ),
            child: SafeArea(
              top: false,
              child: 
              LoadingButton(
                title: 'Deliver to this address',
                buttonColor: HexColor.fromHex('#F48C25'),
                height: 54,
                onPressed: _profileController.loading ? null : () {
                  if (_savedAddresses.isEmpty) {
                    toastWidget('Please add address first', true);
                    return;
                  }
                  final selectedItem = _savedAddresses[_selectedAddressIndex];
                  Navigator.of(context).pop(_normalizeSelectedAddress(selectedItem));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}