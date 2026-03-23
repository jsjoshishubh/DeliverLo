import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Commons%20and%20Reusables/commonTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();

  bool _isFetchingLocation = false;
  String _selectedSaveAs = 'Home';
  String _otherPlaceName = 'Other';
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _flatController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _fullAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchCurrentLocationAndFillAddress() async {
    if (_isFetchingLocation) return;
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      final addressData = await fetchCurrentFormattedAddress();
      final formattedAddress = (addressData['formatted_address'] ?? '').toString();

      _latitude = addressData['latitude'] as double?;
      _longitude = addressData['longitude'] as double?;

      _fullAddressController.text = formattedAddress;
      _fillFieldsFromFormattedAddress(formattedAddress);

      toastWidget('Current location fetched successfully');
    } catch (e) {
      showSnackNotification(
        message: e.toString().replaceFirst('Exception: ', ''),
        hasError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  void _fillFieldsFromFormattedAddress(String formattedAddress) {
    if (formattedAddress.trim().isEmpty) return;

    final addressParts = formattedAddress
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (addressParts.isEmpty) return;

    final firstPart = addressParts.first;
    final remainingParts =
        addressParts.length > 1 ? addressParts.sublist(1).join(', ') : '';

    _flatController.text = firstPart;
    _areaController.text = remainingParts;
  }

  void _onSaveAddress() {
    if (_flatController.text.trim().isEmpty || _areaController.text.trim().isEmpty) {
      showSnackNotification(
        message: 'Please enter flat/house and area details',
        hasError: true,
      );
      return;
    }

    final composedAddress = [
      _flatController.text.trim(),
      _areaController.text.trim(),
      if (_landmarkController.text.trim().isNotEmpty) _landmarkController.text.trim(),
    ].join(', ');

    Get.back(
      result: {
        'label': _selectedSaveAs,
        'flat': _flatController.text.trim(),
        'area': _areaController.text.trim(),
        'landmark': _landmarkController.text.trim(),
        'fullAddress': composedAddress,
        'formattedAddress': _fullAddressController.text.trim(),
        'latitude': _latitude,
        'longitude': _longitude,
      },
    );
  }

  Future<void> _showOtherPlaceNameDialog() async {
    final TextEditingController placeNameController = TextEditingController(
      text: _otherPlaceName == 'Other' ? '' : _otherPlaceName,
    );

    await Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          height: 190,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save address as',
                  style: commonTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontColor: HexColor.fromHex('#1F2937'),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormFieldWidget(
                  controller: placeNameController,
                  labelText: 'Enter place name',
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: commonTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontColor: HexColor.fromHex('#6B7280'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final customName = placeNameController.text.trim();
                        if (customName.isEmpty) {
                          showSnackNotification(
                            message: 'Please enter place name',
                            hasError: true,
                          );
                          return;
                        }

                        setState(() {
                          _otherPlaceName = customName;
                          _selectedSaveAs = customName;
                        });
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor.fromHex('#F48C25'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: commonTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: HexColor.fromHex('#1F2937')),
        ),
        title: Text(
          'My Addresses',
          style: commonTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontColor: HexColor.fromHex('#1F2937'),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: _fetchCurrentLocationAndFillAddress,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: HexColor.fromHex('#E5E7EB')),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: HexColor.fromHex('#FFF7ED'),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.my_location,
                                color: HexColor.fromHex('#F48C25'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Use Current Location',
                                    style: commonTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontColor: blackFontColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _isFetchingLocation
                                        ? 'Fetching current location...'
                                        : 'Tap to enable location access',
                                    style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w400,fontColor: greyFontColor, ),
                                  ),
                                ],
                              ),
                            ),
                            _isFetchingLocation
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: HexColor.fromHex('#F48C25'),
                                    ),
                                  )
                                : Icon(
                                    Icons.chevron_right,
                                    color: HexColor.fromHex('#94A3B8'),
                                    size: 26,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('FLAT / HOUSE NO. / FLOOR'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _flatController,
                      hintText: 'e.g. Apt 4B, 3rd Floor',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('AREA / SECTOR / LOCALITY'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _areaController,
                      hintText: 'e.g. Brooklyn Heights',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('LANDMARK (OPTIONAL)'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _landmarkController,
                      hintText: 'e.g. Near the park entrance',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('FULL ADDRESS (AUTO/MANUAL)'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _fullAddressController,
                      hintText: 'Auto-filled from current location or type manually',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 18),
                    _buildLabel('SAVE AS'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _saveAsOption(
                            label: 'Home',
                            icon: Icons.home,
                            selected: _selectedSaveAs == 'Home',
                            onTap: () {
                              setState(() {
                                _selectedSaveAs = 'Home';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _saveAsOption(
                            label: 'Work',
                            icon: Icons.work,
                            selected: _selectedSaveAs == 'Work',
                            onTap: () {
                              setState(() {
                                _selectedSaveAs = 'Work';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _saveAsOption(
                            label: _otherPlaceName,
                            icon: Icons.location_on,
                            selected: _selectedSaveAs != 'Home' && _selectedSaveAs != 'Work',
                            onTap: _showOtherPlaceNameDialog,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: commonTextWithSufixAndPreFixIcon(
                buttonTitle: 'Save Address',
                buttonHeight: 58,
                onTap: _onSaveAddress,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String title) {
    return Text(
      title,
      style: commonTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        fontColor: blackFontColor,
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextFormFieldWidget(
      controller: controller,
      labelText: hintText,
      textInputType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
      maxLines: maxLines,
      minLines: maxLines > 1 ? 2 : 1,
      textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _saveAsOption({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? HexColor.fromHex('#F48C25') : HexColor.fromHex('#E2E8F0'),
            width: selected ? 1.2 : 1,
          ),
          color: selected ? HexColor.fromHex('#FFF7ED') : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? HexColor.fromHex('#F48C25') : HexColor.fromHex('#94A3B8'),
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: commonTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontColor: selected ? HexColor.fromHex('#F48C25') : HexColor.fromHex('#94A3B8'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}