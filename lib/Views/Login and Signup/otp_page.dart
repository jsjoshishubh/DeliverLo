import 'dart:async';

import 'package:deliverylo/Commons and Reusables/commonButton.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = PinInputController();
  static const int _resendSeconds = 30;
  int _remainingSeconds = _resendSeconds;
  Timer? _resendTimer;

  /// Mobile number passed from login/signup page via Get.arguments
  String get _mobileNumber {
    final args = Get.arguments;
    if (args == null) return '';
    if (args is String) return args;
    if (args is Map && args['mobile'] != null) return args['mobile'].toString();
    return '';
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() => _remainingSeconds = _resendSeconds);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _formattedTimer {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '(${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')})';
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: HexColor.fromHex('#F8F8F8'),
      body: Column(
        children: [
         Center(
            child: Container(
              margin: EdgeInsets.only(top: 90),
              child: Image.asset("Assets/onBoardingAndAuthFlow/login_otp.png", scale: 4.5,),
            ),
          ),
          SizedBox(height: 20,),
           ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HexColor.fromHex('#000000'),
                  HexColor.fromHex('#969696'),
                ],
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              );
            },
            blendMode: BlendMode.srcIn,
            child: Text(
              'One app for food,\ngrocery, dining\nand more in mins!',
              textAlign: TextAlign.center,
              style: commonTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                fontColor: Colors.white,
              ).copyWith(
                height: 1.25,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildVerificationCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard() {
    const orange = Color(0xFFF08B27);
    const cardBg = Colors.white;
    const shadowColor = Color(0x1A000000);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 28),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lock icon with halo
           Image.asset('Assets/Logos/lock_logo.png',scale: 4,),
            Text(
              'Verification Code',
              textAlign: TextAlign.center,
              style: commonTextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontColor: HexColor.fromHex('#111827'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _mobileNumber.isEmpty
                  ? 'We have sent the verification code to\nyour mobile number'
                  : 'We have sent the verification code to\nyour mobile number $_mobileNumber',
              textAlign: TextAlign.center,
              style: commonTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontColor: HexColor.fromHex('#4B5563'),
              ).copyWith(height: 1.4),
            ),
            const SizedBox(height: 24),
            MaterialPinFormField(
              length: 4,
              pinController: _otpController,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(54, 60),
                spacing: 12,
                borderRadius: BorderRadius.circular(14),
                borderColor: const Color(0xFFE0E0E0),
                focusedBorderColor: HexColor.fromHex('#FF5200'),
                filledBorderColor: const Color(0xFF4CAF50),
                fillColor: cardBg,
                focusedFillColor: cardBg,
                filledFillColor: cardBg,
                completeFillColor: cardBg,
                completeBorderColor: const Color(0xFF4CAF50),
                textStyle: commonTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontColor: const Color(0xFF1A1A1A),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.length < 4) {
                  return 'Please enter the 4-digit code';
                }
                return null;
              },
              onCompleted: (v) {},
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: commonTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontColor: HexColor.fromHex('#4B5563'),
                  ),
                ),
                GestureDetector(
                  onTap: _remainingSeconds <= 0
                      ? () {
                          _startResendTimer();
                        }
                      : null,
                  child: Text(
                    'Resend Code',
                    style: commonTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontColor: _remainingSeconds <= 0
                          ? HexColor.fromHex('#FF5200')
                          : const Color(0xFFAAAAAA),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _formattedTimer,
              style: commonTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontColor: HexColor.fromHex('#4B5563'),
              ),
            ),
            const SizedBox(height: 14),
            LoadingButton(
              title: 'Verify & Continue',
              buttonColor: HexColor.fromHex('#F48C25'),
              borderRadius: BorderRadius.circular(12),
              height: 50,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? true) {
                  final otp = _otpController.text;
                  if (otp.length == 4) {
                    Get.offAllNamed(Routes.MAIN_DASHBOARD);
                    // Verify OTP - add your verification logic here
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}