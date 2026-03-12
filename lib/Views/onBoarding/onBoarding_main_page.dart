import 'package:deliverylo/Commons%20and%20Reusables/commonButton.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Views/onBoarding/onBoarding_contain.dart';
import 'package:flutter/material.dart';
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
      width: _currentPage == index ? 60 : 10,
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

  onStart() {}
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    double blockH = SizeConfig.blockH!;
    double blockV = SizeConfig.blockV!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 60,),
                      AnimatedContainer(
                        margin: EdgeInsets.symmetric(horizontal: 2,vertical: 0,),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.linear,
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            Container(
                              child: Image.asset(
                                contents[i].image,
                                // height: SizeConfig.blockV! * 56,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(contents.length, (int index) => buildDots(index: index),),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0,right: 40.0, top: 30,),
                                    child: Text(
                                      contents![i].heading,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: commonTextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0,right: 40.0, top: 0,bottom: 0),
                                    child: Text(
                                      contents![i].title,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: commonTextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        fontColor: contents[i].color
                                      ),
                                    ),
                                  ),
                                   SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60.0,vertical: 0,),
                              child: Text(
                                contents![i].subTitle,
                                textAlign: TextAlign.center,
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                               style: commonTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontColor: Colors.grey.shade400
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 36,),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _currentPage + 1 == contents.length
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 0,),
                                          child: Container(
                                            // width: 10,
                                            child: LoadingButton(
                                              buttonColor: HexColor.fromHex('#2461E1'),
                                              onPressed: () {
                                                GetStorage().write(
                                                  'onBorderDone',
                                                  true,
                                                );
                                                // Get.toNamed(Routes.LOGINPAGE);
                                              },
                                              title: 'Get Started',
                                            ),
                                          ),
                                        )
                                        : InkWell(
                                            onTap: onNext,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20,),
                                              child: Container(
                                                padding: EdgeInsets.all(6),
                                                height: 48,
                                                decoration: commonContainerBoxDecoration(containerColor:contents[i].color!,borderRadios: 13),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Next',
                                                      style: commonTextStyle(fontSize: 20, fontWeight: FontWeight.w700,fontColor: Colors.white),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          _currentPage + 1 == contents.length
                                          ? SizedBox()
                                          : Container(
                                              alignment: Alignment.centerLeft,
                                              child: InkWell(
                                                onTap: onSkip,
                                                child: Center(
                                                  child: Text(
                                                    "Skip",
                                                    style:commonTextStyle(fontSize: 16, fontWeight: FontWeight.w400,fontColor: HexColor.fromHex('#1D1D1D')),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                                ],
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
