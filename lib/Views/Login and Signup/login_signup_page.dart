import 'package:deliverylo/Commons%20and%20Reusables/commonButton.dart';
import 'package:deliverylo/Commons%20and%20Reusables/commonTextFormField.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({super.key});

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
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
          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 20),
            child: Card(
              elevation: 2,
              shadowColor: HexColor.fromHex('#F8F8F8').withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:0.0,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Get Started',style: commonTextStyle(fontSize: 32,fontWeight: FontWeight.w700,fontColor: HexColor.fromHex('#1D1D1D')),)),
                    SizedBox(height: 10,),
                    Center(
                      child: Text(
                        'Experience premium shopping\ndelivered instantly.',
                        style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w400,fontColor: HexColor.fromHex('#1D1D1D').withOpacity(0.7)),
                        textAlign: TextAlign.center,
                      )
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:22.0,vertical: 0),
                      child: Text(' Mobile Number',style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w500,fontColor: HexColor.fromHex('#1D1D1D').withOpacity(0.6)),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:22.0,vertical: 0),
                      child: TextFormFieldWidget(
                        prefixIcon: Icon(Icons.phone_outlined,color: Colors.grey,),
                        labelText: '(+91) 00000000000',
                      ),
                    ),
                    LoadingButton(
                      buttonColor:HexColor.fromHex('#F48C25'),
                      onPressed: (){},
                      title: 'Continue with Phone',
                      icon: Icon(Icons.arrow_forward,color: Colors.white,),
                      borderRadius: BorderRadius.circular(14),
                      height: 50,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: HexColor.fromHex('#1d1d1d').withOpacity(0.1),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Or continue with',
                            style: commonTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontColor: HexColor.fromHex('#B0B0B0'),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: HexColor.fromHex('#1d1d1d').withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              // TODO: handle Apple login
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'Assets/Logos/apple_logo.png',
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              // TODO: handle Google login
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'Assets/Logos/google_logo.png',
                                height: 28,
                                width: 28,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'By clicking continue, you agree to our ',
                          style: commonTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontColor: HexColor.fromHex('#1D1D1D')
                                .withOpacity(0.6),
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms \nof Service',
                              style: commonTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontColor: HexColor.fromHex('#1D1D1D'),
                              ).copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: commonTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontColor: HexColor.fromHex('#1D1D1D'),
                              ).copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

