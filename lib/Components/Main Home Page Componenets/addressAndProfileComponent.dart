import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:deliverylo/Components/ProfilePageComponents/select_address_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Routes/app_routes.dart';

class MainHomeAddressAndProfileComponent extends StatefulWidget {
  const MainHomeAddressAndProfileComponent({super.key});

  @override
  State<MainHomeAddressAndProfileComponent> createState() =>
      MainHome_AddressAndProfileComponentState();
}

class MainHome_AddressAndProfileComponentState
    extends State<MainHomeAddressAndProfileComponent> {
  static const String _selectedAddressStorageKey = 'food_selected_address';
  final GetStorage _storage = GetStorage();
  String _selectedAddressLabel = 'Select delivery address';

  @override
  void initState() {
    super.initState();
    _loadSelectedAddressFromStorage();
  }

  String _buildAddressLabelFromSelection(Map selection) {
    final String title = (selection['title'] ?? selection['label'] ?? 'Other')
        .toString()
        .trim();
    final String directAddress = (selection['address'] ??
            selection['fullAddress'] ??
            selection['formattedAddress'] ??
            '')
        .toString()
        .trim();
    final String composedAddress = [
      (selection['line1'] ?? selection['flat'] ?? '').toString().trim(),
      (selection['line2'] ?? selection['area'] ?? '').toString().trim(),
      (selection['landmark'] ?? '').toString().trim(),
      (selection['city'] ?? '').toString().trim(),
      (selection['state'] ?? '').toString().trim(),
      (selection['pincode'] ?? selection['postalCode'] ?? '').toString().trim(),
    ].where((part) => part.isNotEmpty).join(', ');

    final String address =
        directAddress.isNotEmpty ? directAddress : composedAddress;
    if (address.isEmpty) return title.toUpperCase();
    return '${title.toUpperCase()} - $address';
  }

  void _loadSelectedAddressFromStorage() {
    final dynamic storedAddress = _storage.read(_selectedAddressStorageKey);
    if (storedAddress is! Map) return;
    final label = _buildAddressLabelFromSelection(storedAddress);
    if (label.trim().isEmpty) return;
    setState(() => _selectedAddressLabel = label);
  }

  Future<void> openSelectAddressBottomSheet() async {
    final dynamic selectedAddress = await showCommonBottomSheet<Map<String, dynamic>>(
      context: context,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.76,
        child: const SelectAddressComponent(),
      ),
    );

    if (!mounted || selectedAddress is! Map) return;
    await _storage.write(
      _selectedAddressStorageKey,
      Map<String, dynamic>.from(selectedAddress),
    );
    setState(() {
      _selectedAddressLabel = _buildAddressLabelFromSelection(selectedAddress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(border: Border.all(color: redColor,width: 0.4),color: lightRed,shape: BoxShape.circle,),
            child: const Icon(Icons.location_on_outlined,color: redColor,size: 24,),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: openSelectAddressBottomSheet,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DELIVER TO',
                    style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontColor: greyFontColor,),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedAddressLabel,
                          overflow: TextOverflow.ellipsis,
                          style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontColor:blackFontColor,),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down_rounded,color: blackFontColor,size: 20,),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => Get.toNamed(Routes.PROFILE),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(color: redColor,shape: BoxShape.circle,),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
