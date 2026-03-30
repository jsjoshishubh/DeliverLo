import 'dart:async';
import 'dart:developer';
import 'package:deliverylo/Commons and Reusables/commonButton.dart';
import 'package:deliverylo/Controllers/Auth_Controller.dart';
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
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _otpController = PinInputController();
  static const int _resendSeconds = 30;
  int _remainingSeconds = _resendSeconds;
  Timer? _resendTimer;

  String get _mobileNumber {
    final args = Get.arguments;
    log('_mobileNumber -- ${args}');
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

  void onCheckOtpValidation() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 4) {
      toastWidget('Please enter the 4-digit code', true);
      return;
    }

    _formKey.currentState?.save();
    authController.onOtpVerification(context, otp);
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
          body: GetBuilder(
            init: authController,
            builder: (controller) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16,),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
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
                                colors: [HexColor.fromHex('#000000'),HexColor.fromHex('#969696'),],
                                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                              );
                            },
                            blendMode: BlendMode.srcIn,
                            child: Text('One app for food,\ngrocery, dining\nand more in mins!',textAlign: TextAlign.center,style: commonTextStyle(fontSize: 28,fontWeight: FontWeight.w600,fontColor: Colors.white,).copyWith(height: 1.25),),
                          ),
                          SizedBox(height: 20),
                          _buildVerificationCard(),
                        ],
                      ),
                    ),
                  );
                },
              );
        },
      )
    );
  }

  Widget _buildVerificationCard() {
    const cardBg = Colors.white;
    const shadowColor = Color(0x1A000000);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 18,),
      child: Card(
         elevation: 1,
         shadowColor: HexColor.fromHex('#F8F8F8').withOpacity(0.9),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
         color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             SizedBox(height: 10,),
             Image.asset('Assets/Logos/lock_logo.png',scale: 4.5,),
              Text(
                'Verification Code',
                textAlign: TextAlign.center,
                style: commonTextStyle(fontSize: 26,fontWeight: FontWeight.w600,fontColor: blackFontColor,),
              ),
              const SizedBox(height: 8),
              Text(
                _mobileNumber.isEmpty ? 'We have sent the verification code to\nyour mobile number' : 'We have sent the verification code to\nyour mobile number $_mobileNumber',
                textAlign: TextAlign.center,
                style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w400,fontColor: greyFontColor.withValues(alpha: 0.8),),
              ),
              const SizedBox(height: 30),
              MaterialPinFormField(
                length: 4,
                pinController: _otpController,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(54, 60),
                  spacing: 12,
                  borderRadius: BorderRadius.circular(12),
                  borderColor: greyFontColor.withOpacity(0.28),
                  focusedBorderColor: orangeColor,
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
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w400,fontColor: greyFontColor,),
                  ),
                  GestureDetector(
                    onTap: _remainingSeconds <= 0 ? ()async {
                      _startResendTimer();
                      await authController.onResendOtp(context, _mobileNumber);
                    }
                    : null,
                    child: Text(' Resend Code', style: commonTextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontColor: _remainingSeconds <= 0 ? HexColor.fromHex('#FF5200'): const Color(0xFFAAAAAA),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                _formattedTimer,
                style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w400,fontColor: greyFontColor,),
              ),
              const SizedBox(height: 20),
              LoadingButton(
                title: 'Verify & Continue',
                buttonColor: HexColor.fromHex('#F48C25'),
                borderRadius: BorderRadius.circular(12),
                height: 50,
                loading: authController.isLoading.value,
                onPressed:()=> onCheckOtpValidation(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  } 
}