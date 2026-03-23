import 'package:deliverylo/Commons%20and%20Reusables/commonButton.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Commons%20and%20Reusables/commonTextFormField.dart';
import 'package:deliverylo/Controllers/Profile_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      final normalized = <String, dynamic>{};
      args.forEach((key, value) {
        normalized[key.toString()] = value;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _profileController.applyAddressPrefill(normalized);
      });
    }
  }

  Future<void> _onSaveAddress() async {
    final didSave = await _profileController.validateAndSaveAddress();
    if (!didSave) return;
    Get.back(result: _profileController.buildAddAddressPayload());
  }

  Future<void> _showOtherPlaceNameDialog() async {
    final TextEditingController placeNameController = TextEditingController(
      text: _profileController.otherPlaceName.value == 'Other'
          ? ''
          : _profileController.otherPlaceName.value,
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

                        _profileController.setOtherPlaceName(customName);
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
      body: GetBuilder<ProfileController>(
        builder: (_) {
          return SafeArea(
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
                      onTap: _profileController.fetchCurrentLocationAndFillAddress,
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
                                    _profileController.isFetchingLocation.value
                                        ? 'Fetching current location...'
                                        : 'Tap to enable location access',
                                    style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w400,fontColor: greyFontColor, ),
                                  ),
                                ],
                              ),
                            ),
                            _profileController.isFetchingLocation.value
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
                      controller: _profileController.flatController,
                      hintText: 'e.g. Apt 4B, 3rd Floor',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('AREA / SECTOR / LOCALITY'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _profileController.areaController,
                      hintText: 'e.g. Brooklyn Heights',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('CITY'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _profileController.cityController,
                      hintText: 'e.g. Mumbai',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('STATE'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _profileController.stateController,
                      hintText: 'e.g. Maharashtra',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('PINCODE'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _profileController.pincodeController,
                      hintText: 'e.g. 400001',
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('MOBILE NUMBER'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _profileController.phoneController,
                      hintText: 'e.g. +919876543210',
                      textInputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('LANDMARK (OPTIONAL)'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _profileController.landmarkController,
                      hintText: 'e.g. Near the park entrance',
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('FULL ADDRESS (AUTO/MANUAL)'),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _profileController.fullAddressController,
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
                            selected: _profileController.selectedSaveAs.value == 'Home',
                            onTap: () => _profileController.selectSaveAs('Home'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _saveAsOption(
                            label: 'Work',
                            icon: Icons.work,
                            selected: _profileController.selectedSaveAs.value == 'Work',
                            onTap: () => _profileController.selectSaveAs('Work'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _saveAsOption(
                            label: _profileController.otherPlaceName.value,
                            icon: Icons.location_on,
                            selected: _profileController.selectedSaveAs.value != 'Home' &&
                                _profileController.selectedSaveAs.value != 'Work',
                            onTap: _showOtherPlaceNameDialog,
                          ),
                        ),
                      ],
                    ),
                      ],
                    ),
                  ),
                ),
                LoadingButton(
                 title: 'Save Address',
                 loading: _profileController.loading,
                 onPressed: _profileController.loading ? null : _onSaveAddress,
                 buttonColor: HexColor.fromHex('#F48C25'),
                 borderRadius: BorderRadius.circular(10),
                 height: 54,
                ),
              ],
            ),
          );
        },
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
    TextInputType? textInputType,
  }) {
    return TextFormFieldWidget(
      controller: controller,
      labelText: hintText,
      textInputType: textInputType ?? (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
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