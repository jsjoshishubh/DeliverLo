import 'package:deliverylo/Commons%20and%20Reusables/Validators.dart';
import 'package:deliverylo/Commons%20and%20Reusables/commonButton.dart';
import 'package:deliverylo/Commons%20and%20Reusables/commonTextFormField.dart';
import 'package:deliverylo/Controllers/Auth_Controller.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  bool autovallidate = false;
  String selectedAddress = 'Street name, Building,\nApartment...';
  bool isFetchingAddress = false;

  Future<void> _fetchCurrentAddress() async {
    if (isFetchingAddress) return;

    setState(() {
      isFetchingAddress = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    try {
      final addressData = await fetchCurrentFormattedAddress();
      final String address = (addressData['formatted_address'] ?? '').toString();
      final double latitude = (addressData['latitude'] ?? 0).toDouble();
      final double longitude = (addressData['longitude'] ?? 0).toDouble();

      if (!mounted) return;

      setState(() {
        selectedAddress = address.isEmpty ? selectedAddress : address;
      });

      authController.onSignUpChange('address', selectedAddress);
      authController.onSignUpChange('latitude', latitude.toString());
      authController.onSignUpChange('longitude', longitude.toString());
    } catch (e) {
      showSnackBar(message: e.toString(), isError: true);
    } finally {
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (mounted) {
        setState(() {
          isFetchingAddress = false;
        });
      }
    }
  }

  void _onSubmitSignup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      authController.onSignUp(context);
    } else {
      setState(() {
        autovallidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: HexColor.fromHex('#F8F8F8'),
       body: GetBuilder(
        init: authController,
        builder: (controller){
          return SafeArea(
            child: Form(
              key: _formKey,
              autovalidateMode: autovallidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 90),
                      child: Image.asset("Assets/onBoardingAndAuthFlow/login_otp.png", scale: 4.5,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Almost there!',style: commonTextStyle(fontSize: 32,fontWeight: FontWeight.w700),),
                  SizedBox(height: 5,),
                  Text('Personalize your harvest experience',style: commonTextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontColor: greyFontColor),),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 18,),
                    child: Card(
                      elevation: 2,
                      shadowColor: HexColor.fromHex('#F8F8F8').withOpacity(0.9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding: const EdgeInsets.only(left: 22.0,top: 20,bottom: 5),
                            child: Text(' Full Name',style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontColor: HexColor.fromHex('#1D1D1D',).withOpacity(0.6),),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 0,),
                            child: TextFormFieldWidget(
                              prefixIcon: Icon(Icons.person_outline_rounded,color: Colors.grey.shade400,),
                              labelText: 'Sid',
                              textInputType: TextInputType.text,
                              validator: (v) => AppFieldValidator.formEmptyText(v, 'full name'),
                              onChanged: (v) => authController.onSignUpChange('name', v),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 22.0,top: 5,bottom: 5),
                            child: Text(' Email Address',style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontColor: HexColor.fromHex('#1D1D1D',).withOpacity(0.6),),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 0,),
                            child: TextFormFieldWidget(
                              prefixIcon: Icon(Icons.mail_outline,color: Colors.grey.shade400,),
                              labelText: 'hello@example.com',
                              textInputType: TextInputType.emailAddress,
                              validator: (v) => AppFieldValidator.emailValidation(v),
                              onChanged: (v) => authController.onSignUpChange('email', v),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.only(left: 22.0,top: 5,bottom: 5),
                          //   child: Text(' Gender',style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontColor: HexColor.fromHex('#1D1D1D',).withOpacity(0.6),),),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          //   child: GenderSelector(
                          //     onChange: (data) {
                          //       authController.onLoginChange('gender', data['gender']);
                          //     },
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 22.0, top: 14, bottom: 8),
                          //   child: Text(
                          //     ' FULL ADDRESS',
                          //     style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontColor: HexColor.fromHex('#1D1D1D',).withOpacity(0.6),),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          //   child: GestureDetector(
                          //     onTap: _fetchCurrentAddress,
                          //     child: Container(
                          //       width: double.infinity,
                          //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          //       decoration: BoxDecoration(color: HexColor.fromHex('#F8F8F8'),border: Border.all(color: Colors.grey.shade300),borderRadius: BorderRadius.circular(18),),
                          //       child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Icon(
                          //             Icons.location_on_outlined,
                          //             size: 26,
                          //             color: HexColor.fromHex('#9CA3AF'),
                          //           ),
                          //           const SizedBox(width: 5),
                          //           Expanded(
                          //             child: Text(
                          //               selectedAddress,
                          //               style: commonTextStyle(
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.w300,
                          //                 fontColor: blackFontColor,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 20,),
                          LoadingButton(
                            buttonColor: orangeColor,
                            loading: authController.isLoading.value,
                            onPressed: _onSubmitSignup,
                            title: 'Verify & Continue',
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class GenderSelector extends StatefulWidget {
  final Function(Map<String, String>) onChange;
  final String? initialValue;

  const GenderSelector({
    super.key,
    required this.onChange,
    this.initialValue,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  late String selected;

  final List<String> options = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue ?? "Male";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: HexColor.fromHex('#F8F8F8'),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final item = options[index];
          final bool isSelected = selected == item;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selected = item;
                  });

                  widget.onChange({"gender": item});
                },
                child: AnimatedContainer(
                  duration: Duration.zero,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected ? Border.all(color: orangeColor, width: 1.5) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? blackFontColor : greyFontColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}