import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Routes/app_routes.dart';

class SelectAddressComponent extends StatefulWidget {
  const SelectAddressComponent({super.key});

  @override
  State<SelectAddressComponent> createState() => _SelectAddressComponentState();
}

class _SelectAddressComponentState extends State<SelectAddressComponent> {
  int _selectedAddressIndex = 0;

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      'title': 'Home',
      'address':
          'Flat 402, Sunshine Apartments, 12th Main Road, Indiranagar, Bangalore - 560038',
      'eta': '30 mins',
      'icon': Icons.home_filled,
    },
    {
      'title': 'Work',
      'address':
          'WeWork Galaxy, 43 Residency Road, Shanthala Nagar, Ashok Nagar, Bangalore - 560025',
      'eta': '45 mins',
      'icon': Icons.work,
    },
    {
      'title': 'Gym',
      'address': 'Gold\'s Gym, 4th Floor, 100 Feet Rd, Indiranagar, Bangalore - 560038',
      'eta': 'Too far',
      'icon': Icons.fitness_center,
    },
  ];

  Future<void> _onAddNewAddressTap() async {
    final dynamic result = await Get.toNamed(Routes.ADDADDRESS);
    if (result is! Map) return;

    final String label = (result['label'] ?? 'Other').toString().trim();
    final String fullAddress = (result['fullAddress'] ?? '').toString().trim();
    final String formattedAddress = (result['formattedAddress'] ?? '').toString().trim();
    final String fallbackAddress = [
      (result['flat'] ?? '').toString().trim(),
      (result['area'] ?? '').toString().trim(),
      (result['landmark'] ?? '').toString().trim(),
    ].where((part) => part.isNotEmpty).join(', ');

    final String addressText = fullAddress.isNotEmpty
        ? fullAddress
        : (formattedAddress.isNotEmpty ? formattedAddress : fallbackAddress);
    if (addressText.isEmpty) return;

    IconData icon = Icons.location_on;
    if (label.toLowerCase() == 'home') {
      icon = Icons.home_filled;
    } else if (label.toLowerCase() == 'work') {
      icon = Icons.work;
    }

    setState(() {
      _savedAddresses.insert(0, {
        'title': label,
        'address': addressText,
        'eta': 'New',
        'icon': icon,
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
                    ..._savedAddresses.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = _selectedAddressIndex == index;

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
                                  item['icon'] as IconData,
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
                                      item['title'] as String,
                                      style: commonTextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontColor: blackFontColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['address'] as String,
                                      style: commonTextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontColor: greyFontColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:  isSelected ?  HexColor.fromHex('#FF5200').withValues(alpha: 0.1) : HexColor.fromHex('#F3F4F6'),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item['eta'] as String,
                                      style: commonTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontColor: isSelected ? HexColor.fromHex('#F97316') : greyFontColor,
                                      ),
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
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: HexColor.fromHex('#E5E7EB')),
              ),
            ),
            child: SafeArea(
              top: false,
              child: commonTextWithSufixAndPreFixIcon(
                buttonTitle: 'Deliver to this address',
                buttonHeight: 58,
                onTap: () => Navigator.of(context).pop(_savedAddresses[_selectedAddressIndex]),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}