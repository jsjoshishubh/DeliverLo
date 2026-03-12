import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingContents {
  final String heading;
  final String title;
  final String subTitle;
  final String image;
  final Color? color;

  OnboardingContents({
    required this.heading,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.color,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    heading: 'Delicious Food',
    title: "in 10 Mins",
    subTitle: 'Experience gourmet meals delivered to your doorstep with our premium quick-commerce service.',
    image: "Assets/onBoardingAndAuthFlow/onBarding_1.png",
    color: HexColor.fromHex('#FF7F00'),
  ),
  OnboardingContents(
    heading: 'Freshness at',
    title: "Doorstep",
    subTitle: 'Experience farm-fresh quality delivered straight to your home within minutes. We pick the best for you.',
    image: "Assets/onBoardingAndAuthFlow/onBoarding_2.png",
    color: HexColor.fromHex('#0C7820'),
  ),
  OnboardingContents(
    heading: 'Latest,',
    title: "Tech Delivered Fast",
    subTitle: "Experience the future of shopping with instant delivery on the newest electronics gadgets to your door.",
    image: "Assets/onBoardingAndAuthFlow/onBoarding_3.png",
    color: HexColor.fromHex('#256AF4'),
  ),
];