import 'package:deliverylo/Commons%20and%20Reusables/Validators.dart';
import 'package:deliverylo/Commons%20and%20Reusables/commonButton.dart';
import 'package:deliverylo/Commons%20and%20Reusables/commonTextFormField.dart';
import 'package:deliverylo/Controllers/Profile_Controller.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = _profileController.userProfileData;
    _nameController.text = (profile['displayName'] ?? profile['name'] ?? '')
        .toString()
        .trim();
    _emailController.text = (profile['email'] ?? '').toString().trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F9FAFB'),
      body: GetBuilder(
        init: _profileController,
        builder: (ProfileController profileController) => Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Container(
                margin: EdgeInsets.only(top: 60),
                child: Row(
                  children: [
                    IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                    Container(
                      width: Get.width/2.1,
                      alignment: Alignment.centerRight,
                      child: Text('Edit Profile',style: commonTextStyle(fontColor: HexColor.fromHex('#0F172A'),fontSize: 20, fontWeight: FontWeight.w700),)
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300,height: 1,),
              SizedBox(height: 2,),
               Padding(
                padding: const EdgeInsets.only(left: 22.0,top: 20,bottom: 5),
                child: Text(' Full Name',style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontColor: HexColor.fromHex('#1D1D1D',).withOpacity(0.6),),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 0,),
                child: TextFormFieldWidget(
                  controller: _nameController,
                  prefixIcon: Icon(Icons.person_outline_rounded,color: Colors.grey.shade400,),
                  labelText: 'Sid',
                  textInputType: TextInputType.text,
                  validator: (v) => AppFieldValidator.formEmptyText(v, 'full name'),
                  onChanged: (v){},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0,top: 5,bottom: 5),
                child: Text(' Email Address',style: commonTextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontColor: HexColor.fromHex('#1D1D1D',).withOpacity(0.6),),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 0,),
                child: TextFormFieldWidget(
                  controller: _emailController,
                  prefixIcon: Icon(Icons.mail_outline,color: Colors.grey.shade400,),
                  labelText: 'hello@example.com',
                  textInputType: TextInputType.emailAddress,
                  validator: (v) => AppFieldValidator.emailValidation(v),
                  onChanged: (v) {},
                ),
              ),

              SizedBox(height: 20,),
              LoadingButton(
                buttonColor: orangeColor,
                loading: profileController.loading,
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (!isValid) return;
                  _formKey.currentState?.save();

                  final payload = <String, dynamic>{
                    'name': _nameController.text.trim(),
                    'displayName': _nameController.text.trim(),
                    'email': _emailController.text.trim(),
                  };
                  final isUpdated = await _profileController.updateUserProfile(payload);
                  if (isUpdated && mounted) {
                    Get.back();
                  }
                },
                title: 'Update Profile',
              ),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}