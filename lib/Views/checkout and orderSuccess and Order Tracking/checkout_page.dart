import 'package:deliverylo/Commons%20and%20Reusables/common_doted_divider.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_build_details_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_order_summery_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_payment_methods_component.dart';
import 'package:deliverylo/Components/ProfilePageComponents/select_address_component.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CheckoutPage extends StatefulWidget {
  /// Grocery checkout uses e.g. `#15803D`; omit for default food (red) theme.
  final Color? accentColor;

  const CheckoutPage({super.key, this.accentColor});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Color get _accent => widget.accentColor ?? redColor;
  Color get _accentLight => widget.accentColor != null
      ? widget.accentColor!.withValues(alpha: 0.15)
      : lightRed;

  static const int _deliveryFee = 20;
  static const int _taxes = 30;
  static const String _checkoutCartStorageKey = 'checkout_cart_items';
  static const String _selectedAddressStorageKey = 'food_selected_address';
  final GetStorage _storage = GetStorage();

  late List<Map<String, dynamic>> _cartItems;
  late final Map<String, dynamic> _restaurantDetails;
  int _itemSubtotal = 0;
  String _selectedAddressTitle = 'Home';
  String _selectedAddressText = '123 Main St, Apt 4B, New York, NY NY';

  @override
  void initState() {
    super.initState();
    final raw = Get.arguments;
    if (raw is Map) {
      final cart = raw['cartItems'];
      if (cart is List) {
        _cartItems = cart.map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) return Map<String, dynamic>.from(e);
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{};
        }).toList();
      } else {
        _cartItems = <Map<String, dynamic>>[];
      }
      final rd = raw['restaurantDetails'];
      if (rd is Map) {
        _restaurantDetails = Map<String, dynamic>.from(rd);
      } else {
        _restaurantDetails = <String, dynamic>{};
      }
    } else {
      final dynamic storedCart = _storage.read(_checkoutCartStorageKey);
      if (storedCart is List) {
        _cartItems = storedCart.map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) return Map<String, dynamic>.from(e);
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{};
        }).toList();
      } else {
        _cartItems = <Map<String, dynamic>>[];
      }
      _restaurantDetails = <String, dynamic>{};
    }
    _itemSubtotal = _initialSubtotal(_cartItems);
    _loadSelectedAddressFromStorage();
  }

  int _initialSubtotal(List<Map<String, dynamic>> items) {
    return items.fold<int>(0, (sum, item) => sum + checkoutLineUnitRupees(item));
  }

  int get _grandTotal => _itemSubtotal + _deliveryFee + _taxes;

  String _buildAddressLabelFromSelection(Map selection) {
    final title = (selection['title'] ?? selection['label'] ?? 'Other').toString().trim();
    final directAddress =
        (selection['address'] ?? selection['fullAddress'] ?? selection['formattedAddress'] ?? '')
            .toString()
            .trim();
    final composedAddress = [
      (selection['line1'] ?? selection['flat'] ?? '').toString().trim(),
      (selection['line2'] ?? selection['area'] ?? '').toString().trim(),
      (selection['landmark'] ?? '').toString().trim(),
      (selection['city'] ?? '').toString().trim(),
      (selection['state'] ?? '').toString().trim(),
      (selection['pincode'] ?? selection['postalCode'] ?? '').toString().trim(),
    ].where((part) => part.isNotEmpty).join(', ');
    final address = directAddress.isNotEmpty ? directAddress : composedAddress;
    if (address.isEmpty) return title;
    return '$title|$address';
  }

  void _loadSelectedAddressFromStorage() {
    final dynamic storedAddress = _storage.read(_selectedAddressStorageKey);
    if (storedAddress is! Map) return;
    final label = _buildAddressLabelFromSelection(storedAddress);
    final split = label.split('|');
    if (split.isEmpty) return;
    _selectedAddressTitle = split.first.trim().isEmpty ? 'Home' : split.first.trim();
    if (split.length > 1 && split[1].trim().isNotEmpty) {
      _selectedAddressText = split[1].trim();
    }
  }

  Future<void> _openSelectAddressBottomSheet() async {
    final dynamic selectedAddress = await showCommonBottomSheet<Map<String, dynamic>>(
      context: context,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.76,
        child: const SelectAddressComponent(),
      ),
    );
    if (!mounted || selectedAddress is! Map) return;
    await _storage.write(_selectedAddressStorageKey, Map<String, dynamic>.from(selectedAddress));
    final label = _buildAddressLabelFromSelection(selectedAddress);
    final split = label.split('|');
    setState(() {
      _selectedAddressTitle = split.first.trim().isEmpty ? 'Home' : split.first.trim();
      _selectedAddressText =
          split.length > 1 && split[1].trim().isNotEmpty ? split[1].trim() : _selectedAddressText;
    });
  }

  void _onCartItemsChanged(List<Map<String, dynamic>> items) {
    setState(() {
      _cartItems = items;
    });
    _storage.write(_checkoutCartStorageKey, items);
  }

  String get _deliveryTitle {
    final t = _restaurantDetails['deliveryTime']?.toString().trim();
    if (t != null && t.isNotEmpty) return 'Delivery in $t';
    return 'Delivery in 15-20 mins';
  }

  Widget _buildEmptyCartBody() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                SizedBox(
                  width: Get.width / 2.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Checkout',
                      style: commonTextStyle(
                        fontColor: blackFontColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: HexColor.fromHex('#E2E8F0')),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          color: _accentLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove_shopping_cart_outlined,
                          size: 44,
                          color: _accent,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Your cart is waiting for something tasty!',
                        textAlign: TextAlign.center,
                        style: commonTextStyle(
                          fontColor: HexColor.fromHex('#0F172A'),
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Looks like your cart is empty.\nAdd your favorite dishes and place your order in seconds.',
                        textAlign: TextAlign.center,
                        style: commonTextStyle(
                          fontColor: greyFontColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Browse Restaurants',
                    style: commonTextStyle(
                      fontColor: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8FAFC'),
      body: _cartItems.isEmpty
          ? _buildEmptyCartBody()
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: Get.width / 2.1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Checkout',
                        style: commonTextStyle(
                          fontColor: blackFontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300, height: 1),
            const SizedBox(height: 2),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    leading: Image.asset('Assets/Extras/address.png', scale: 4,color: _accent,),
                    title: Text(
                      _selectedAddressTitle,
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      _selectedAddressText,
                      style: commonTextStyle(
                        fontColor: greyFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: InkWell(
                      onTap: _openSelectAddressBottomSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: _accentLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Change',
                          style: commonTextStyle(fontColor: _accent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: Image.asset('Assets/Extras/time.png', scale: 4),
                    title: Text(
                      _deliveryTitle,
                      style: commonTextStyle(
                        fontColor: blackFontColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      _restaurantDetails['deliveryFee']?.toString().trim().isNotEmpty == true ? _restaurantDetails['deliveryFee'].toString() : 'Standard delivery',
                      style: commonTextStyle(
                        fontColor: greyFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
                    child: Text(
                      'Order Summery',
                      style: commonTextStyle(
                        fontColor: blackFontColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  CheckoutOrderSumeryComponent(
                    cartItems: _cartItems,
                    onSubtotalChanged: (s) => setState(() => _itemSubtotal = s),
                    onCartItemsChanged: _onCartItemsChanged,
                    accentColor: widget.accentColor,
                    accentSurfaceColor:
                        widget.accentColor != null ? _accentLight : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: DashedBorder(
                color: _accent,
                borderRadius: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: _accentLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.percent,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Apply Coupon',
                        style: commonTextStyle(
                          fontSize: 14,
                          fontColor: blackFontColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Save up to ₹100',
                        style: TextStyle(
                          color: _accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right, color: blackFontColor),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Text(
                      'Bill Details',
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#1D1D1D'),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BillDetails(
                    itemSubtotal: _itemSubtotal,
                    deliveryFee: _deliveryFee,
                    taxes: _taxes,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    child: Text(
                      'Payment Method',
                      style: commonTextStyle(
                        fontColor: blackFontColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  PaymentMethodComponent(
                    accentColor: widget.accentColor,
                    accentSurfaceColor:
                        widget.accentColor != null ? _accentLight : null,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 2,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL TO PAY',
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹$_grandTotal',
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      // onTap: () => Get.toNamed(Routes.ORDERCONFIRMATION),
                      onTap: () => Get.toNamed(Routes.ORDERSUCCESSDELIVER),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Pay Now',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
