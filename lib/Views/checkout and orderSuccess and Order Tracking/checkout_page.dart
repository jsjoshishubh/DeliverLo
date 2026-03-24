import 'package:deliverylo/Commons%20and%20Reusables/common_doted_divider.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_build_details_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_order_summery_component.dart';
import 'package:deliverylo/Components/checkout%20and%20orderSuccess%20componenets/checkout_payment_methods_component.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const int _deliveryFee = 20;
  static const int _taxes = 30;

  late final List<Map<String, dynamic>> _cartItems;
  late final Map<String, dynamic> _restaurantDetails;
  int _itemSubtotal = 0;

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
      _cartItems = <Map<String, dynamic>>[];
      _restaurantDetails = <String, dynamic>{};
    }
    _itemSubtotal = _initialSubtotal(_cartItems);
  }

  int _initialSubtotal(List<Map<String, dynamic>> items) {
    return items.fold<int>(0, (sum, item) => sum + checkoutLineUnitRupees(item));
  }

  int get _grandTotal => _itemSubtotal + _deliveryFee + _taxes;

  String get _deliveryTitle {
    final t = _restaurantDetails['deliveryTime']?.toString().trim();
    if (t != null && t.isNotEmpty) return 'Delivery in $t';
    return 'Delivery in 15-20 mins';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8FAFC'),
      body: SingleChildScrollView(
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
                          fontColor: HexColor.fromHex('#0F172A'),
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
                    leading: Image.asset('Assets/Extras/address.png', scale: 3),
                    title: Text(
                      'Home',
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '123 Main St, Apt 4B, New York, NY',
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#64748B'),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: HexColor.fromHex('#F48C25').withValues(alpha: 0.23),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Change',
                        style: commonTextStyle(fontColor: HexColor.fromHex('#F48C25')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: Image.asset('Assets/Extras/time.png', scale: 3),
                    title: Text(
                      _deliveryTitle,
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      _restaurantDetails['deliveryFee']?.toString().trim().isNotEmpty == true
                          ? _restaurantDetails['deliveryFee'].toString()
                          : 'Standard delivery',
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#64748B'),
                        fontSize: 14,
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
                        fontColor: HexColor.fromHex('#1D1D1D'),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  CheckoutOrderSumeryComponent(
                    cartItems: _cartItems,
                    onSubtotalChanged: (s) => setState(() => _itemSubtotal = s),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex('#F48C25').withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Colors.orange,
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
                          fontSize: 16,
                          fontColor: HexColor.fromHex('#0F172A'),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Save up to ₹100',
                        style: TextStyle(
                          color: HexColor.fromHex('#F48C25'),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right, color: Colors.grey),
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
                        fontSize: 20,
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
                        fontColor: HexColor.fromHex('#1D1D1D'),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const PaymentMethodComponent(),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF28C1B),
                  borderRadius: BorderRadius.circular(20),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹$_grandTotal',
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 20,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
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
