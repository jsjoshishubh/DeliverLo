import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class MainHomeCarouselOfferComponent extends StatefulWidget {
  const MainHomeCarouselOfferComponent({super.key});

  @override
  State<MainHomeCarouselOfferComponent> createState() =>
      _MainHomeCarouselOfferComponentState();
}

class _MainHomeCarouselOfferComponentState
    extends State<MainHomeCarouselOfferComponent> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<_OfferItem> _offers = const [
    _OfferItem(
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1200&q=80',
      tagLine: 'SPECIAL OFFER',
      titleFirstPart: 'FLAT 50%',
      titleSecondPart: 'OFF',
      subtitle: 'On your first 3 orders*',
      buttonText: 'Claim Now',
    ),
    _OfferItem(
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1200&q=80',
      tagLine: 'LIMITED DEAL',
      titleFirstPart: 'SAVE 40%',
      titleSecondPart: 'TODAY',
      subtitle: 'Free delivery on selected stores',
      buttonText: 'Order Now',
    ),
    _OfferItem(
      imageUrl:
          'https://images.unsplash.com/photo-1600891964092-4316c288032e?auto=format&fit=crop&w=1200&q=80',
      tagLine: 'WEEKEND OFFER',
      titleFirstPart: 'BUY 1',
      titleSecondPart: 'GET 1',
      subtitle: 'Available on partner restaurants',
      buttonText: 'Explore',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 218,
      child: Column(
        children: [
          SizedBox(
            height: 185,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _offers.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _offers[index];
                return _OfferBanner(item: item);
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_offers.length, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: isActive ? 40 : 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? orangeColor
                      : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner({required this.item});

  final _OfferItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.62),
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.16),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 20,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.tagLine,style: commonTextStyle(fontColor: Colors.white.withValues(alpha: 0.82),fontSize: 11,fontWeight: FontWeight.w800,).copyWith(letterSpacing: 2.2),),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item.titleFirstPart} ',
                          style: commonTextStyle(
                            fontColor: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: item.titleSecondPart,
                          style: commonTextStyle(
                            fontColor: orangeColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: commonTextStyle(
                      fontColor: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10,),
                    decoration: BoxDecoration(color: orangeColor,borderRadius: BorderRadius.circular(16),),
                    child: Text(
                      item.buttonText,
                      style: commonTextStyle(
                        fontColor: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferItem {
  const _OfferItem({
    required this.imageUrl,
    required this.tagLine,
    required this.titleFirstPart,
    required this.titleSecondPart,
    required this.subtitle,
    required this.buttonText,
  });

  final String imageUrl;
  final String tagLine;
  final String titleFirstPart;
  final String titleSecondPart;
  final String subtitle;
  final String buttonText;
}
