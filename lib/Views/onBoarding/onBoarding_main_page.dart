import 'package:deliverylo/Commons%20and%20Reusables/commonButton.dart';
import 'package:deliverylo/Routes/app_routes.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Views/onBoarding/onBoarding_contain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingMainPage extends StatefulWidget {
  const OnBoardingMainPage({super.key});

  @override
  State<OnBoardingMainPage> createState() => _OnBoardingMainPageState();
}

class _OnBoardingMainPageState extends State<OnBoardingMainPage> {
  final _controller = PageController();
  int _currentPage = 0;

  AnimatedContainer buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(50)),color: _currentPage == index ? contents[index!].color : Colors.grey.shade300,),
      margin: EdgeInsets.only(right: 10),
      height: 10,
      curve: Curves.linear,
      width: _currentPage == index ? 35 : 10,
    );
  }

  onNext() {
    _controller.nextPage(
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  }

  onSkip() {
    setState(() {
      _controller.jumpToPage(3);
    });
  }

  onStart() {
    GetStorage().write('onBorderDone',true,);
    Get.toNamed(Routes.SIGNUPAMDLOGIN);
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    double blockH = SizeConfig.blockH!;
    double blockV = SizeConfig.blockV!;
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8F8F8'),
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: contents.length,
              itemBuilder: (context, i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    AnimatedContainer(
                      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 0,),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.linear,
                      child: Column(
                        children: [
                          SizedBox(height:_currentPage + 1 == contents.length ? 35  :20),
                          Container(
                            child: Image.asset(
                              contents[i].image,
                              scale: 2,
                              // height: SizeConfig.blockV! * 46,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: AlignmentGeometry.topCenter,
                                end: AlignmentGeometry.bottomCenter,
                                colors: [
                                Colors.white,
                                HexColor.fromHex('#F8F8F8'),
                              ]),
                              borderRadius: BorderRadius.circular(58),
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black.withOpacity(0.07),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16,right: 16,top: 32,bottom: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(contents.length,(int index) => buildDots(index: index),),
                                  ),
                                  const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        contents![i].heading,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: commonTextStyle(
                                          fontSize: 34,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        contents![i].title,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: commonTextStyle(
                                          fontSize: 34,
                                          fontWeight: FontWeight.w700,
                                          fontColor: contents[i].color,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Text(
                                        contents![i].subTitle,
                                        textAlign: TextAlign.center,
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        style: commonTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontColor: HexColor.fromHex('#1D1D1D').withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height:  _currentPage + 1 == contents.length ? 14 : 24),
                                    Column(
                                      children: [
                                        _currentPage + 1 == contents.length
                                            ? Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 2.0,),
                                                child: LoadingButton(
                                                  buttonColor:HexColor.fromHex('#2461E1'),
                                                  onPressed: ()=> onStart(),
                                                  title: 'Get Started',
                                                ),
                                              )
                                            : InkWell(
                                                onTap: onNext,
                                                child: Container(
                                                  padding:const EdgeInsets.all(6),
                                                  margin: EdgeInsets.symmetric(horizontal: 24),
                                                  height: 48,
                                                  decoration: commonContainerBoxDecoration(containerColor:contents[i].color!,borderRadios: 12,),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Next',style: commonTextStyle(fontSize: 20,fontWeight:FontWeight.w700,fontColor: Colors.white),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      const Icon(Icons.arrow_forward,color: Colors.white,size: 17,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              _currentPage + 1 == contents.length
                                                ? const SizedBox()
                                                : InkWell(
                                                onTap: onSkip,
                                                child: Text(
                                                  "Skip",style: commonTextStyle(fontSize: 16,fontWeight:FontWeight.w400,fontColor: HexColor.fromHex('#1D1D1D')),
                                                ),
                                              ),
                                            SizedBox(height: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}
