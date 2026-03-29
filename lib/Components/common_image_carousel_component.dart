import 'dart:async';

import 'package:flutter/material.dart';

class CommonImageCarouselComponent extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Widget? fallbackWidget;
  final ValueChanged<int>? onPageChanged;

  const CommonImageCarouselComponent({
    super.key,
    required this.imageUrls,
    this.height = 84,
    this.borderRadius = 10,
    this.margin,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.fallbackWidget,
    this.onPageChanged,
  });

  @override
  State<CommonImageCarouselComponent> createState() =>
      _CommonImageCarouselComponentState();
}

class _CommonImageCarouselComponentState
    extends State<CommonImageCarouselComponent> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlayIfNeeded();
  }

  void _startAutoPlayIfNeeded() {
    if (!widget.autoPlay || widget.imageUrls.length <= 1) return;
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextIndex = (_currentIndex + 1) % widget.imageUrls.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didUpdateWidget(covariant CommonImageCarouselComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrls.length != widget.imageUrls.length ||
        oldWidget.autoPlay != widget.autoPlay ||
        oldWidget.autoPlayInterval != widget.autoPlayInterval) {
      _currentIndex = 0;
      _startAutoPlayIfNeeded();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return widget.fallbackWidget ?? const SizedBox.shrink();
    }

    return Container(
      margin: widget.margin,
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                widget.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) {
                final imageUrl = widget.imageUrls[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return widget.fallbackWidget ??
                          Container(color: Colors.grey.shade300);
                    },
                  ),
                );
              },
            ),
          ),
          if (widget.imageUrls.length > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imageUrls.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: isActive ? 36 : 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isActive ? Colors.white : Colors.white54,
                  ),
                );
              }),
            )
          ],
        ],
      ),
    );
  }
}
