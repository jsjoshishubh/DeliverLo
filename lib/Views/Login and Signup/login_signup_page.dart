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
          Text(
            'One app for food,\ngrocery,dining\nand more in mins!',
            textAlign: TextAlign.center,
            style: commonTextStyle(fontSize: 36,fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Get Started',style: commonTextStyle(fontSize: 32,fontWeight: FontWeight.w700,fontColor: HexColor.fromHex('#1D1D1D')),)),
                    SizedBox(height: 10,),
                    Center(
                      child: Text(
                        'Experience premium shopping\ndelivered instantly.',
                        style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w400,fontColor: HexColor.fromHex('#1D1D1DB2')),
                        textAlign: TextAlign.center,
                      )
                    ),
                    SizedBox(height: 20,),
                    Text(' Mobile Number',style: commonTextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                    TextFormFieldWidget(
                      prefixIcon: Icon(Icons.phone_outlined,color: Colors.grey,),
                      labelText: '(+91) 00000000000',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0,),
                        child: LoadingButton(
                          buttonColor:HexColor.fromHex('#F48C25'),
                          onPressed: (){},
                          title: 'Get Started',
                          icon: Icon(Icons.arrow_forward,color: Colors.white,),
                          borderRadius: BorderRadius.circular(14),
                          height: 50,
                        ),
                      )
                            
                            
                            
                            
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